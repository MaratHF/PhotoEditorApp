//
//  PhotoEditorView.swift
//  PhotoEditorApp
//
//  Created by MAC  on 08.05.2024.
//

import SwiftUI
import Mantis

struct PhotoEditorView: View {
    
    @EnvironmentObject var service: SessionService
    @StateObject var viewModel: PhotoEditorViewModel = PhotoEditorViewModel()
    
    var body: some View {
        ZStack {
            NavigationView {
                
                VStack {
                    if let _ = UIImage(data: viewModel.imageData) {
                        DrawingScreenView()
                            .environmentObject(viewModel)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button(action: viewModel.cancelImageEditing,
                                           label: {
                                        Text("Отменить")
                                    })
                                }
                            }
                    } else {
                        Button {
                            viewModel.showedImagePiker = true
                        } label: {
                            Text("Добавить картинку")
                        }
                    }
                }
                .navigationTitle("Редактор")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            service.logout()
                        }, label: {
                            if viewModel.imageData.isEmpty {
                                Text("Выйти")
                            }
                        })
                    }
                }
            }
            
            
            if viewModel.isDrawing {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.isDrawing = false
                            viewModel.setDrawingState()
                        }, label: {
                            Text("Готово")
                                .fontWeight(.heavy)
                                .foregroundStyle(.black)
                                .padding()
                        })
                    }
                    
                    Spacer()
                }
            }
            
            if viewModel.addNewBox {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                
                TextField(
                    "Введите текст",
                    text: $viewModel.textBoxes[viewModel.currentIndex].text
                )
                .font(.system(
                    size: 30,
                    weight: viewModel.textBoxes[viewModel.currentIndex].isBold ? .bold : .regular
                ))
                .preferredColorScheme(.dark)
                .foregroundStyle(viewModel.textBoxes[viewModel.currentIndex].textColor)
                .padding()
                
                HStack {
                    Button(action: {
                        viewModel.cancelTextView()
                        print(viewModel.textBoxes.count)
                    }, label: {
                        Text("Отменить")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.textBoxes[viewModel.currentIndex].isAdded = true
                        withAnimation {
                            viewModel.addNewBox = false
                        }
                    }, label: {
                        Text("Добавить")
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding()
                    })
                }
                .overlay(
                    HStack(spacing: 15){
                        ColorPicker(
                            "",
                            selection: $viewModel.textBoxes[viewModel.currentIndex].textColor
                        )
                        .labelsHidden()
                        
                        Button(action: {
                            viewModel.textBoxes[viewModel.currentIndex].isBold.toggle()
                        }, label: {
                            Text(viewModel.textBoxes[viewModel.currentIndex].isBold ? "Жирный" : "Обычный")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        })
                    }
                )
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .sheet(isPresented: $viewModel.showedImagePiker, content: {
            ImagePicker(showPicker: $viewModel.showedImagePiker, imageData: $viewModel.imageData)
        })
        .alert(isPresented: $viewModel.showAlert, content: {
            Alert(title: Text("Успешно"), message: Text("Ваша картинка сохранена"), dismissButton: .destructive(Text("Ок")))
        })
    }
}

#Preview {
    PhotoEditorView()
}

struct ImageCropView: UIViewControllerRepresentable {
    typealias Coordinator = ImageCropCoordinator
    @EnvironmentObject var model: PhotoEditorViewModel
    
    func makeCoordinator() -> ImageCropCoordinator {
        ImageCropCoordinator(model: _model)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageCropView>) -> Mantis.CropViewController {
        let editor = Mantis.cropViewController(image: UIImage(data: model.imageData) ?? UIImage())
        editor.delegate = context.coordinator
        return editor
    }
}

final class ImageCropCoordinator: NSObject, CropViewControllerDelegate {
    @EnvironmentObject var model: PhotoEditorViewModel
    
    init(model: EnvironmentObject<PhotoEditorViewModel>) {
       _model = model
    }
    
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        model.imageData = cropped.pngData() ?? Data(count: 0)
        model.isCropping = false
    }
    
    func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        model.isCropping = false
    }
    
    func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {
        
    }
    
    func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {
        
    }
}
