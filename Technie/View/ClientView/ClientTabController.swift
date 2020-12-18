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
    private let searchVC = ClientSearchVC()
    private let postVC = ClientPostVC()
    private let chatVC = ClientChatVC()
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
            createTabController(unselectedImage: "homepod", selectedImage: "homepod.fill", vc: feedVC),
            createTabController2(unselectedImage: "search", selectedImage: "search.fill", vc: searchVC),
            createTabController(unselectedImage: "plus.app", selectedImage: "plus.app.fill", vc: postVC),
            createTabController(unselectedImage: "message", selectedImage: "message.fill", vc: chatVC),
            createTabController(unselectedImage: "bell", selectedImage: "bell.fill", vc: notificationVC)
        ]
        
    }
    
    fileprivate func createTabController(unselectedImage: String, selectedImage: String, vc: UIViewController) -> UINavigationController {
        
        let currentVC = UINavigationController(rootViewController: vc)
//        currentVC.tabBarItem.title = title
        currentVC.tabBarItem.image = UIImage(systemName: unselectedImage)
        currentVC.tabBarItem.selectedImage =  UIImage(systemName: selectedImage)
        
        return currentVC
    }
    
    fileprivate func createTabController2(unselectedImage: String, selectedImage: String, vc: UIViewController) -> UINavigationController {
        
        let currentVC = UINavigationController(rootViewController: vc)
//        currentVC.tabBarItem.title = title
        currentVC.tabBarItem.image = UIImage(named: unselectedImage)
        currentVC.tabBarItem.selectedImage =  UIImage(named: selectedImage)
        
        return currentVC
    }
}
