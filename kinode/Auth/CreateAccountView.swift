//
//  CreateAccountView.swift
//  movieapp
//
//  Created by  on 10/18/23.
//

import SwiftUI

struct CreateAccountView: View {
    @State var createUserForm = createUserInput()
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(AuthModel.self) private var authModel: AuthModel
    @State var topError: String = ""
    

    
    var body: some View {
        NavigationStack {
                VStack(spacing: 0.0) {
                    Text("MyMovieList")
                        .padding()
                        .foregroundColor(Color.accentColor)
                        .font(.largeTitle)
                        .bold()
                    
                    VStack {
                        Text("\(topError)")
                            .font(.footnote)
                        FormInput(text: $createUserForm.email,
                                  title: "Email",
                                  placeholder: "james@example.com")
                        .autocapitalization(.none)
                        .padding()
                        .onChange(of: createUserForm.email){
                            topError = ""
                        }
                        
                        FormInput(text: $createUserForm.username, title: "Username",
                                  placeholder: "username",
                                  isSecureField: false)
                        .autocapitalization(.none)
                        .padding()
                        .onChange(of: createUserForm.username){
                            topError = ""
                        }
                        
                        FormInput(text: $createUserForm.password, title: "Password",
                                  placeholder: "password",
                                  isSecureField: true)
                        .autocapitalization(.none)
                        .padding()
                        .onChange(of: createUserForm.password){
                            topError = ""
                        }
                        
                        FormInput(text: $createUserForm.passwordConfrim, title: "Password Confirm",
                                  placeholder: "password confirm",
                                  isSecureField: true)
                        .autocapitalization(.none)
                        .padding()
                        .onChange(of: createUserForm.passwordConfrim){
                            topError = ""
                        }
                    }
                    
                    Button(action: {
                        Task {
                            do{
                                let didaccountCreate = try await authModel.createUser(createUserForm: createUserForm)
                                presentationMode.wrappedValue.dismiss()
                            }catch{
                                topError = "Something went wrong!"
                            }
                            
                        }
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.accentC)
                    .foregroundColor(.text)
                    .cornerRadius(15)
                    
                    HStack(spacing: 5){
                        
                        Text("Have an account?")
                            .font(.footnote)
                        
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        }label: {
                            Text("Log In")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .padding()
                    
                    
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity)
                .background(Color.onbg)
                
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}


#Preview {
    CreateAccountView()
        .environment(AuthModel())
}
