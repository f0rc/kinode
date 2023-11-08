//
//  kinodeApp.swift
//  kinode
//
//  Created by  on 11/5/23.
//

import SwiftUI

@main
struct kinodeApp: App {
    var body: some Scene {
        @Environment(AuthModel.self) var auth
        WindowGroup {
            ContentView()
                .environment(AuthModel())
                .environment(ReviewModel())
        }
        .environment(AuthModel())
    }
    
}
