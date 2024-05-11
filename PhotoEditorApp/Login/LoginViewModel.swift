//
//  LoginViewModel.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import Combine
import SwiftUI

protocol LoginViewModelProtocol {
    func login()
    var service: LoginServiceProtocol { get }
    var state: LoginState { get }
    var hasError: Bool { get }
    var loginData: LoginData { get }
    init(service: LoginServiceProtocol)
}

enum LoginState {
    case successfullyLoggedIn
    case failed(error: Error)
    case none
}

final class LoginViewModel: ObservableObject, LoginViewModelProtocol {
    
    let service: LoginServiceProtocol
    @Published var state: LoginState = .none
    @Published var loginData: LoginData = LoginData(email: "", password: "")
    @Published var hasError: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: LoginServiceProtocol) {
        self.service = service
        setupErrorHandling()
    }
    
    func login() {
        service
            .login(with: loginData)
            .sink { result in
                switch result {
                case .failure(let error):
                    self.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfullyLoggedIn
            }
            .store(in: &subscriptions)
    }
    
    private func setupErrorHandling() {
        $state
            .map { state -> Bool in
                switch state {
                case .successfullyLoggedIn,
                     .none:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}
