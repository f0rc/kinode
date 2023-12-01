//
//  TabBarView.swift
//  movieapp
//
//  Created by mops on 10/9/23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case profile = "Profile"
}

struct TabBarView: View {
    @Binding var currentTab: Tab
    
    
    var body: some View {
        VStack {
            HStack(spacing: 0.0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    
                    Button {
                        withAnimation(.easeInOut) {
                            currentTab = tab
                        }
                    } label: {
                        if (tab.rawValue == "Home"){
                            Image(systemName: "note.text")
                                .renderingMode(.template)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                        } else if (tab.rawValue == "Search") {
                            Image(systemName: "sparkle.magnifyingglass")
                                .renderingMode(.template)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                        } else if (tab.rawValue == "Profile") {
                            Image(systemName: "person")
                                .renderingMode(.template)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                        }
                    }
                        
                    
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 24)
        .padding(.top, 30)
        .background(.ultraThinMaterial)
        .background(.black.opacity(0.4))
    }
}

#Preview {
    ContentView()
}
