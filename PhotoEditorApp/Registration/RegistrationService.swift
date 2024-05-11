//
//  RegistrationService.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import Combine
import Foundation
import FirebaseAuth

struct RegistrationData {
    var email: String
    var password: String
}

protocol RegistrationServiceProtocol {
    func register(with data: RegistrationData) -> AnyPublisher<Void, Error>
//    func checkIsEmailVerified() -> Bool
}

final class RegistrationService: RegistrationServiceProtocol {
    
    func register(with data: RegistrationData) -> AnyPublisher<Void, Error> {
        
        Deferred {

            Future { promise in
                
                Auth.auth().createUser(withEmail: data.email,
                                       password: data.password) { result, error in
                    guard error == nil else {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    result?.user.sendEmailVerification()
                    
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
//    func checkIsEmailVerified() -> Bool {
//        if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isEmailVerified {
//            
//        }
//    }
}

