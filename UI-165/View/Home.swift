//
//  Home.swift
//  UI-165
//
//  Created by にゃんにゃん丸 on 2021/04/23.
//

import SwiftUI

struct Home: View {
    @StateObject var model = DrawingViewModel()
    var body: some View {
        ZStack{
            NavigationView{
                
                VStack{
                    
                    if let _ = UIImage(data: model.imageData){
                        
                       DrawingScreen()
                        .environmentObject(model)
                        
                            .toolbar(content: {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    
                                    Button(action: model.cancelImageEditing, label: {
                                        Image(systemName: "xmark")
                                    })
                                    
                                    
                                }
                            })
                        
                        
                        
                        
                    }
                    
                    else{
                        
                        Button(action: {
                            
                            model.showPicker.toggle()
                            
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(width: 80, height: 80)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.purple, radius: 5, x: 5, y: 5)
                                .shadow(color: Color.green, radius: 5, x: -5, y: -5)
                                
                        })
                        
                        
                        
                    }
                    
                    
                    
                }
                .navigationTitle("Image Editor")
                
            }
            
            if model.addNewBox{
                
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                
                TextField("Enter", text: $model.TextBoxes[model.currentIndex].text)
                    .font(.system(size: 35, weight: model.TextBoxes[model.currentIndex].isBold ? .bold : .regular))
                   .colorScheme(.dark)
                    .foregroundColor(model.TextBoxes[model.currentIndex].textColor)
                    .padding()
                
                HStack{
                    
                    
                    Button(action: {
                        
                        model.TextBoxes[model.currentIndex].isAdded = true
                        
                        model.toolPicker.setVisible(true, forFirstResponder: model.canvas)
                        model.canvas.becomeFirstResponder()
                        
                        
                        withAnimation{
                            
                            model.addNewBox = false
                        }
                        
                    }, label: {
                        Text("ADD")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                    Spacer()
                    
                    
                    Button(action: model.cancelTextView, label: {
                        Text("Cancel")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                    })
                    
                    
                    
                    
                }
                .overlay(
                    HStack(spacing:15){
                        
                        
                        ColorPicker("", selection: $model.TextBoxes[model.currentIndex].textColor)
                            .labelsHidden()
                        
                        
                        Button(action: {
                            
                            
                            model.TextBoxes[model.currentIndex].isBold.toggle()
                            
                            
                        }, label: {
                            
                            Text(model.TextBoxes[model.currentIndex].isBold ? "Normal" : "Bold")
                        
                           
                        })
                        
                    }
                
                
                )
                
                
                .frame(maxHeight: .infinity,alignment: .top)
                
                
                
            }
        }
        .sheet(isPresented: $model.showPicker, content: {
            imagePicker(showPicker: $model.showPicker, imageData: $model.imageData)
        })
        .alert(isPresented: $model.showAlert, content: {
            Alert(title: Text("Message"), message: Text(model.message), dismissButton: .destructive(Text("OK")))
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
