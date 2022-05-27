//
//  Item.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 5/26/22.
//

import Foundation

struct Item: Codable {
    var title: String
    var done: Bool = false
}
