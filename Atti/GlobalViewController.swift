//
//  GlobalViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/15.
//

import UIKit

class GlobalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionView delegate, datasource 연결
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    // cell 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlobalCell", for: indexPath) as! GlobalCell
        cell.globalImage.backgroundColor = .blue
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
}

// cell 클래스
class GlobalCell : UICollectionViewCell {
    @IBOutlet var globalImage: UIImageView!
}
