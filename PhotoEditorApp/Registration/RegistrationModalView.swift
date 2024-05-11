//
//  RegistrationModalView.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import Foundation
import Combine

enum RegistrationState {
    case successfullyRegistered
    case failed(error: Error)
    case none
}

protocol RegistrationViewModelProtocol {
    func create()
    var service: RegistrationServiceProtocol { get }
    var state: RegistrationState { get }
    var hasError: Bool { get }
    var newUser: RegistrationData { get }
    init(service: RegistrationServiceProtocol)
}

final class RegistrationViewModel: ObservableObject, RegistrationViewModelProtocol {
    
    let service: RegistrationServiceProtocol
    @Published var state: RegistrationState = .none
    @Published var newUser = RegistrationData(email: "", password: "")
    @Published var hasError: Bool = false
//    @Published var isEmailVerified: Bool = false

    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RegistrationServiceProtocol) {
        self.service = service
//        userVerifiedEmail()
        setupErrorHandling()
    }
    
    func create() {
        service
            .register(with: newUser)
            .sink { [weak self] result in
            
                switch result {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfullyRegistered
            }
            .store(in: &subscriptions)
    }
    
//    private func userVerifiedEmail() {
//        if service.checkIsEmailVerified() {
//            isEmailVerified = true
//        }
//    }
    
    private func setupErrorHandling() {
        $state
            .map { state -> Bool in
                switch state {
                case .successfullyRegistered,
                     .none:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}
