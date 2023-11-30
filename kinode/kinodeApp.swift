//
//  kinodeApp.swift
//  kinode
//
//  Created by  on 11/5/23.
//

import SwiftUI
import SwiftData


@main
struct kinodeApp: App {
    var body: some Scene {
        @Environment(AuthModel.self) var auth
        WindowGroup {
            ContentView()
                .environment(AuthModel())
        }
        .environment(AuthModel())
        .modelContainer(for: CReview.self)
    }
    
}
