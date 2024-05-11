//
//  LoginService.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import Foundation
import FirebaseAuth
import Combine

protocol LoginServiceProtocol {
    func login(with loginData: LoginData) -> AnyPublisher<Void, Error>
}

struct LoginData {
    var email: String
    var password: String
}

final class LoginService: LoginServiceProtocol {
    
    func login(with loginData: LoginData) -> AnyPublisher<Void, Error> {
        
        Deferred {
            
            Future { promise in
                
                Auth
                    .auth()
                    .signIn(withEmail: loginData.email,
                            password: loginData.password) { result, error in
                        
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}

