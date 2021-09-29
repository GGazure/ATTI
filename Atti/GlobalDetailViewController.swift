//
//  GlobalDetailViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/17.
//

import UIKit
import FirebaseDatabase

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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editDiary))
       
        diaryTitle.text = diaryDetail?.name
        diaryContent.text = diaryDetail?.name
        
        
        diaryTitle.isUserInteractionEnabled = true
        diaryContent.isUserInteractionEnabled = true
        
        imageArray = [#imageLiteral(resourceName: "Unknown-3"),#imageLiteral(resourceName: "Unknown"),#imageLiteral(resourceName: "Unknown-1"),#imageLiteral(resourceName: "Unknown-2")]
    }
    
    // Firebase에 다이어리 수정 반영
    @objc func editDiary() {
        let diaryID = diaryDetail?.id
        ref.child("Item\(diaryID!)").updateChildValues(["name":diaryTitle.text as Any])
        
        // 이전 뷰로 돌아가기
        navigationController?.popViewController(animated: true)
    }
    
    
    

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
//        let width = (collectionView.bounds.width - 64)
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
