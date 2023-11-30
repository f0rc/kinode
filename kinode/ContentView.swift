//
//  ContentView.swift
//  movieapp
//
//  Created by  on 10/7/23.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    
    @State private var selection: Tab = .home
    
    @Environment(AuthModel.self) private var auth

    
    
    var body: some View {
        if auth.isAuthenticated && !auth.loading {
            VStack(spacing: 0.0) {
                TabView(selection: $selection) {
                    DiaryTab()
                        .tabItem {
                            Text("Diary")
                            Image(systemName: "note.text")
                        }
                        .tag(Tab.home)
                    
                    SearchTab()
                        .tabItem {
                            Text("Search")
                            Image(systemName: "sparkle.magnifyingglass")
                        }
                        .tag(Tab.search)
                    
                    ProfileTab(sessionToken: auth.authToken!)
                        .tabItem {
                            Text("Profile")
                            
                            Image(systemName: "person")
                        }
                        .tag(Tab.profile)
                }
                .accentColor(.white)
                .onAppear {
                    let appearance = UITabBarAppearance()
                    appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                    appearance.backgroundColor = UIColor(Color.black.opacity(0.7))
                    
                    // Use this appearance when scrolling behind the TabView:
                    UITabBar.appearance().standardAppearance = appearance
                    // Use this appearance when scrolled all the way up:
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
                
                
                
                //            TabBarView(currentTab: $selection)
            }
        }
        else if auth.loading{
            ProgressView()
        }
        
        else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthModel())
}



//TextField("Search", text: $searchQuery)
//    .onReceive(searchQuery.publisher.debounce(for: 0.5, scheduler: DispatchQueue.main)) { query in
//        print(query)
//        }
