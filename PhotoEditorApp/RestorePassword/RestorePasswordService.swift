//
//  RestorePasswordService.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import Foundation
import FirebaseAuth
import Combine

protocol RestorePasswordServiceProtocol {
    func sendPasswordResetRequest(to email: String) -> AnyPublisher<Void, Error>
}

final class RestorePasswordService: RestorePasswordServiceProtocol {
    
    func sendPasswordResetRequest(to email: String) -> AnyPublisher<Void, Error> {
        
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .sendPasswordReset(withEmail: email) { error in
                        
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
