//
//  UserDetailViewController.swift
//  Atti
//
//  Created by Yujin Cha on 2021/10/04.
//

import UIKit

class UserDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /*
    var arr: [[(String, String)]] = [
        [("지금 날 위한 축배를 짠짠짠", "붐바야"), ("좋아 난 지금 네가 좋아", "붐바야")],
        [("또 이 어려운 걸 해내지", "Pretty Savage"), ("굳이 말 안 해도 다 알잖아", "Pretty Savage")],
        [("공포", "제목")],
        [("놀라움", "제목")],
        [("툭하면 거친 말들로 내 맘에 상처를 내놓고", "STAY"), ("널 닮은 듯한 슬픈 멜로디", "STAY"), ("어두운 밤이 날 가두기 전에 내 곁을 떠나지마", "STAY")],
        [("실컷 비웃어라 꼴좋으니까", "How You Like That")],
        [("그때쯤에 넌 날 끝내야 했어", "How You Like That")],
        [("One two three 새로운 시작이야", "마지막처럼"), ("얼굴이 뜨겁고 가슴은 계속 뛰어", "마지막처럼")]
    ]
     */
    var arr: [[(String, String)]] = [
        [("너 뭔데 자꾸 생각나 자존심 상해 애가 타", "마지막처럼"), ("얼굴이 뜨겁고 가슴은 계속 뛰어", "마지막처럼"), ("내 몸이 맘대로 안 돼 어지러워", "마지막처럼")],
        [("너 뭔데 자꾸 생각나 자존심 상해 애가 타", "마지막처럼"), ("얼굴이 뜨겁고 가슴은 계속 뛰어", "마지막처럼"), ("내 몸이 맘대로 안 돼 어지러워", "마지막처럼")],
        [("너 뭔데 자꾸 생각나 자존심 상해 애가 타", "마지막처럼"), ("얼굴이 뜨겁고 가슴은 계속 뛰어", "마지막처럼"), ("내 몸이 맘대로 안 돼 어지러워", "마지막처럼")],
        [("너 뭔데 자꾸 생각나 자존심 상해 애가 타", "마지막처럼"), ("얼굴이 뜨겁고 가슴은 계속 뛰어", "마지막처럼"), ("내 몸이 맘대로 안 돼 어지러워", "마지막처럼")],
        [("너 뭔데 자꾸 생각나 자존심 상해 애가 타", "마지막처럼"), ("얼굴이 뜨겁고 가슴은 계속 뛰어", "마지막처럼"), ("내 몸이 맘대로 안 돼 어지러워", "마지막처럼")],
        [("너 뭔데 자꾸 생각나 자존심 상해 애가 타", "마지막처럼"), ("얼굴이 뜨겁고 가슴은 계속 뛰어", "마지막처럼"), ("내 몸이 맘대로 안 돼 어지러워", "마지막처럼")],
        [("너 뭔데 자꾸 생각나 자존심 상해 애가 타", "마지막처럼"), ("얼굴이 뜨겁고 가슴은 계속 뛰어", "마지막처럼"), ("내 몸이 맘대로 안 돼 어지러워", "마지막처럼")],
        [("너 뭔데 자꾸 생각나 자존심 상해 애가 타", "마지막처럼"), ("얼굴이 뜨겁고 가슴은 계속 뛰어", "마지막처럼"), ("내 몸이 맘대로 안 돼 어지러워", "마지막처럼")],
    ]
    
    var dic: [String:Int] = ["기쁨":0, "신뢰":1, "공포":2, "놀라움":3, "슬픔":4, "혐오":5, "분노":6, "기대":7]
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var lyrics: UILabel!
    var feelings: String = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray = [UIImage]()
    
    @IBOutlet weak var dairyTitle: UILabel!
    @IBOutlet weak var diaryDate: UILabel!
    @IBOutlet weak var body: UITextView!
    var titlestr: String = ""
    var datestr: String = ""
    var bodystr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        dairyTitle.text = titlestr
        diaryDate.text = datestr
        body.text = bodystr
        
        let feelingInd = dic[feelings]!
        let lyricind = Int.random(in: 0...arr[feelingInd].count-1)
        lyrics.text = arr[feelingInd][lyricind].0
        songTitle.text = arr[feelingInd][lyricind].1
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserImageArray cell", for: indexPath) as! UserImageArrayCell
        cell.img.image = imageArray[indexPath.row]
    
        return cell
    }
    
    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.bounds.width - 64)
        let height = collectionView.bounds.height
        return CGSize(width: height, height: height)
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

class UserImageArrayCell : UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
}
