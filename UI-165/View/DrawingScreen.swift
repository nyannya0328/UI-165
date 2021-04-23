//
//  DrawingScreen.swift
//  UI-165
//
//  Created by にゃんにゃん丸 on 2021/04/23.
//

import SwiftUI
import PencilKit

struct DrawingScreen: View {
    
    @EnvironmentObject var model : DrawingViewModel
    var body: some View {
        ZStack{
            
            GeometryReader{proxy -> AnyView in
                
                let size = proxy.frame(in: .global)
                
                DispatchQueue.main.async {
                    if model.rect == .zero{
                        
                        model.rect = size
                    }
                    
                }
                
                
                return AnyView(
                
                    ZStack{
                        
                        canVasView(canvas: $model.canvas, imageData: $model.imageData, toolPicker: $model.toolPicker, rect: size.size)
                        
                        
                        ForEach(model.TextBoxes){box in
                            Text(model.TextBoxes[model.currentIndex].id == box.id && model.addNewBox ? "" : box.text)
                                .font(.system(size: box.size))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundColor(box.textColor)
                                .offset(box.offset)
                                .gesture(DragGesture().onChanged({ (value) in
                                    
                                    
                                    let current = value.translation
                                    
                                    let lastoffset  = box.lastOffset
                                    let newTranslation = CGSize(width: lastoffset.width + current.width, height: lastoffset.height + current.height)
                                    
                                    model.TextBoxes[getIndex(textbox: box)].offset = newTranslation
                                    
                                    
                                    
                                    
                                }).onEnded({ (value) in
                                    model.TextBoxes[getIndex(textbox: box)].lastOffset = value.translation
                                }))
                                .onLongPressGesture {
                                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                                    model.canvas.resignFirstResponder()
                                    model.currentIndex = getIndex(textbox: box)
                                    withAnimation{
                                        
                                        model.addNewBox = true
                                        
                                    }
                                    
                                }
                            
                            
                        }
                    }
                
                )
            }
          
            
        }
        .toolbar(content: {
            
            ToolbarItem(placement:.navigationBarTrailing , content: {
                
                
                Button(action: model.saveImage, label: {
                    Text("Save")
                       
                    
                })
                
                
            })
            
            ToolbarItem(placement:.navigationBarTrailing , content: {
                
                
                Button(action: {
                    
                    model.toolPicker.setVisible(false, forFirstResponder: model.canvas)
                    
                    model.canvas.resignFirstResponder()
                    
                    
                    model.TextBoxes.append(TextBox())
                    model.currentIndex = model.TextBoxes.count - 1
                    
                    withAnimation{
                        
                        
                        model.addNewBox.toggle()
                    }
                    
                }, label: {
                    Image(systemName: "plus")
                })
                
                
            })
            
            
        })
    }
    func getIndex(textbox : TextBox)->Int{
        
        let index = model.TextBoxes.firstIndex { (box) -> Bool in
            textbox.id == box.id
        } ?? 0
        
        return index
        
        
        
    }
}

struct DrawingScreen_Previews: PreviewProvider {
    static var previews: some View {
       Home()
    }
}

struct canVasView : UIViewRepresentable {
    
    @Binding var canvas : PKCanvasView
    @Binding var imageData : Data
    
    @Binding var toolPicker : PKToolPicker
    
    var rect : CGSize
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.drawingPolicy = .anyInput
        
        if let imageData = UIImage(data: imageData){
            
            
            let imageView = UIImageView(image: imageData)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            
            
            imageView.clipsToBounds = true
            
            
            let subView = canvas.subviews[0]
            subView.addSubview(imageView)
            subView.sendSubviewToBack(imageView)
            
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
            
            
            
            
        }
        
        
        
        return canvas
        
        
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}
