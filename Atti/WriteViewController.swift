//
//  WriteViewController.swift
//  Atti
//
//  Created by Yujin Cha on 2021/09/28.
//

import UIKit

class WriteViewController: UIViewController {

    var btn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = .blue
        self.view.addSubview(btn)
        
    }
    


}
