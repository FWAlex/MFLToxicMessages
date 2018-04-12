//
//  SessionsManager.swift
//  MFLHalsa
//
//  Created by Alex Miculescu on 07/07/2017.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class SessionsManager {
    
    fileprivate let userDataStore : UserDataStore
    
    fileprivate var delay = TimeInterval(5)
    fileprivate var timer : Timer?
    static fileprivate var notificationTimers = [Timer]()
    
    typealias Dependencies = HasUserDataStore
    init(_ dependencies: Dependencies) {
        userDataStore = dependencies.userDataStore
        
        NotificationCenter.default.addObserver(self, selector: #selector(SessionsManager.startTimer), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SessionsManager.fetchSessions), name: MFLDidReceiveSession, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SessionsManager.fetchSessions), name: MFLShouldFetchSessionsNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: MFLDidReceiveSession, object: nil)
        NotificationCenter.default.removeObserver(self, name: MFLShouldFetchSessionsNotification, object: nil)
    }
    
    @objc func fetchSessions() {
        UserDefaults.mfl_shouldFetchSessions = true
        startTimer()
    }
    
    @objc func fetchSessionsIfNeeded() {
        
        guard UserDefaults.mfl_shouldFetchSessions else {
            pauseTimer()
            return
        }
        
        userDataStore.updateSessions() { [weak self] result in
            
            switch result {
            case .success(let user):
                self?.pauseTimer()
                UserDefaults.mfl_shouldFetchSessions = false
                self?.addNotificationForUpcomingSessions(from: user?.sessions)
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: MFLDidFetchSessionsNotification, object: nil)
                }
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    @objc fileprivate func startTimer() {
        if let timer = timer, timer.isValid { return }
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) {_ in
            self.fetchSessionsIfNeeded()
        }
        
        timer?.fire()
    }
    
    fileprivate func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate func addNotificationForUpcomingSessions(from sessions: [Session]?) {
        
        guard let sessions = sessions else { return }
        
        SessionsManager.notificationTimers.forEach { $0.invalidate() }
        SessionsManager.notificationTimers = [Timer]()
        let now = Date()
        sessions.filter{ $0.startDate > now }.forEach { SessionsManager.addNotification(for: $0) }
    }
    
    fileprivate static func addNotification(for session: Session) {
        
        let timer = Timer(fire: session.startDate, interval: 0, repeats: false) { _ in
            NotificationCenter.default.post(name: MFLSessionShouldStartNotification, object: nil, userInfo: ["session" : session])
        }
        
        notificationTimers.append(timer)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
}
