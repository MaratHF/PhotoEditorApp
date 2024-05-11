//
//  DrawingScreen.swift
//  PhotoEditorApp
//
//  Created by MAC  on 09.05.2024.
//

import SwiftUI
import PencilKit

struct DrawingScreenView: View {
    @EnvironmentObject var viewModel: PhotoEditorViewModel

    var body: some View {
        
        VStack {
            GeometryReader { proxy -> AnyView in
                
                DispatchQueue.main.async {
                    if viewModel.rect == .zero {
                        viewModel.rect = proxy.frame(in: .global)
                    }
                }

                 return AnyView(
                    ZStack {
                        
                        CanvasView(canvas: $viewModel.canvas, imageData: $viewModel.imageData, toolPicker: $viewModel.toolPicker, rect: proxy.size)
                        
                        ForEach(viewModel.textBoxes.indices, id: \.self) { index in
                            let box = viewModel.textBoxes[index]
                            if (0...viewModel.textBoxes.count).contains(viewModel.currentIndex) {
                                
                                Text(viewModel.addNewBox ? "" : box.text)
                                    .font(.system(size: 30))
                                    .fontWeight(box.isBold ? .bold : .none)
                                    .foregroundStyle(box.textColor)
                                    .offset(box.offset)
                                    .gesture(DragGesture().onChanged({ (value) in
                                        let current = value.translation
                                        let lastOffset = box.lastOffset
                                        let newTranslation = CGSize(
                                            width: lastOffset.width + current.width,
                                            height: lastOffset.height + current.height
                                        )
                                        
                                        viewModel.textBoxes[index].offset = newTranslation
                                    }).onEnded({ value in
                                        viewModel.textBoxes[index].lastOffset = value.translation
                                    }))
                                    .onTapGesture {
                                        viewModel.currentIndex = index
                                        withAnimation {
                                            viewModel.addNewBox = true
                                        }
                                    }
                            }
                        }
                    }
                )
            }
            
            Spacer()
            
            Button(
                action: {
                    viewModel.isCropping = true
            }, label: {
                Image(systemName: "crop")
            })
            .fullScreenCover(
                isPresented: $viewModel.isCropping,
                content: {
                    ImageCropView()
                        .environmentObject(viewModel)
            })
        }
        .toolbar(viewModel.isDrawing ? .hidden : .visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.saveImage()
                }) {
                    Text("Сохранить")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.isDrawing = true
                    viewModel.setDrawingState()
                }, label: {
                    Image(systemName: "pencil.tip")
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.textBoxes.append(TextBox())
                    
                    viewModel.currentIndex = viewModel.textBoxes.count - 1
                    
                    withAnimation {
                        viewModel.addNewBox.toggle()
                    }
                }, label: {
                    Text("Текст")
                })
            }
        }
    }
}

#Preview {
    PhotoEditorView()
}

struct CanvasView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    @Binding var imageData: Data
    @Binding var toolPicker: PKToolPicker
    
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(
                x: 0,
                y: 0,
                width: rect.width,
                height: rect.height
            )
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            let subView = canvas.subviews.first
            subView?.addSubview(imageView)
            subView?.sendSubviewToBack(imageView)
            
            toolPicker.setVisible(false, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }
        
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
