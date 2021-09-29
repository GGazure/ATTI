//
//  PickImgViewController.swift
//  Atti
//
//  Created by Yujin Cha on 2021/09/28.
//

import UIKit
import Photos
import BSImagePicker
import CoreData
import Alamofire

class PickImgViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedAssets: [PHAsset] = []
    var userSelectedImages: [UIImage] = []
    
    @IBAction func title(_ sender: UITextField) {
        titlestr = sender.text ?? "무제"
    }
    @IBOutlet weak var body: UITextView!
    
    var titlestr: String = "무제"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        body.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        body.layer.borderWidth = 1.0
        body.layer.borderColor = UIColor.black.cgColor

    }
    @IBAction func saveDiary(_ sender: Any) {
        print("다이어리 쓰기")
        
        postTest()
        
    }
    
    @IBAction func pressedAddButton(_ sender: UIButton) {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 10
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        let vc = self
        vc.presentImagePicker(imagePicker, select: { (asset) in
            
        }, deselect: { (asset) in
            
        }, cancel: { (assets) in
            
        }, finish: { (assets) in
            for i in 0..<assets.count {
                self.selectedAssets.append(assets[i])
            }
            self.convertAssetToImages()
            self.selectedAssets = []
            self.collectionView.reloadData()
        })
    }
    
    
    func convertAssetToImages() {
        if selectedAssets.count != 0 {
            for i in 0..<selectedAssets.count {
                let imageManager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: selectedAssets[i],
                                            targetSize: CGSize(width: 200, height: 200),
                                            contentMode: .aspectFit,
                                            options: option) { (result, info) in thumbnail = result! }
                    
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                    
                self.userSelectedImages.append(newImage! as UIImage)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userSelectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! imgCell
        
        cell.img.image = squareImg(img: userSelectedImages[indexPath.row], length: collectionView.bounds.width-100)
        
        return cell
    }
    
    func squareImg(img: UIImage, length: CGFloat = 100) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: length, height: length))
        UIRectFill(CGRect(x: 0, y: 0, width: length, height: length))
        
        var reW = CGFloat(0)
        var reH = CGFloat(0)
        let sizeRatio = length / max(img.size.width, img.size.height)
        if img.size.width > img.size.height {
            reW = length
            reH = img.size.height * sizeRatio
        }
        else {
            reH = length
            reW = img.size.width * sizeRatio
        }
        
        img.draw(in: CGRect(x: length/2 - reW/2, y: length/2 - reH/2, width: reW, height: reH))
        let reImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reImg
    }
    
    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width-100)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) ->
    UICollectionReusableView {
        let footerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "imgCollectionReusable", for: indexPath) as! imgCollectionReusable
        
        footerview.frame.size.width = collectionView.bounds.width-100
        footerview.frame.size.height = collectionView.bounds.width-100
        footerview.addimgBtn.addTarget(self, action: #selector(pressedAddButton(_:)), for: .touchUpInside)
        
        return footerview
    }
    
    
    func postTest() {
        let url = "http://svc.saltlux.ai:31781"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
            
        
            // POST 로 보낼 정보
        let arg = ["type":"1", "query":body.text as String] as Dictionary
        let params = ["key":"aa121118-e337-4242-80f8-1439d1b4c7b5", "serviceId":"11987300804", "argument": arg] as Dictionary
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
            
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success(_):
                guard let res = response.data else {return}
                do {
                    print("It worked!")
                    
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(Feelings.self, from: res)
                    
                    if json.result.count > 0 {
                        let str = json.result[0][1]
                        switch str {
                        case .string(let x):
                            self.afterGetFeelings(feelings: x)
                        case .double(_): break
                        }
                    }
                    else{
                        self.afterGetFeelings(feelings: "")
                    }
                        
                } catch {
                    print("error!\(error)")
                }
                
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    func afterGetFeelings(feelings: String) {
        print("다이어리 저장")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Diary", into: context)
        object.setValue(titlestr, forKey: "title")
        object.setValue(body.text, forKey: "body")
        object.setValue(Date(), forKey: "writedate")
        object.setValue(feelings, forKey: "feeling")
        for i in 0..<userSelectedImages.count {
            object.setValue(userSelectedImages[i].pngData(), forKey: "img" + String(i))
        }
        object.setValue(userSelectedImages.count, forKey: "imgSize")
        
        do{
            try context.save()
        } catch {
            context.rollback()
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
   
// https://app.quicktype.io
struct Feelings: Codable {
    let query, type: String
    let result: [[Result]]

    enum CodingKeys: String, CodingKey {
        case query, type
        case result = "Result"
    }
}

enum Result: Codable {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Result.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Result"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}



// cell 클래스
class imgCell : UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    
}

class imgCollectionReusable : UICollectionReusableView {
    @IBOutlet weak var addimgBtn: UIButton!
}
