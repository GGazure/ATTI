//
//  DiaryViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/26.
//

import UIKit

class DiaryViewController: UIViewController {
    
    
    var diaryImage: UIImageView!
    var diaryTitle: UITextField!
    var diaryContent: UITextView!
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        diaryImage = UIImageView()
        
        diaryTitle = UITextField()
        diaryTitle.placeholder = "Title.."
        diaryTitle.isUserInteractionEnabled = true
        diaryTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
      
        diaryContent = UITextView()

        
        [diaryImage,diaryTitle,diaryContent].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0!)
            $0?.backgroundColor = .blue
        }


        NSLayoutConstraint.activate([
            diaryImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            diaryImage.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            diaryImage.heightAnchor.constraint(equalToConstant: 400),
            diaryImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            diaryTitle.topAnchor.constraint(equalTo: diaryImage.bottomAnchor, constant: 30),
            diaryTitle.centerXAnchor.constraint(equalTo: diaryImage.centerXAnchor),
            diaryTitle.heightAnchor.constraint(equalToConstant: 28),
            diaryTitle.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),

            diaryContent.topAnchor.constraint(equalTo: diaryTitle.bottomAnchor, constant: 30),
            diaryContent.centerXAnchor.constraint(equalTo: diaryTitle.centerXAnchor),
            diaryContent.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
            diaryContent.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
