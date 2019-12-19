//
//  OnBoardingViewController.swift
//  iRis
//
//  Created by Sarvad shetty on 12/18/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {

    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UserDefaults.standard.object(forKey: UserObjKey) != nil {
            self.goToMain()
        } else {
            self.goToLogin()
        }
    }
    
    //MARK: - Functions
    func goToLogin() {
        guard let mainLog = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {
            fatalError("Couldnt init login view controller")
        }
        #warning("check about first state")
        
        self.setupRootViewController(viewController: mainLog)
    }
    
    func goToMain() {
        guard let mainNav = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "CustomTabBarController") as? CustomTabBarController else {
            fatalError("Couldnt init main tab bar view controller")
        }
        #warning("check about first state")
        
        self.setupRootViewController(viewController: mainNav)
    }
    
   private func setupRootViewController(viewController: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
