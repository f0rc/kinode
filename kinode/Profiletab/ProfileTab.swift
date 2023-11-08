//
//  ProfileTab.swift
//  movieapp
//
//  Created by mops on 10/7/23.
//

import SwiftUI

struct ProfileTab: View {
    @Environment(AuthModel.self) private var auth
    
    @State private var toggleSettings: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    VStack{
                        Image("DefaultAvi")
                            .clipShape(Circle())
                            .frame(width: 82, height: 82)
                            .padding()
                        Text("James Dean")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text(verbatim: "example@website.com")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        
                        
                        HStack{
                            VStack{
                                Text("120")
                                    .font(.title)
                                Text("Followers")
                                    .font(.footnote)
                            }
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("20")
                                    .font(.title)
                                Text("Following")
                                    .font(.footnote)
                            }
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("20")
                                    .font(.title)
                                Text("Movies")
                                    .font(.footnote)
                            }
                            
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("2")
                                    .font(.title)
                                Text("Shows")
                                    .font(.footnote)
                            }
                            
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: 100)
                        
                        Divider()
                            .padding()
                        
                        VStack(alignment: .leading){
                            Text("Top 4 Shows")
                                .font(.title2)
                            VStack{
                                HStack{
                                    Image(systemName: "plus")
                                        .frame(width: 80, height: 150)
                                        .background(.gray)
                                    
                                    Image(systemName: "plus")
                                        .frame(width: 80, height: 150)
                                        .background(.gray)
                                    
                                    Image(systemName: "plus")
                                        .frame(width: 80, height: 150)
                                        .background(.gray)
                                    
                                    Image(systemName: "plus")
                                        .frame(width: 80, height: 150)
                                        .background(.gray)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading){
                            
                            Text("Top 4 Movies")
                                .font(.title2)
                            VStack{
                                HStack{
                                    Image(systemName: "plus")
                                        .frame(width: 80, height: 150)
                                        .background(.gray)
                                    
                                    Image(systemName: "plus")
                                        .frame(width: 80, height: 150)
                                        .background(.gray)
                                    
                                    Image(systemName: "plus")
                                        .frame(width: 80, height: 150)
                                        .background(.gray)
                                    
                                    Image(systemName: "plus")
                                        .frame(width: 80, height: 150)
                                        .background(.gray)
                                }
                            }
                        }
                        
                        
                        //TODO: list of recently watched with selector
                        
                    }
                    
                    
                }
                .toolbar {
                    Button(action: {
                        toggleSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .foregroundStyle(Color("accent"))
                            .font(.title2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("backgroundColor"))
                .sheet(isPresented: $toggleSettings){
                    settingsTab()
                        .presentationDetents([.large])
                        .presentationBackground(.yellow)
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

struct settingsTab: View {
    @Environment(AuthModel.self) private var auth
    
    var body: some View {
        NavigationStack{
            VStack{
                Button(action: {
                    Task {
                        do {
                            try await auth.logout()
                            
                        }catch {
                            print("failed to logout")
                        }
                    }
                }) {
                    Text("Log Out")
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(15)
            }
            .navigationTitle("Settings")
            .toolbar {
                Button(action: {
                    print("edit profile")
                }) {
                    Text("Edit")
                }
                
            }
        }
        
    }
}

#Preview {
    ProfileTab()
        .environment(AuthModel())
}
