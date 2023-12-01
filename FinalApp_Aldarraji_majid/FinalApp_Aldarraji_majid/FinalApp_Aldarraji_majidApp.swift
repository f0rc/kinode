//
//  FinalApp_Aldarraji_majidApp.swift
//  FinalApp_Aldarraji_majid
//
//  Created by mops on 11/30/23.
//

import SwiftUI

@main
struct FinalApp_Aldarraji_majidApp: App {
    var body: some Scene {
        
        @Environment(AuthModel.self) var auth
        WindowGroup {
            Splash()
                .environment(AuthModel())
        }
        .environment(AuthModel())
    }
}
