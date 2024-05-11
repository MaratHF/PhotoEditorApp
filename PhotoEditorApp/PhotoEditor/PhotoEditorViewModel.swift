//
//  PhotoEditorViewModel.swift
//  PhotoEditorApp
//
//  Created by MAC  on 09.05.2024.
//

import SwiftUI
import PencilKit

final class PhotoEditorViewModel: ObservableObject {
    
    @Published var showedImagePiker = false
    @Published var imageData: Data = Data(count: 0)
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    @Published var isDrawing = false
    @Published var isCropping = false
    @Published var textBoxes: [TextBox] = []
    @Published var addNewBox = false
    @Published var currentIndex: Int = 0
    @Published var rect: CGRect = .zero
    @Published var showAlert = false
    
    func cancelImageEditing() {
        showedImagePiker = false
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
    }
    
    func setDrawingState() {
        toolPicker.setVisible(isDrawing, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
    }
    
    func cancelTextView() {
        withAnimation {
            addNewBox = false
        }
        
        if !textBoxes[currentIndex].isAdded {
            textBoxes.removeLast()
        }
    }
    
    func saveImage() {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if let image = generatedImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        showAlert.toggle()
    }
}
