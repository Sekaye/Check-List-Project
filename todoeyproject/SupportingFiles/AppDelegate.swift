//
//  AppDelegate.swift
//  ToDoeyProject
//
//  Created by Sekaye Knutson on 5/19/22.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("realm data file path: \(Realm.Configuration.defaultConfiguration.fileURL)")
        
        do {
            _ = try Realm()
        } catch {
            print ("error creating Realm \(error)")
        }
        
        return true
    }
}

