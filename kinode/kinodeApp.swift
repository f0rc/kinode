//
//  kinodeApp.swift
//  kinode
//
//  Created by mops on 11/5/23.
//

import SwiftUI
import SwiftData


@main
struct kinodeApp: App {
    var body: some Scene {
        @Environment(AuthModel.self) var auth
        WindowGroup {
            Splash()
                .environment(AuthModel())
        }
        .environment(AuthModel())
    }
    
}
