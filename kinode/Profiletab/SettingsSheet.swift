//
//  SettingsSheet.swift
//  kinode
//
//  Created by mops on 11/18/23.
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
    
    @StateObject private var searchText = DebouncedState(initValue: "", delay: 1.0)
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @State private var usernameAvailable: Bool = false
    @State private var loadingUsernameCheck: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                FormInput(text: $userProfileInfo.email, title: "Email", placeholder: "example@a.com")
                    .disabled(true)
                    .foregroundStyle(.gray)
                
                
                HStack{
                    FormInput(text: $searchText.currValue, title: "Username", placeholder: "@username")
                        .disabled(toggleEdit)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .foregroundStyle(fieldColorDisabled)
                        .onChange(of: searchText.deValue){
                            // TODO: CLEAN UP
                            self.loadingUsernameCheck = true
                            if (searchText.deValue != userProfileInfo.username) {
                                print("username changed")
                                Task {
                                    do{
                                        if let token = auth.authToken {
                                            self.usernameAvailable = try await userModel.checkUsername(sessionToken: token, usernameInput: searchText.deValue)
                                        }
                                        
                                        self.loadingUsernameCheck = false
                                    }catch {
                                        self.usernameAvailable = false
                                        self.loadingUsernameCheck = false
                                    }
                                }
                            }
                            self.loadingUsernameCheck = false
                        }
                    
                    
                    
                    
                    if (searchText.deValue != userProfileInfo.username){
                        
                        if loadingUsernameCheck {
                            ProgressView()
                                .foregroundStyle(.black)
                        }
                        else if usernameAvailable {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }else {
                            Image(systemName: "x.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                    
                }
                
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
                        ToolbarItem(placement: .topBarTrailing){
                            Button(action: {
                                
                                toggleEdit.toggle()
                            }) {
                                Text("Edit")
                            }
                        }
                    } else {
                        
                        ToolbarItem(placement: .topBarLeading){
                            Button(action: {
                                searchText.currValue = userModel.user.username
                                
                                toggleEdit.toggle()
                            }) {
                                Text("Cancel")
                            }
                        }

                        ToolbarItem(placement: .topBarTrailing){
                            Button(action: {
                                Task{
                                    if usernameAvailable {
                                        if let token = auth.authToken {
                                            do {
                                                try await userModel.updateUserProfileApi(sessionToken: token)
                                                let _ = try await userModel.loadProfileApi(sessionToken: token)
                                            }
                                            catch {
                                                print("Something went wrong when updating profile from modal")
                                            }
                                        }
                                        
                                        
                                        toggleEdit.toggle()
                                    }
                                }
                            }) {
                                Text("Save")
                            }
                        }
                    }
            }
            
            
        }
        .onAppear {
            self.searchText.currValue = userProfileInfo.username
            self.searchText.deValue = userProfileInfo.username
        }
        
    }
}


#Preview {
    SettingsSheet(userProfileInfo: .constant(UserProfile(email: "fake@a.com", name: "I am Me", username: "james182", followers: 0, following: 123, moviesCount: 1234, showsCount: 1234)), userModel: .constant(ProfileModelController(sessionToken: "1234")))
        .environment(AuthModel())
}
