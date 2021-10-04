//
//  SNSViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/15.
//
import SwiftUI
import UIKit

class SNSViewController: UIViewController {

    let contentView = UIHostingController(rootView: TwitterView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstraints()
    }
    
    fileprivate func setupConstraints(){
       contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
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
