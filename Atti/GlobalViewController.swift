//
//  GlobalViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/15.
//

import UIKit
import FirebaseDatabase

class GlobalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var ref: DatabaseReference! //Firebase Realtime Database reference
    var diaryList : [Diary] = []
    var artistDiaryList : [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionView delegate, datasource 연결
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Firebase 가 Atti database 찾을 수 있게
        ref = Database.database().reference()
        
        ref.observe(.value) { snapshot in
            // -> DB 형식 맞게 나중에 바꿔주기
            guard let value = snapshot.value as? [String: [String:Any]] else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String: Diary].self, from: jsonData)
                let cardList = Array(cardData.values)
                
                // -> 정렬 순서 나중에 바꾸기
//                self.diaryList = cardList.sorted { $0.rank < $1.rank }
                self.diaryList = cardList
                
                // UI main thread에서 처리
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch let error {
                print(error)
                print("ERROR JSON parsing \(error.localizedDescription)")
                
            }
        }
    }
    
    // cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        diaryList.count
       // 10
    }
    
    // cell 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlobalCell", for: indexPath) as! GlobalCell
        
        // -> Image data 형식 변경하기
        let imageURL = URL(string: diaryList[indexPath.row].imageURL)
        let data = try? Data(contentsOf: imageURL!)
        
        cell.globalImage.image = UIImage(data: data!)
        cell.globalTitle.text = diaryList[indexPath.row].title
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 8
        
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Diary detail 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "GlobalDetailViewController") as? GlobalDetailViewController else { return }
        detailViewController.diaryDetail = diaryList[indexPath.row]
        detailViewController.ref = self.ref
        self.show(detailViewController, sender: nil)
    }
}

// cell 클래스
class GlobalCell : UICollectionViewCell {
    @IBOutlet var globalImage: UIImageView!
    @IBOutlet var globalTitle: UILabel!
}
