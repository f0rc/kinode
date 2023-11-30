//
//  LoginView.swift
//  movieapp
//
//  Created by  on 10/10/23.
//

import SwiftUI



struct LoginView: View {
    @State var loginForm = loginUserInput()
    @State var searchQuery = ""
    @Environment(AuthModel.self) private var authModel: AuthModel
    @State var topError = ""
    var body: some View {
        ZStack{
            NavigationStack {
                VStack(spacing: 0.0) {
                    Text("MyMovieList")
                        .padding()
                        .foregroundColor(Color.accentColor)
                        .font(.largeTitle)
                        .bold()
                    
                    
                    Text("\(topError)")
                        .padding()
                        .font(.footnote)
                        .foregroundStyle(.red)
                    
                    
                    VStack {
                        FormInput(text: $loginForm.email,
                                  title: "Email",
                                  placeholder: "james@example.com")
                        .autocapitalization(.none)
                        .padding()
                        
                        FormInput(text: $loginForm.password, title: "Password",
                                  placeholder: "password",
                                  isSecureField: true)
                        .autocapitalization(.none)
                        .padding()
                    }
                    
                    Button(action: {
                        Task {
                            do {
                                try await authModel.login(userInfoInput: loginForm)
                                
                            }catch {
                                print("failed to auth")
                                topError = "Something went wrong!"
                            }
                        }
                    }) {
                        Text("Log In")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    
                    HStack(spacing: 5){
                        
                        Text("Don't have an account?")
                            .font(.footnote)
                        NavigationLink(destination: CreateAccountView().navigationBarBackButtonHidden(true)){ Text("Sign Up")
                                .font(.footnote)
                            .foregroundColor(.blue) }
                        
                    }
                    .padding()
                    
                    
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity)
                .background(Color.onbg)
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.onbg)
        }
        .frame(maxHeight: .infinity)
        .background(Color.onbg)
    }
}


#Preview {
    LoginView()
        .environment(AuthModel())
}
