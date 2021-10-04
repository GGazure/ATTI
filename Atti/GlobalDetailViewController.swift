//
//  GlobalDetailViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/17.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage


class GlobalDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var diaryContent: UITextView!
    @IBOutlet var diaryTitle: UITextField!
    
    var imageArray = [UIImage]()
    var diaryDetail: Diary?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Firebase 버튼
        let editButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editDiary))
        let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteBtnClicked))
        let uploadButton = UIBarButtonItem(title: "업로드", style: .plain, target: self, action: #selector(uploadToDatabase))
        
        navigationItem.rightBarButtonItems = [deleteButton,editButton,uploadButton]
        
        diaryTitle.text = diaryDetail?.title
        diaryContent.text = diaryDetail?.content
        
        let imageURL = URL(string: diaryDetail!.imageURL)
        let data = try? Data(contentsOf: imageURL!)
        imageArray.append(UIImage(data: data!)!)
        
        diaryTitle.isUserInteractionEnabled = true
        diaryContent.isUserInteractionEnabled = true
        
//        imageArray = [#imageLiteral(resourceName: "KakaoTalk_Photo_2021-10-04-15-12-48.jpeg"),#imageLiteral(resourceName: "Unknown-3"),#imageLiteral(resourceName: "Unknown"),#imageLiteral(resourceName: "Unknown-1"),#imageLiteral(resourceName: "Unknown-2")]
    }
    
    // Firebase - 다이어리 수정
    @objc func editDiary() {
        
        // Option1 : id 알 수 있는 경우
//        let diaryID = diaryDetail?.id
//        ref.child("Item\(diaryID!)").updateChildValues(["name":diaryTitle.text as Any])
        
        // Option2 : id 모르는 경우 특정 값 검색하기
        let diaryName = diaryDetail?.title
        ref.queryOrdered(byChild: "title").queryEqual(toValue: diaryName).observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String:[String:Any]],
                  let key = value.keys.first else { return }
            self.ref.child("\(key)").updateChildValues(["title": self.diaryTitle.text as Any])
        }
        
        // 이전 뷰로 돌아가기
        navigationController?.popViewController(animated: true)
    }
    
    
    // 다이어리 삭제 버튼 action
    @objc func deleteBtnClicked() {
        let ac = UIAlertController(title: "", message: "해당 다이어리를 삭제하시겠습니까?", preferredStyle: .alert)
        
        let removeDiary = UIAlertAction(title: "삭제", style: .destructive) { action in
            self.deleteDiary()
        }
            
        ac.addAction(removeDiary)
        ac.addAction(UIAlertAction(title: "아니요", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    // Firebase - 다이어리 삭제
    func deleteDiary() {
        
        // Option1 : id 알 수 있는 경우
//       let diaryID = diaryDetail?.id
//       ref.child("Item\(diaryID!)").removeValue()
    
        // Option2 : id 모르는 경우 특정 값 검색하기
       let diaryName = diaryDetail?.title
       ref.queryOrdered(byChild: "title").queryEqual(toValue: diaryName).observe(.value) { [weak self] snapshot in
           guard let self = self,
                 let value = snapshot.value as? [String:[String:Any]],
                 let key = value.keys.first else { return }
           self.ref.child("\(key)").removeValue()
       }

        navigationController?.popViewController(animated: true)
    }
    
    
    // Firebase - 다이어리 추가
    @objc func uploadToDatabase() {
        
        self.uploadImage(imageArray[0]) { url in
            self.saveImage(title: self.diaryTitle.text!, imageURL: url!) { success in
                if success != nil {
                    print("Yeah yes")
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    // FireStorage - image 저장
    func uploadImage(_ image: UIImage, completion: @escaping (_ url: URL?) -> ()) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = formatter.string(from: Date())
        
        let storageRef = Storage.storage().reference().child("\(date).png")
        let imgData = imageArray[0].pngData()
        let metaData = StorageMetadata()
        
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData) { metaData, error in
            if error == nil {
                print("success")
                storageRef.downloadURL(completion: { url, error in
                    completion(url!)
                })
            } else {
                print("error in save image")
                completion(nil)
            }
        }
    }
    
    
    func saveImage(title: String, imageURL:URL, completion: @escaping ((_  url: URL?) -> ())) {
        let object: [String: String] = [
            "title" : diaryTitle.text ?? "",
            "content" : diaryContent.text ?? "",
            "imageURL" : imageURL.absoluteString
        ]
        
        ref.childByAutoId().setValue(object)
    }
}


extension GlobalDetailViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageArray cell", for: indexPath) as! ImageArrayCell
        
        cell.diaryImage.image = imageArray[indexPath.row]
        return cell
    }
    
    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        
        return CGSize(width: height/4*3, height: height)
    }
 
    
    // 좌우 cell 간의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 16
    }
    
    // collectionView의 상하좌우 간격 값
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    }
}

class ImageArrayCell : UICollectionViewCell {
    @IBOutlet var diaryImage: UIImageView!
}
