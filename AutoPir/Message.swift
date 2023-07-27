//
//  Message.swift
//  AutoPir
//
//  Created by Jérôme Binachon on 27/07/2023.
//

import Foundation

struct Message: Hashable {
    let id = UUID().uuidString
    let date = Date.now
    let text:String
}

