//
//  ScholarshipDemo2App.swift
//  ScholarshipDemo2
//
//  Created by Park Kangwook on 2022/06/07.
//

import SwiftUI

@main
struct ScholarshipDemo2App: App {
    let dataService = DataService()
    
    var body: some Scene {
        WindowGroup {
            AppStorageTest()
                .environmentObject(dataService)
        }
    }
}

