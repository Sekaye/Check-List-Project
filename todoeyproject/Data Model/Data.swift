//
//  Data.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 7/14/22.
//


import Foundation
import RealmSwift

class Data: Object {
    @Persisted var name: String = ""
    @Persisted var age: Int = 0
}
