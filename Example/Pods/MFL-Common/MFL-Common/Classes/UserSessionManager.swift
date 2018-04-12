//
//  UserSessionManager.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 17/02/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

open class UserSessionManager {
    
    private var refreshTokenTimer : Timer?
    
    fileprivate let networkManager : NetworkManager
    fileprivate let loginManager : LoginManager
    
    public init(networkManager: NetworkManager, loginManager: LoginManager) {
        self.networkManager = networkManager
        self.loginManager = loginManager
        
        // Observers
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UserSessionManager.startRefreshAccessToken),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UserSessionManager.pauseTimer),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
    }
    
    deinit {
        pauseTimer()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    @objc public func startRefreshAccessToken() {
        
        if let timer = refreshTokenTimer, timer.isValid { return }
        
        guard UserDefaults.mfl_isUserLoggedIn,
            let tokenExpiryTime = UserDefaults.mfl_accessTokenExpiryTime else { return }
        
        startTimer(tokenExpiryTime: tokenExpiryTime)
    }
    
    private func startTimer(tokenExpiryTime: TimeInterval) {
        
        refreshTokenTimer = Timer.scheduledTimer(timeInterval: tokenExpiryTime / 2,
                                                 target: self,
                                                 selector: #selector(UserSessionManager.refreshSessionToken),
                                                 userInfo: nil,
                                                 repeats: true)
        refreshTokenTimer?.fire()
    }
    
    func stopRefreshAccessToken() {
        pauseTimer()
    }
    
    @objc func pauseTimer() {
        refreshTokenTimer?.invalidate()
        refreshTokenTimer = nil
    }
    
    @objc private func refreshSessionToken() {
        
        guard let token = UserDefaults.mfl_accessToken else { return }
        
        let oldAccessTokenExpiryTime = UserDefaults.mfl_accessTokenExpiryTime
        
        networkManager.refreshUserSessionToken(token) { result in
            
            switch result {
                
            case .success(let json):
                self.extractAccessToken(from: json["content"])
                self.restartTimerIfNecessary(with: oldAccessTokenExpiryTime)
                
            case .failure(_):
                self.loginWithKechainCredentials()
            }
        }
    }
    
    private func loginWithKechainCredentials() {
        
        if let email = UserDefaults.mfl_email,
           let password = UserDefaults.mfl_password {
            
            loginWith(email: email, password: password)
        
        } else {
            /*** No credential stored, should not get here ***/
            assertionFailure()
        }
        
    }
    
    private func loginWith(email: String, password: String) {
        
        let oldAccessTokenExpiryTime = UserDefaults.mfl_accessTokenExpiryTime
        
        loginManager.login(email: email, password: password) { result in
            
            switch result {
            case .success(_):
                self.restartTimerIfNecessary(with: oldAccessTokenExpiryTime)
            default: break;
            }
        }
    }
    

    fileprivate func extractAccessToken(from json: MFLJson) {
        UserDefaults.mfl_accessToken = json["accessToken"].stringValue
        UserDefaults.mfl_accessTokenExpiryTime = TimeInterval(json["expiresInMillisecs"].doubleValue / 1_000)
    }
    
    fileprivate func restartTimerIfNecessary(with oldAccessTokenExpiryTime: TimeInterval?) {
        
        // If there is more than 1 second difference between the new and old expiry times
        // restart the timer using the new time.
        if let oldAccessTokenExpiryTime = oldAccessTokenExpiryTime,
            let currentAccessTokenExpiryTime = UserDefaults.mfl_accessTokenExpiryTime,
            !(oldAccessTokenExpiryTime == currentAccessTokenExpiryTime) {
            
            pauseTimer()
            startRefreshAccessToken()
        } else if (oldAccessTokenExpiryTime == nil || UserDefaults.mfl_accessTokenExpiryTime == nil) {
            assertionFailure("\(#function) was called without having a new or old accessTokenExpiryTime")
        }
    }
}

fileprivate func ==(left: TimeInterval, right: TimeInterval) -> Bool {
    
    // TimeIntervals are considered equal if there is a difference of just 1 second between them
    return abs(left - right) < 1.0
}
