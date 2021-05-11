//
//  ScreenInformationViewController.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 08.05.2021.
//

import UIKit

class ScreenInformationViewController: UIViewController {

    public var userInformation: UserInformationModel?
    // MARK: Объявление переменных
    lazy var avatarImageView: UIImageView = UIImageView()
    
    lazy var profileInformationStackView: UIStackView = UIStackView()
    
    // MARK: Profile
    lazy var fullNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var shortNameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    lazy var profileIconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "profile_ic")
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return imageView
    }()
    
    lazy var profileStackView: UIStackView = UIStackView()
    
    // MARK: Email
    lazy var emailLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var emailIconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "email_ic")
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return imageView
    }()
    
    lazy var emailStackView: UIStackView = UIStackView()
    
    // MARK: City
    lazy var cityLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var cityIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "city_ic")
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return imageView
    }()
    
    lazy var cityStackView: UIStackView = UIStackView()
    
    // MARK: AnonymDate
    lazy var anonymDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var anonymDateIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "anonym_ic")
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return imageView
    }()
    
    lazy var anonymStackView: UIStackView = UIStackView()
    
    lazy var headerBackgroundView: UIView = {
        let view = UIView()
        view.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
        
        return view
    }()
    
    // MARK: Wallet
    lazy var walletLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Wallet"
        
        return label
    }()
    
    lazy var walletSmallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    lazy var walletStackView: UIStackView = UIStackView()
    
    // MARK: Points
    lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Evaluation points"
        
        return label
    }()
    
    lazy var pointsSmallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    lazy var pointsStackView: UIStackView = UIStackView()
    
    // MARK: Cursus
    lazy var cursusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Cursus"
        
        return label
    }()
    
    lazy var cursusSmallButton: UIButton = UIButton()
    
    lazy var cursusStackView: UIStackView = UIStackView()
    
    // MARK: Grade
    lazy var gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Grade"
        
        return label
    }()
    
    lazy var gradeSmallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    lazy var gradeStackView: UIStackView = UIStackView()
    
    // MARK: Lavel
    lazy var lavelBackgroundView: UIView = {
        let view = UIView()
        view.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
        
        return view
    }()
    lazy var lavelView: UIView = {
        let view = UIView()
        view.roundCorners([.topLeft, .bottomLeft], radius: 5)
        
        return view
    }()
    lazy var lavelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        settingConstraints()
        settingData()
    }
    
    func settingData() {
        guard let userInfo = userInformation else { return }
        var imageURL = URL(string: userInfo.imageUrl)
        var imageData: NSData?
        if let imageURL = imageURL {
            imageData = NSData(contentsOf: imageURL)
        } else { return }
        if let imageData = imageData {
            avatarImageView.image = UIImage(data: imageData as Data)
        } else { avatarImageView.image = UIImage(named: "profile_ic")}
        
        fullNameLabel.text = userInfo.fullName
        shortNameLabel.text = userInfo.login
        emailLabel.text = userInfo.email
        cityLabel.text = userInfo.campus[0].name
        
//        TODO: Исправить обрезание строки даты
        let str = userInfo.anonymizeDate
        if let range = str.range(of: "T") {
            let res = str.substring(from: range.upperBound)
            anonymDateLabel.text = res
        } else { anonymDateLabel.text = "2022-04-29" }
        
        walletSmallLabel.text = String(userInfo.wallet)
        pointsSmallLabel.text = String(userInfo.correctionPoint)
        cursusSmallButton.titleLabel?.text = "42\u{02C5}"
        gradeSmallLabel.text = userInfo.userCourse[0].grade
        
        
        anonymDateIconImageView.image = UIImage(named: "anonym_ic")
        anonymDateIconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        anonymDateIconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func settingStackView() {
        profileStackView.spacing = 10
        profileStackView.axis = .horizontal
        profileStackView.addArrangedSubview(fullNameLabel)
        profileStackView.addArrangedSubview(shortNameLabel)
        profileStackView.addArrangedSubview(profileIconImageView)
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileStackView)
        
        emailStackView.spacing = 10
        emailStackView.axis = .horizontal
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailIconImageView)
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailStackView)
        
        cityStackView.spacing = 10
        cityStackView.axis = .horizontal
        cityStackView.addArrangedSubview(cityLabel)
        cityStackView.addArrangedSubview(cityIconImageView)
        cityStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cityStackView)

        anonymStackView.spacing = 10
        anonymStackView.axis = .horizontal
        anonymStackView.addArrangedSubview(anonymDateLabel)
        anonymStackView.addArrangedSubview(anonymDateIconImageView)
        anonymStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(anonymStackView)
        
        walletStackView.spacing = 5
        walletStackView.axis = .vertical
        walletStackView.alignment = .center
        walletStackView.addArrangedSubview(walletLabel)
        walletStackView.addArrangedSubview(walletSmallLabel)
        walletStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(walletStackView)
        
        pointsStackView.spacing = 5
        pointsStackView.axis = .vertical
        pointsStackView.alignment = .center
        pointsStackView.addArrangedSubview(pointsLabel)
        pointsStackView.addArrangedSubview(pointsSmallLabel)
        pointsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pointsStackView)
        
        cursusStackView.spacing = 5
        cursusStackView.axis = .vertical
        cursusStackView.alignment = .center
        cursusStackView.addArrangedSubview(cursusLabel)
        cursusStackView.addArrangedSubview(cursusSmallButton)
        cursusStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cursusStackView)
        
        gradeStackView.spacing = 5
        gradeStackView.axis = .vertical
        gradeStackView.alignment = .center
        gradeStackView.addArrangedSubview(gradeLabel)
        gradeStackView.addArrangedSubview(gradeSmallLabel)
        gradeStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradeStackView)
        
        profileInformationStackView.spacing = 10
        profileInformationStackView.axis = .vertical
        profileInformationStackView.alignment = .trailing
        profileInformationStackView.addArrangedSubview(profileStackView)
        profileInformationStackView.addArrangedSubview(emailStackView)
        profileInformationStackView.addArrangedSubview(cityStackView)
        profileInformationStackView.addArrangedSubview(anonymStackView)
        profileInformationStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileInformationStackView)
    }
    
    func settingConstraints() {
        settingStackView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        let constraints = [
            avatarImageView.widthAnchor.constraint(equalToConstant: 110),
            avatarImageView.heightAnchor.constraint(equalToConstant: 110),
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            profileInformationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 25),
            profileInformationStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 0),
            profileInformationStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90)
        ]
        NSLayoutConstraint.activate(constraints)
        view.addConstraints(constraints)
        
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

// MARK: Extentions
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
}
