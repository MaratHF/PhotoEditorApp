//
//  SessionService.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import Foundation
import FirebaseAuth
import Combine

enum SessionState: String {
    case loggedIn = "LoggedIn"
    case loggedOut = "LoggedOut"
}

protocol SessionServiceProtocol {
    var state: SessionState { get }
    init()
    func logout()
}

final class SessionService: SessionServiceProtocol, ObservableObject {
    
    @Published var state: SessionState = .loggedOut
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthState()
    }
    
    deinit {
        guard let handler = handler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
        print("deinit SessionService")
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    private func setupAuthState() {
        handler = Auth
            .auth()
            .addStateDidChangeListener { [weak self] _,_ in
                guard let self = self else { return }
                
                let currentUser = Auth.auth().currentUser
                
                if currentUser != nil {
                    state = .loggedIn
                } else {
                    state = .loggedOut
                }
            }
    }
}
