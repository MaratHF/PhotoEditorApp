//
//  RegistrationView.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var viewModel = RegistrationViewModel(
        service: RegistrationService()
    )
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 32) {
                
                VStack(spacing: 16) {
                    
                    CustomTextField(text: $viewModel.newUser.email,
                                    placeholder: "Email",
                                    keyboardType: .emailAddress,
                                    systemImage: "envelope")
                    
                    PasswordTextField(password: $viewModel.newUser.password,
                                      placeholder: "Password",
                                      systemImage: "lock")
                    
                }
                
                ButtonView(title: "Зарегистрироваться") {
                    viewModel.create()
                }
            }
        }
        .padding(.horizontal, 15)
        .navigationTitle("Регистрация")
        .alert(isPresented: $viewModel.hasError,
               content: {
            return Alert(
                title: Text("Произошла ошибка"),
                message: Text("Что-то пошло не так"))
        })
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
