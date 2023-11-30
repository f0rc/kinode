//
//  Splash.swift
//  kinode
//
//  Created by  on 11/30/23.
//

import SwiftUI

struct Splash: View {
    @State private var isActive = false
    @State private var sisze = 0.8
    @State private var opacity = 0.5
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.white
                VStack{
                    Image(systemName: "list.and.film")
                        .font(.system(size: 80))
                        .foregroundColor(Color.accentColor)
                    
                    Text("Log all of your favorite movies and shows")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .foregroundColor(Color.text)
                    
                    ProgressView()
                }
                .scaleEffect(sisze)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)){
                        self.sisze = 0.9
                        self.opacity = 1.0
                        
                    }
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
            .preferredColorScheme(.light)
        }
    }
}

#Preview {
    Splash()
}
