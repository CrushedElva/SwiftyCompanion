//
//  MainScreenViewController.swift
//  SwiftyCompanion
//
//  Created by Маргарита Морозова on 27.04.2021.
//

import UIKit

class MainScreenViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var searchLoginOutlet: UISearchBar!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupScreen()
    }
    
    private func setupScreen() {
        searchButtonOutlet.backgroundColor = .purple
        searchButtonOutlet.layer.cornerRadius = 15
        searchButtonOutlet.setTitleColor(.white, for: .normal)
        searchButtonOutlet.setTitle(NSLocalizedString("Поиск", comment: ""), for: .normal)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        if let login = searchLoginOutlet.text {
            Constants.appDelegate?.auth.getDataUser(login: login.lowercased()) { result, error in
                if error == nil {
                    let viewController = ScreenInformationViewController()
                    viewController.userInformation = result
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    self.navigationController?.pushViewController(viewController, animated: true)
//                    let navigationController = UINavigationController()
//                    navigationController.navigationBar.barTintColor = .yellow
//                    navigationController.viewControllers = [viewController]
//                    self.present(navigationController, animated: true, completion: nil)
                    
//                    self.present(viewController, animated: true, completion: nil)
                } else {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    private func setupConstraints() {
        searchLoginOutlet.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height/2 - 30).isActive = true
    }
    
    func userSearch() {
    }
}
