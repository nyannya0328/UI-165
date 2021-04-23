//
//  DrawingViewModel.swift
//  UI-165
//
//  Created by にゃんにゃん丸 on 2021/04/23.
//

import SwiftUI
import PencilKit

class DrawingViewModel: ObservableObject {
    @Published var showPicker = false
    @Published var imageData : Data = Data(count: 0)
    
    @Published var canvas = PKCanvasView()
    
    @Published var toolPicker = PKToolPicker()
    
    
    @Published var TextBoxes : [TextBox] = []
    @Published var addNewBox = false
    
    @Published var currentIndex : Int = 0
    @Published var rect : CGRect = .zero
    @Published var showAlert = false
    @Published var message = ""
    
    
    
    func cancelImageEditing(){
        
        imageData = Data(count: 0)
        canvas = PKCanvasView()
        TextBoxes.removeAll()
    }
    
    func cancelTextView(){
        
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        withAnimation{
            
            addNewBox = false
        }
        if !TextBoxes[currentIndex].isAdded{
            
            TextBoxes.removeLast()
        }
        
    }
    
    func saveImage(){
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let SwiftUIView = ZStack{
            
            ForEach(TextBoxes){[self]box in
                Text(TextBoxes[currentIndex].id == box.id && addNewBox ? "" : box.text)
                    .font(.system(size: box.size))
                    .fontWeight(box.isBold ? .bold : .none)
                    .foregroundColor(box.textColor)
                    .offset(box.offset)
        }
        }
        
        let controller = UIHostingController(rootView: SwiftUIView).view!
        
        controller.frame = rect
        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
       
        
        
        
       
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if let image = generatedImage? .pngData(){
            
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            print("Success")
            self.message = "Ok"
            
            showAlert.toggle()
            
            
            
        }
    
        
        
    }
    
    
}

