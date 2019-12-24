//
//  AuthService.swift
//  VKNewsFeed
//
//  Created by Natalia Kazakova on 23.12.2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import VKSdkFramework

protocol AuthServiceDelegate {
    func authServiceShouldShow(_ viewController: UIViewController)
    func authServiceSignIn()
    func authServiceDidSignInFail()
}

final class AuthService: NSObject {
    
    private let appId = "7253365"
    private let vkSdk: VKSdk
    
    var delegate: AuthServiceDelegate?
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["offline"]
        
        VKSdk.wakeUpSession(scope) { [weak self] (state, error) in
            guard let `self` = self else { return }
            if state == VKAuthorizationState.authorized {
                print("VKAuthorizationState.authorized")
                self.delegate?.authServiceSignIn()
            } else if state == VKAuthorizationState.initialized {
                print("VKAuthorizationState.initialized")
                VKSdk.authorize(scope)
            } else {
                print("auth problems, state: \(state), error: \(String(describing: error))")
                self.delegate?.authServiceDidSignInFail()
            }
        }
    }
}

//MARK: - VKSdkDelegate
/***************************************************************/

extension AuthService: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            self.delegate?.authServiceSignIn()
        }        
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
}

//MARK: - VKSdkUIDelegate
/***************************************************************/

extension AuthService: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        self.delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function) 
    }
}
