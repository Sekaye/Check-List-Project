//
//  ListManager.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 5/23/22.
//

import UIKit

struct ListManager{
    
    static func initializeData(){
        
    }
    
    static func saveCell(cell: ToDoTableViewCell){
        MainList.cellList.append(cell)
    }
    
    static func emptyCells(){
        MainList.cellList = []
    }
}

struct MainList {
    static var cellList: [ToDoTableViewCell] = []
}
