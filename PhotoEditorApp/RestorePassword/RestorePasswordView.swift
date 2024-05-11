//
//  RestorePasswordView.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import SwiftUI

struct RestorePasswordView: View {
    
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel = RestorePasswordViewModel(
        service: RestorePasswordService()
    )
    
    var body: some View {
            VStack(spacing: 16) {
            
                CustomTextField(text: $viewModel.email,
                                   placeholder: "e-mail",
                                   keyboardType: .emailAddress,
                                   systemImage: "envelope")
                
                ButtonView(title: "Сбросить пароль") {
                    viewModel.sendPasswordResetRequest()
                    dismiss()
                }
            }
            .padding(.horizontal, 15)
            .navigationTitle("Восстановить пароль")
    }
}

struct RestorePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RestorePasswordView()
    }
}
