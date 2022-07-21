//
//  Category.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 7/15/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var categoryID = UUID().uuidString
    @Persisted var items = List<Item>()
    override static func primaryKey() -> String? {
        return "categoryID"
    }
}
