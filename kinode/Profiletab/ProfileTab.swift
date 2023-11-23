//
//  ProfileTab.swift
//  movieapp
//
//  Created by  on 10/7/23.
//

import SwiftUI
import SwiftData

struct ProfileTab: View {
    @Environment(AuthModel.self) private var auth
    
    @State private var toggleSettings: Bool = false
    
    @State var profileVM: ProfileModelController
    
    init(sessionToken: String) {
        self.profileVM = ProfileModelController(sessionToken: sessionToken)
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    VStack{
                        Image("DefaultAvi")
                            .clipShape(Circle())
                            .frame(width: 82, height: 82)
                            .padding()
                        
                        // display name
                        Text(profileVM.user.name)
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("@\(profileVM.user.username)")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        
                        
                        HStack{
                            VStack{
                                Text("\(profileVM.user.followers)")
                                    .font(.title)
                                Text("Followers")
                                    .font(.footnote)
                            }
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("\(profileVM.user.following)")
                                    .font(.title)
                                Text("Following")
                                    .font(.footnote)
                            }
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("\(profileVM.user.moviesCount)")
                                    .font(.title)
                                Text("Movies")
                                    .font(.footnote)
                            }
                            
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("\(profileVM.user.showsCount)")
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
                    
                    SettingsSheet(userProfileInfo: $profileVM.user, userModel: $profileVM)
                        .presentationDetents([.large])
                        .presentationBackground(.yellow)
                        .presentationDragIndicator(.visible)
                }
            }
        }
        .onAppear {
            if let authTok = auth.authToken {
                self.profileVM = ProfileModelController(sessionToken: authTok)
            }
        }
    }
}



#Preview {
    ProfileTab(sessionToken: "1234")
        .environment(AuthModel())
        
}
