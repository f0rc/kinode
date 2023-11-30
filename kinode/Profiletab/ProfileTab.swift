//
//  ProfileTab.swift
//  movieapp
//
//  Created by  on 10/7/23.
//

import SwiftUI
import SwiftData


struct ActiveItem : Identifiable {
    var typeOfMedia: Int
    var id: Int
}

struct ProfileTab: View {
    @Environment(AuthModel.self) private var auth
    
    @State private var toggleSettings: Bool = false
    @State private var activeItemTop4: ActiveItem?
    
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
                                    getButton(0, type: 0)
                                    getButton(1, type: 0)
                                    getButton(2, type: 0)
                                    getButton(3, type: 0)
                                }
                                .sheet(item: $activeItemTop4) {item in
                                    AddTop4Sheet(typeOfTop: item.typeOfMedia, index: item.id)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading){
                            
                            Text("Top 4 Movies")
                                .font(.title2)
                            VStack{
                                HStack{
                                    getButton(0, type: 1)
                                    getButton(1, type: 1)
                                    getButton(2, type: 1)
                                    getButton(3, type: 1)
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
                            .foregroundStyle(Color("accentC"))
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
    
    func getButton(_ i: Int, type: Int) -> some View {
        return Button(action: {
            print("\(i), type: \(type)")
            activeItemTop4 = ActiveItem(typeOfMedia: type, id: i)
        },
                      label: {
            Image(systemName: "plus")
                .frame(width: 80, height: 150)
                .background(.gray)
        })
    }
}



#Preview {
    ProfileTab(sessionToken: "1234")
        .environment(AuthModel())
    
}
