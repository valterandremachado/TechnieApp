//
//  ClientTabController.swift
//  Technie
//
//  Created by Valter A. Machado on 12/16/20.
//

import UIKit

class ClientTabController: UITabBarController {
    
    // MARK: - Properties
    // VCs
    private let feedVC = ClientFeedVC()
//    private let searchVC = ClientSearchVC()
    private let profileVC = UserProfileVC()
    private let postVC = ClientPostVC()
    private let chatVC = ConversationVC()
    private let notificationVC = ClientNotificationVC()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabController()
    }
    
    // MARK: - Methods
    fileprivate func setupTabController() {
//        tabBar.isTranslucent = true
        viewControllers = [
            createTabControllerForCustomIcons(unselectedImage: "home", selectedImage: "home.fill", vc: feedVC),
            createTabController(unselectedImage: "message", selectedImage: "message.fill", vc: chatVC),
            createTabController(unselectedImage: "plus.app", selectedImage: "plus.app.fill", vc: postVC),
            createTabController(unselectedImage: "bell", selectedImage: "bell.fill", vc: notificationVC),
            createTabController(unselectedImage: "person.circle", selectedImage: "person.circle.fill", vc: profileVC)
        ]
        
    }
    
    fileprivate func createTabController(unselectedImage: String, selectedImage: String, vc: UIViewController) -> UINavigationController {
        
        let currentVC = UINavigationController(rootViewController: vc)
//        currentVC.tabBarItem.title = title
        currentVC.tabBarItem.image = UIImage(systemName: unselectedImage)
        currentVC.tabBarItem.selectedImage =  UIImage(systemName: selectedImage)
        
        return currentVC
    }
    
    fileprivate func createTabControllerForCustomIcons(unselectedImage: String, selectedImage: String, vc: UIViewController) -> UINavigationController {
        
        let currentVC = UINavigationController(rootViewController: vc)
//        currentVC.tabBarItem.title = title
        currentVC.tabBarItem.image = UIImage(named: unselectedImage)?.imageResize(sizeChange: CGSize(width: 22, height: 22))
        currentVC.tabBarItem.selectedImage = UIImage(named: selectedImage)?.imageResize(sizeChange: CGSize(width: 22, height: 22))
        
        return currentVC
    }
}


