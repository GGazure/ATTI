//
//  UserViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/15.
//

import UIKit
import CoreData

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    var isSelected: Bool = false
    var selected: Int = -1
    
    var list: [NSManagedObject]!
    
    func fetch() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Diary")
        
        let sort = NSSortDescriptor(key: "writedate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        let res = try! context.fetch(fetchRequest)
        return res
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = self.fetch()
        if list.count != 0 {
            for i in 0...(list.count-1){
                print(i)
            }
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        list = self.fetch()
        collectionView.reloadData()
    }
    
    func mydelete(object: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(object)
        
        do {
            try context.save()
            list = self.fetch()
            self.collectionView.reloadData()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    // cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.list.count
    }
    
    // cell 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        
        cell.DiaryImg.layer.cornerRadius = 8
        if list[indexPath.row].value(forKey: "imgSize") as! Int > 0 {
            let unencodedData = list[indexPath.row].value(forKey: "img0") as? Data
            cell.DiaryImg.image = squareImg(img: UIImage(data: unencodedData!)!, length: (cell.DiaryImg.image?.size.width)!)
        }
        else {
            cell.DiaryImg.image = UIImage(named: "Unknown")
        }
        
        let date = list[indexPath.row].value(forKey: "writedate") as! NSDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.HH:mm"
        cell.Diarydate.text = dateFormatter.string(from: date as Date)
        // cell.Diarydate.text = list[indexPath.row].value(forKey: "feeling") as! String
        
        cell.Diarytitle.text = list[indexPath.row].value(forKey: "title") as! String
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    func squareImg(img: UIImage, length: CGFloat = 100) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: length, height: length))
        UIRectFill(CGRect(x: 0, y: 0, width: length, height: length))
        
        var reW = CGFloat(0)
        var reH = CGFloat(0)
        let sizeRatio = length / max(img.size.width, img.size.height)
        if img.size.width < img.size.height {
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) ->
    UICollectionReusableView {
        //ofKind에 UICollectionView.elementKindSectionHeader로 헤더를 설정해주고
                //withReuseIdentifier에 헤더뷰 identifier를 넣어주고
                //생성한 헤더뷰로 캐스팅해준다.
        let headerview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "reusableView", for: indexPath) as! reusableView
        
        headerview.UserImg.layer.cornerRadius = 40
        headerview.UserImg.backgroundColor =  #colorLiteral(red: 0.8756349477, green: 0.9197035373, blue: 1, alpha: 1)
        headerview.UserImg.heightAnchor.constraint(equalToConstant: 80).isActive = true
        headerview.UserImg.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        headerview.UserName.text = "Name"
        headerview.UserName.textAlignment = .center
        
        headerview.UserEmail.text = "Email@gmail.com"
        headerview.UserEmail.textAlignment = .center
        headerview.UserEmail.font = UIFont.systemFont(ofSize: 14)
        headerview.UserEmail.textColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        headerview.UserBtn.backgroundColor = .blue
        headerview.UserBtn.setTitle("Follow", for: .normal)
        headerview.UserBtn.layer.cornerRadius = 5
        headerview.UserBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        
        return headerview
    }


    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width-42)/2
        return CGSize(width: width, height: width/3*4)
    }
    
    // 아래 cell 과의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 32
    }
    
    // 좌우 cell 간의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    // collectionView의 상하좌우 간격 값
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 30, left: 16, bottom: 10, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
      didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) clicked")
        // mydelete(object: list[indexPath.row])
        selected = indexPath.row
        isSelected = true
        self.performSegue(withIdentifier: "SegueUserDetailVC", sender: indexPath)
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if isSelected == true && segue.identifier == "SegueUserDetailVC" {
            isSelected = false
            let nextVC = segue.destination as! UserDetailViewController
            
            var sz = list[selected].value(forKey: "imgSize") as! Int
            if sz > 0 {
                for i in 0..<sz {
                    let unencodedData = list[selected].value(forKey: "img" + String(i)) as? Data
                    nextVC.imageArray.append(UIImage(data: unencodedData!)!)
                }
            }
            else {
                nextVC.imageArray = []
            }
            print(selected, sz)
            nextVC.titlestr = list[selected].value(forKey: "title") as! String
            
            let date = list[selected].value(forKey: "writedate") as! NSDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd.HH:mm"
            nextVC.datestr = dateFormatter.string(from: date as Date)
            
            nextVC.bodystr = list[selected].value(forKey: "body") as! String
            nextVC.feelings = list[selected].value(forKey: "feeling") as! String
            
        }
    }
    
}

// cell 클래스
class DiaryCell : UICollectionViewCell {
    @IBOutlet weak var DiaryImg: UIImageView!
    @IBOutlet weak var Diarytitle: UILabel!
    @IBOutlet weak var Diarydate: UILabel!
    
}

class reusableView : UICollectionReusableView {
    @IBOutlet weak var UserImg: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserEmail: UILabel!
    @IBOutlet weak var UserBtn: UIButton!
    
}
