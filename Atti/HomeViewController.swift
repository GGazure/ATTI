//
//  HomeViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/15.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var artistImage: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var rankButton: UIButton!
    
    var imageArray = [UIImage]()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        imageArray = [#imageLiteral(resourceName: "bpalbum3"),#imageLiteral(resourceName: "bpalbum2"),#imageLiteral(resourceName: "bpalbum1"),#imageLiteral(resourceName: "bpalbum4")]
        artistImage.image = UIImage(named: "Unknown-1")
        artistImage.contentMode = .scaleAspectFill
        
        rankButton.backgroundColor = .lightGray
        rankButton.alpha = 0.5
        
        [artistImage,rankButton].forEach {
            $0.layer.cornerRadius = 10
        }
    }
}

extension HomeViewController {
    
    // cell 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    // cell 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        cell.albumImage.image = imageArray[indexPath.row]
        cell.albumImage.layer.cornerRadius = 10

        return cell
    }
    
    // cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    // 좌우 cell 간의 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
}

class AlbumCell : UICollectionViewCell {
    @IBOutlet var albumImage: UIImageView!
    
}
