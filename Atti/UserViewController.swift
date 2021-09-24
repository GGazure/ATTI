//
//  UserViewController.swift
//  Atti
//
//  Created by 장선영 on 2021/09/15.
//

import UIKit

class UserViewController: UIViewController {

    var stackView: UIStackView!
    var userView: UIStackView!
    var followView: UIStackView!
    var postStackView: UIStackView!
    var postSize: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postSize = Int(self.view.bounds.width / 2 - 20)
        
        setupuserView()
        setupfollowView()
        setupScrollView()
    }
    
    private func setupuserView(){
        userView = UIStackView()
        userView.axis = .vertical
        userView.distribution = .fill
        userView.alignment = .center
        userView.spacing = 20
        
        userView.addArrangedSubview(UIView())
    
        let profileImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        profileImg.layer.cornerRadius = 40
        profileImg.backgroundColor = #colorLiteral(red: 0.8756349477, green: 0.9197035373, blue: 1, alpha: 1)
        profileImg.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImg.widthAnchor.constraint(equalToConstant: 80).isActive = true
        userView.addArrangedSubview(profileImg)
        
        let name = UILabel()
        name.text = "Name"
        name.textAlignment = .center
        userView.addArrangedSubview(name)
        
        userView.setCustomSpacing(10, after: name)
        
        let email = UILabel()
        email.text = "Email@gmail.com"
        email.textAlignment = .center
        email.font = UIFont.systemFont(ofSize: 14)
        email.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        userView.addArrangedSubview(email)
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        btn.backgroundColor = .blue
        btn.setTitle("Follow", for: .normal)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(addfunc), for: .touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userView.addArrangedSubview(btn)
        
        userView.addArrangedSubview(UIView())
    }
    
    private func makeFollow(num: Int, descript: String) -> UIStackView{
        let stV = UIStackView()
        stV.axis = .vertical
        stV.distribution = .fill
        let number = UILabel()
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        number.text = numberFormatter.string(for: num)!
        number.textColor = .black
        number.textAlignment = .center
        number.font = UIFont.systemFont(ofSize: 17)
        
        let description = UILabel()
        description.text = descript
        description.textColor = .black
        description.textAlignment = .center
        description.font = UIFont.systemFont(ofSize: 14)
        description.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        stV.addArrangedSubview(number)
        stV.addArrangedSubview(description)
        return stV
    }
    
    private func setupfollowView(){
        let following = makeFollow(num: 245, descript: "Following")
        let followers = makeFollow(num: 4679, descript: "Followers")
        let likes = makeFollow(num: 236000, descript: "likes received")
        
        followView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
        followView.addArrangedSubview(following)
        followView.addArrangedSubview(followers)
        followView.addArrangedSubview(likes)
        
        followView.axis = .horizontal
        followView.distribution = .fillEqually
        followView.alignment = .fill
        followView.spacing = 0
        
        followView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        followView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
    }
    
    private func setupScrollView(){
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        self.stackView = stackView
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(userView)
        let line1 = makeLine(width: self.view.bounds.width, height: 1)
        stackView.addArrangedSubview(line1)
        
        stackView.addArrangedSubview(followView)
        
        let line2 = makeLine(width: self.view.bounds.width, height: 1)
        stackView.addArrangedSubview(line2)
        
        postStackView = UIStackView()
        postStackView.axis = .vertical
        postStackView.alignment = .fill
        postStackView.distribution = .fill
        postStackView.spacing = 10
        postStackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(postStackView)
    }
    
    @objc func addfunc(){
        let HstackView = UIStackView()
        HstackView.axis = .horizontal
        HstackView.distribution = .equalSpacing
        HstackView.alignment = .fill
        HstackView.spacing = 10
        HstackView.addArrangedSubview(UIView())
        HstackView.addArrangedSubview(makePost())
        HstackView.addArrangedSubview(makePost())
        HstackView.addArrangedSubview(UIView())
        
        postStackView.addArrangedSubview(HstackView)
    }

    private func makePost() -> UIView{
        let imgV = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        var img = UIImage(named: "image-solid")
        
        img = img?.withTintColor(.white)
        imgV.image = img
        
        let post = UIView(frame: CGRect(x:0, y: 0, width: postSize, height: postSize))
        
        post.backgroundColor = #colorLiteral(red: 0.8756349477, green: 0.9197035373, blue: 1, alpha: 1)
        post.layer.cornerRadius = 10
        imgV.center = CGPoint(x: post.frame.size.width / 2,
                                     y: post.frame.size.height / 2)
        post.addSubview(imgV)
        
        post.heightAnchor.constraint(equalToConstant: CGFloat(postSize)).isActive = true
        post.widthAnchor.constraint(equalToConstant: CGFloat(postSize)).isActive = true
        
        return post
    }
 
    private func makeLine(width: CGFloat, height: CGFloat) -> UIView{
        let line = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        line.backgroundColor = #colorLiteral(red: 0.9372986469, green: 0.9372986469, blue: 0.9372986469, alpha: 1)
        line.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        line.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        return line
    }

}
