//
//  ButtonView.swift
//  PhotoEditorApp
//
//  Created by MAC  on 07.05.2024.
//

import SwiftUI

struct ButtonView: View {
    
    typealias ActionHandler = () -> Void
    
    let title: String
    let background: Color
    let foreground: Color
    let border: Color
    let handler: ActionHandler
    
    private let cornerRadius: CGFloat = 10
    
    internal init(title: String,
                  background: Color = .blue,
                  foreground: Color = .white,
                  border: Color = .clear,
                  handler: @escaping ButtonView.ActionHandler) {
        self.title = title
        self.background = background
        self.foreground = foreground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        
        Button(action: {
            handler()
        }, label: {
            Text(title)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 50)
        })
        .background(background)
        .foregroundColor(foreground)
        .font(.system(size: 16, weight: .bold))
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border, lineWidth: 2)
        )
    }
}

#Preview {
    ButtonView(title: "Button", handler: {})
}
