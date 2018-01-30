//
//  AppDelegate.swift
//  ImageLookingFor
//
//  Created by Alexander Kolovatov on 06.01.18.
//  Copyright © 2018 Alexander Kolovatov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        window?.rootViewController = UINavigationController(rootViewController: SearchController(collectionViewLayout: layout))
        application.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor.RedTheme.scarlet
        UINavigationBar.appearance().tintColor = .white
        
        setupStatusBar()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        PersistenceService.saveContext()
    }
    
    private func setupStatusBar() {
        let statusBarBakgroundView = UIView()
        statusBarBakgroundView.backgroundColor = UIColor.RedTheme.darkish
        
        window?.addSubview(statusBarBakgroundView)
        window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBakgroundView)
        window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBakgroundView)
    }
}
