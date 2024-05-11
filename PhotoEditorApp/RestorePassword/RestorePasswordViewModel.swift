//
//  RestorePasswordViewModel.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import Foundation
import Combine

protocol RestorePasswordViewModelProtocol {
    var service: RestorePasswordServiceProtocol { get }
    var email: String { get }
    init(service: RestorePasswordServiceProtocol)
    func sendPasswordResetRequest()
}

final class RestorePasswordViewModel: ObservableObject, RestorePasswordViewModelProtocol {
    
    let service: RestorePasswordServiceProtocol
    @Published var email: String = ""

    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RestorePasswordServiceProtocol) {
        self.service = service
    }
    
    func sendPasswordResetRequest() {
        service
            .sendPasswordResetRequest(to: email)
            .sink { res in
                switch res {
                case .failure(let error):
                    print("Failed: \(error)")
                default: break
                }
            } receiveValue: {
                print("Sending request")
            }
            .store(in: &subscriptions)
    }
}
