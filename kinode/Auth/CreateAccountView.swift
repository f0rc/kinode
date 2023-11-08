//
//  CreateAccountView.swift
//  movieapp
//
//  Created by mops on 10/18/23.
//

import SwiftUI

struct CreateAccountView: View {
    @State var createUserForm = createUserInput()
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(AuthModel.self) private var authModel: AuthModel
    @State var topError: String = ""
    

    
    var body: some View {
        NavigationStack {
                VStack(spacing: 0.0) {
                    Text("MyMovieList")
                        .padding()
                    
                    VStack {
                        Text("\(topError)")
                            .font(.footnote)
                            .foregroundStyle(.red)
                        FormInput(text: $createUserForm.email,
                                  title: "Email",
                                  placeholder: "james@example.com")
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .onChange(of: createUserForm.email){
                            topError = ""
                        }
                        
                        FormInput(text: $createUserForm.password, title: "Password",
                                  placeholder: "password",
                                  isSecureField: true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .onChange(of: createUserForm.password){
                            topError = ""
                        }
                        
                        FormInput(text: $createUserForm.passwordConfrim, title: "Password Confirm",
                                  placeholder: "password confirm",
                                  isSecureField: true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .onChange(of: createUserForm.passwordConfrim){
                            topError = ""
                        }
                    }
                    
                    Button(action: {
                        Task {
                            do{
                                let didaccountCreate = try await authModel.createUser(createUserForm: createUserForm)
                            }catch{
                                topError = "Something went wrong!"
                            }
                            
                        }
                    }) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    
                    HStack(spacing: 5){
                        
                        Text("Have an account?")
                            .font(.footnote)
                        
                        Button{
                            dismiss()
                        }label: {
                            Text("Log In")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .padding()
                    
                    
                }
                .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}


#Preview {
    CreateAccountView()
        .environment(AuthModel())
}
