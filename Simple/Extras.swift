//
//  Extras.swift
//  Simple
//
//  Created by Himanshu vyas on 28/08/25.
//

import Foundation
import UIKit

enum MessageType {
    case text(String)
    case image(UIImage)
    case typing   // 🔥 new
}

struct Message {
    let isUser: Bool // true = user message, false = AI
    let type: MessageType
}
