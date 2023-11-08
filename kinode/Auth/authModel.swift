////
////  authModel.swift
////  movieapp
////
////  Created by mops on 10/12/23.
////
//
import Foundation
import Observation
import Security
import SwiftUI


@MainActor
@Observable
class AuthModel {
    init() {
        print("innnitting")
        Task {
            self.loading = true
            await self.loadSavedSessionData()
            self.loading = false
        }
    }
    let authServiceName = "auth"
    
    let client = StoreHTTPClient()
    
    
    var authToken: String?
    var userEmail: String?
    var isAuthenticated: Bool = false
    var loading: Bool = false
    
    
    private func loadSavedSessionData() async {
        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            print("unable to find user email")
            return
        }
        
        guard let authTokenData = keychainRead(service: authServiceName, account: userEmail),
              let authTokenT = String(data: authTokenData, encoding: .utf8) else {
            // Auth token is not found; the session data is not available.
            print("unable to find authtoken from keychain read")
            return
        }
        
        // verify session
        var verifySessionRes: Bool?
        do{
            verifySessionRes = try await self.verifySession(authTokenT: authTokenT)
        }
        catch {
            print("[loadSavedSessionData] FAILED TO VERIFY SESSION TOKEN FUNCTION")
            return
        }
        
        if verifySessionRes != true {
            self.userEmail = nil
            self.authToken = nil
            self.isAuthenticated = false
            return
        }
        
        // Set the loaded session data in your model.
        self.userEmail = userEmail
        self.authToken = authTokenT
        self.isAuthenticated = true
    }
    
    // ------ Verify Session ------
    
    func verifySession(authTokenT: String) async throws -> Bool{
        struct sessionJson: Codable {
            let sessionToken: String
        }

        let data = try JSONEncoder().encode(sessionJson(sessionToken: authTokenT))
        
        let isSessionValid: VerifySessionServerResponse  = try await client.load(Resource(url: URL.verifySession, method: .post(data)))
        
        if isSessionValid.status != "success" {
            return false
        }
        
        return true
    }
    
    // ------ LOGOUT FLOW ------
    func logout() async throws{
        do {
            guard let sessionToken = self.authToken else {
                print("[LOGOUT] authmodel state does not have authToken")
                throw AuthApiError.defaultError(message: "must be logged in to sign out")
            }
            guard let removedEmail = self.userEmail else {
                throw AuthApiError.defaultError(message: "[LOGOUT]  no email found")
            }
            
            let jsonLogoutBody = logoutUserInput(sessionToken: sessionToken)
            
            guard let encoded = try? JSONEncoder().encode(jsonLogoutBody) else {
                print("[LOGOUT] Failed to encode Auth token Info")
                throw AuthApiError.jsonFailedEncode
            }
            
            let url = URL.logout
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            do {
                let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
                let decodedInfo = try JSONDecoder().decode(defaultServerResponseI.self, from: data)
                
                if decodedInfo.status != "success" {
                    throw AuthApiError.defaultError(message: "[LOGOUT]  status not sucess")
                }
                
                UserDefaults.standard.removeObject(forKey: "userEmail")
                
                let _ = keychainRead(service: self.authServiceName, account: removedEmail)
                
                self.isAuthenticated = false
                self.authToken = nil
                self.userEmail = nil
                
                return
            }catch {
                print("[LOGOUT] something failed")
                throw AuthApiError.defaultError(message: "[LOGOUT]  FAILED")
            }
            
            
        }
    }
    
    // ------ LOGIN FLOW ------
    // LoginView.swift -> login button function
    func login(userInfoInput:loginUserInput ) async throws -> Bool {
        
        do {
            guard let authToken = try await authenticateUser(userInfo: userInfoInput) else {
                throw AuthApiError.defaultError(message: "Login failed to get authentication token")
            }
            self.authToken = authToken
            self.userEmail = userInfoInput.email
            // save to user defaults
            UserDefaults.standard.set(self.userEmail, forKey: "userEmail")

            let savedTokenBool = saveAuthTokenKeychain(aToken: authToken) // return true if it works
            self.isAuthenticated = true
            return savedTokenBool
            
        }
        catch {
            throw AuthApiError.defaultError(message: "Login failed failed to save??")
        }
    }
    
    // make call to backend to get authentication token or throw error
    private func authenticateUser(userInfo: loginUserInput) async throws -> String? {
        guard let encoded = try? JSONEncoder().encode(userInfo) else {
            print("Failed to encode User Login Info")
            throw AuthApiError.jsonFailedEncode
        }
        
        let url = URL.login
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedInfo = try JSONDecoder().decode(LoginUserServerResponse.self, from: data)
            if decodedInfo.status != "success" {
                throw AuthApiError.defaultError(message: "[authenticateUser] status not sucess")
            }
            
            return decodedInfo.sessionToken
        }catch {
            print("[authenticateUser] status not sucess")
            throw AuthApiError.defaultError(message: "[authenticateUser] FAILED")
        }
    }
    
    // ------ LOGIN FLOW END ------
    
    private func getAuthToken() -> Data? {
        guard let email = userEmail else {
            return nil
        }
        return keychainRead(service: "auth", account: email)
    }
    
    private func saveAuthTokenKeychain(aToken: String) -> Bool {
        
        guard let email = userEmail else {
            return false
        }
        
        guard let userAuthToken = aToken.data(using: .utf8) else {
            return false
        }
        
        return keychainSave(userAuthToken, service: "auth", account: email)
    }
    
    func createUser(createUserForm: createUserInput) async throws -> Bool {
        guard let encoded = try? JSONEncoder().encode(createUserForm) else {
            print("Failed to encode User Form")
            throw AuthApiError.jsonFailedEncode
        }
        
        let url = URL.createUser
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedInfo = try JSONDecoder().decode(CreateUserAccountServerResponse.self, from: data)
            if(decodedInfo.status != "success"){
                throw AuthApiError.defaultError(message: decodedInfo.message)
            }
            
            return true
        } catch {
            print("failed to create user \(error.localizedDescription)")
            throw AuthApiError.defaultError(message: "something went wrong")
        }
        
    }
    
}








protocol defaultServerResponse: Codable {
    var message: String { get }
    var status: String { get }
}

struct defaultServerResponseI: defaultServerResponse {
    var message: String = ""
    var status: String = ""
}

struct LoginUserServerResponse: defaultServerResponse {
    var message: String = ""
    var status: String = ""
    var sessionToken: String?
}

struct CreateUserAccountServerResponse: defaultServerResponse {
    var message: String = ""
    var status: String = ""
}

struct VerifySessionServerResponse: defaultServerResponse {
    var message: String = ""
    var status: String = ""
}


struct createUserInput: Codable {
    var email: String = ""
    var password: String = ""
    var passwordConfrim: String = ""
}


struct loginUserInput: Codable {
    var email: String = ""
    var password: String = ""
}
struct logoutUserInput: Codable {
    var sessionToken: String = ""
}


enum AuthApiError: Error {
    case defaultError(message: String)
    case jsonFailedEncode
}
