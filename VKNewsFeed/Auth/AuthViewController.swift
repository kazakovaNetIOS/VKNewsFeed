//
//  AuthViewController.swift
//  VKNewsFeed
//
//  Created by Natalia Kazakova on 23.12.2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        authService = AppDelegate.shared().authService
    }

    @IBAction func signInTouch() {
        authService.wakeUpSession()
    }
}
