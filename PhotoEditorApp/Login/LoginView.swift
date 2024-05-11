//
//  LoginView.swift
//  PhotoEditorApp
//
//  Created by MAC  on 07.05.2024.
//

import SwiftUI

struct LoginView: View {
    
    @State private var showRegistration = false
    @State private var showRestorePassword = false
    
    @StateObject private var viewModel = LoginViewModel(
        service: LoginService()
    )
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            VStack(spacing: 16) {
                
                CustomTextField(text: $viewModel.loginData.email,
                                   placeholder: "Email",
                                   keyboardType: .emailAddress,
                                   systemImage: "envelope")
                
                PasswordTextField(password: $viewModel.loginData.password,
                                  placeholder: "Password",
                                  systemImage: "lock")
            }
            
            VStack(spacing: 16) {
                
                ButtonView(title: "Войти") {
                    viewModel.login()
                }
                
                ButtonView(title: "Зарегистрироваться",
                           background: .clear,
                           foreground: .blue,
                           border: .blue) {
                    showRegistration.toggle()
                }
                .sheet(isPresented: $showRegistration) {
                    RegisterView()
                }
                
                Button(action: {
                    showRestorePassword.toggle()
                }, label: {
                    Text("Забыли пароль?")
                })
                .font(.system(size: 16, weight: .bold))
                .sheet(isPresented: $showRestorePassword) {
                    RestorePasswordView()
                }
            }
        }
        .navigationTitle("Авторизация")
        .padding(.horizontal, 20)
        .alert(isPresented: $viewModel.hasError,
               content: {
            return Alert(
                title: Text("Произошла ошибка"),
                message: Text("Что-то пошло не так"))
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
