//
//  TextBox.swift
//  UI-165
//
//  Created by にゃんにゃん丸 on 2021/04/23.
//

import SwiftUI

struct TextBox: Identifiable {
    
    var id = UUID().uuidString
    var text : String = ""
    var isBold : Bool = false
    var offset : CGSize = .zero
    var lastOffset : CGSize = .zero
    var textColor : Color = .white
    var size : CGFloat = 30
    var isAdded : Bool = false
    
}


