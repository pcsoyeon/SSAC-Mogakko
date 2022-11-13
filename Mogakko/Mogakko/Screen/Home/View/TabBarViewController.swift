//
//  TabBarViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/11.
//

import UIKit

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBarViewController()
    }
    
    private func configureTabBarViewController() {
        delegate = self
        
        UITabBar.appearance().backgroundColor = .white
        tabBar.tintColor = .green
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        // TODO: - 각 화면으로 수정 
        let firstTabController = HomeViewController()
        let secondTabController = UIViewController()
        let thirdTabController = UIViewController()
        let fourthTabController = UINavigationController(rootViewController: MyInfoViewController())
        
        firstTabController.tabBarItem = UITabBarItem(
            title: "홈",
            image: Constant.Image.homeInact,
            selectedImage: Constant.Image.homeAct)
        
        secondTabController.tabBarItem = UITabBarItem(
            title: "새싹샵",
            image: Constant.Image.shopInact,
            selectedImage: Constant.Image.shopAct)
        
        thirdTabController.tabBarItem = UITabBarItem(
            title: "새싹친구",
            image: Constant.Image.friendsInact,
            selectedImage: Constant.Image.friendsAct)
        
        fourthTabController.tabBarItem = UITabBarItem(
            title: "내정보",
            image: Constant.Image.myInact,
            selectedImage: Constant.Image.myAct)
        
        viewControllers = [firstTabController, secondTabController, thirdTabController, fourthTabController]
    }
}