

import SwiftUI

struct SettingsSheet: View {
    @Environment(AuthModel.self) private var auth
    
    @Binding var userProfileInfo: UserProfile
    
    @Binding var userModel: ProfileModelController
    
    @State private var toggleEdit: Bool = true
    
    var fieldColorDisabled: Color {
        return toggleEdit ? .gray : .black
    }
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    @State private var newDiplayName: String = ""
    @StateObject private var userNameText = DebouncedState(initValue: "", delay: 1.0)
    
    @State private var usernameAvailable: Bool = false
    @State private var loadingUsernameCheck: Bool = false
    
    
    var body: some View {
        NavigationStack{
            VStack{
                FormInput(text: $userProfileInfo.email, title: "Email", placeholder: "example@a.com")
                    .disabled(true)
                    
                
                
                HStack{
                    FormInput(text: $userNameText.currValue, title: "Username", placeholder: "@username")
                        .disabled(toggleEdit)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .foregroundStyle(fieldColorDisabled)
                        .onChange(of: userNameText.deValue){
                            // TODO: CLEAN UP
                            
                            if (userNameText.deValue != userProfileInfo.username) {
                                print("username changed")
                                Task {
                                    self.loadingUsernameCheck = true
                                    do{
                                        if let token = auth.authToken {
                                            self.usernameAvailable = try await userModel.checkUsername(sessionToken: token, usernameInput: userNameText.deValue)
                                        }
                                        
                                        self.loadingUsernameCheck = false
                                    }catch {
                                        self.usernameAvailable = false
                                        self.loadingUsernameCheck = false
                                    }
                                    
                                    self.loadingUsernameCheck = false
                                }
                            }
                            
                        }
                    
                    
                    
                    
                    if (userNameText.deValue != userProfileInfo.username){
                        
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
                
                FormInput(text: $newDiplayName, title: "Display Name", placeholder: "James")
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
                .padding([.bottom], 20)
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
                                userNameText.currValue = userModel.user.username
                                newDiplayName = userModel.user.name
                                toggleEdit.toggle()
                            }) {
                                Text("Cancel")
                                    .foregroundStyle(Color.text)
                            }
                        }
                        

                        ToolbarItem(placement: .topBarTrailing){
                            Button(action: {
                                Task{
                                    if usernameAvailable || userNameText.deValue == userModel.user.username {
                                        if let token = auth.authToken {
                                            do {
                                                try await userModel.updateUserProfileApi(sessionToken: token, newUsername: userNameText.deValue, newDisplayName: newDiplayName)
                                                userModel.user = try await userModel.loadProfileApi(sessionToken: token)
                                            }
                                            catch {
                                                print("Something went wrong when updating profile from modal")
                                            }
                                        }
                                        
                                        
                                        toggleEdit.toggle()
                                    }
                                }
                            }, label: {
                                Text("Save")
                            }
                                
                            )
                            
                            
                        }
                    }
            }
            
            
        }
        .accentColor(Color.text)
        .onAppear {
            
            self.userNameText.currValue = userProfileInfo.username
            self.userNameText.deValue = userProfileInfo.username
            self.newDiplayName = userProfileInfo.name
        }
        .onDisappear{
            Task{
                if let token = auth.authToken {
                    do {
                        userModel.user = try await userModel.loadProfileApi(sessionToken: token)
                    }
                    catch {
                        print("after modal release unable to fetch profile")
                    }
                }
            }
        }
        
    }
}


#Preview {
    SettingsSheet(userProfileInfo: .constant(UserProfile(email: "fake@a.com", name: "I am Me", username: "james182", followers: 0, following: 123, moviesCount: 1234, showsCount: 1234)), userModel: .constant(ProfileModelController(sessionToken: "1234")))
        .environment(AuthModel())
}
