//
//  TechnieTabController.swift
//  Technie
//
//  Created by Valter A. Machado on 1/13/21.
//

import UIKit

class TechnieTabController: UITabBarController {
    
    // MARK: - Properties
    // VCs
    private let feedVC = TechnieFeedVC()
    private let chatVC = TechnieChatVC()
    private let serviceVC = TechnieServiceVC()
    private let notificationVC = TechnieNotificationVC()
    private let profileVC = TechnieProfileVC()

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabController()
    }
    
    // MARK: - Methods
    fileprivate func setupTabController() {
        // Tabs
        viewControllers = [
            createTabController(unselectedImage: "homepod", selectedImage: "homepod.fill", vc: feedVC),
            createTabController(unselectedImage: "message", selectedImage: "message.fill", vc: chatVC),
            createTabController(unselectedImage: "doc.text", selectedImage: "doc.text.fill", vc: serviceVC),
            createTabController(unselectedImage: "bell", selectedImage: "bell.fill", vc: notificationVC),
            createTabController(unselectedImage: "gearshape", selectedImage: "gearshape.fill", vc: profileVC)
        ]
        
    }
    
    fileprivate func createTabController(unselectedImage: String, selectedImage: String, vc: UIViewController) -> UINavigationController {
        
        let currentVC = UINavigationController(rootViewController: vc)
//        currentVC.tabBarItem.title = title
        currentVC.tabBarItem.image = UIImage(systemName: unselectedImage)
        currentVC.tabBarItem.selectedImage = UIImage(systemName: selectedImage)
        
        return currentVC
    }
}
