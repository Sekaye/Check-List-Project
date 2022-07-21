//
//  Item.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 7/15/22.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var itemID = UUID().uuidString
    @Persisted var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    @Persisted var dateCreated: Date?
    override static func primaryKey() -> String? {
        return "itemID"
    }
}
