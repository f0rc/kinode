//
//  SettingsSheet.swift
//  kinode
//
//  Created by  on 11/18/23.
//

import SwiftUI

struct SettingsSheet: View {
    @Environment(AuthModel.self) private var auth
    
    @Binding var userProfileInfo: UserProfile
    @Binding var userModel: ProfileModelController
    @State private var toggleEdit: Bool = true
    
    var fieldColorDisabled: Color {
        return toggleEdit ? .gray : .black
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                FormInput(text: $userProfileInfo.email, title: "Email", placeholder: "example@a.com")
                    .disabled(true)
                    .foregroundStyle(.gray)
                
                FormInput(text: $userProfileInfo.name, title: "Display Name", placeholder: "James")
                    .disabled(toggleEdit)
                    .foregroundStyle(fieldColorDisabled)
            }
            .padding()
            
            Spacer()
            
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
                if toggleEdit {
                    Button(action: {
                        toggleEdit.toggle()
                    }) {
                        Text("Edit")
                    }
                } else {
                    Button(action: {
                        Task{
                            if let token = auth.authToken {
                                do {
                                    try await userModel.updateUserProfileApi(sessionToken: token)
                                }
                                catch {
                                    print("Something went wrong when updating profile from modal")
                                }
                            }
                            
                            toggleEdit.toggle()
                        }
                    }) {
                        Text("Save")
                    }
                }
                
                // update button push to server
                
            }
        }
        
    }
}


#Preview {
    SettingsSheet(userProfileInfo: .constant(UserProfile(email: "fake@a.com", name: "I am Me", username: "james182", followers: 0, following: 123, moviesCount: 1234, showsCount: 1234)), userModel: .constant(ProfileModelController(sessionToken: "1234")))
        .environment(AuthModel())
}
