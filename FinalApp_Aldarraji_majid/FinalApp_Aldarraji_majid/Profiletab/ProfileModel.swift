

import Foundation
import SwiftData
import SwiftUI

@Observable
class ProfileModelController {
    var user: UserProfile
    var loading: Bool = false
    
    init(sessionToken: String) {
        self.loading = true
        self.user = UserProfile(email: "no", name: "no", username: "No", followers: 1, following: 1, moviesCount: 1, showsCount: 1)
        
        Task {
            self.loading = true
            self.user = try await loadProfileApi(sessionToken: sessionToken)
            self.loading = false
        }
        
    }
    
    func loadProfileApi(sessionToken: String) async throws -> UserProfile {
        struct userIdJson: Codable {
            let sessionToken: String
        }
        
        let data = try JSONEncoder().encode(userIdJson(sessionToken: sessionToken))
        
        let profileResponse: profileResponseApi = try await client.load(Resource(url: URL.getProfile, method: .post(data)))
        
        print(profileResponse)
        
        if profileResponse.status != "success" {
            throw ProfileModelErros.statusNotSuccess
        }
        
        print("SHOWS COUNT: \(profileResponse.profile.showsCount)")
        
        return profileResponse.profile
    }
    

    
    let client = StoreHTTPClient()
    
    // this funciton is to load user info from server
    // the session comes from view env
    func updateUserProfileApi(sessionToken: String, newUsername: String, newDisplayName: String) async throws {
        struct profileUpdateInput: Codable {
            let sessionToken: String
            let displayName: String
            let username: String
        }
        
        let data = try JSONEncoder().encode(profileUpdateInput(sessionToken: sessionToken, displayName: newDisplayName, username: newUsername))
        
        let userProfileResponse: userProfileUpdateResponse  = try await client.load(Resource(url: URL.updateProfile, method: .post(data)))
        
        if userProfileResponse.status != "success" {
            throw ProfileModelErros.statusNotSuccess
        }
        
        let _ = try await self.loadProfileApi(sessionToken: sessionToken)
    }
    
    func checkUsername(sessionToken: String, usernameInput: String) async throws -> Bool {
        struct  usernameCheckInfoApiInput: Codable {
            let sessionToken: String
            let username: String
        }
        
        let data = try JSONEncoder().encode(usernameCheckInfoApiInput(sessionToken: sessionToken, username: usernameInput))
        
        let usernameAvail: checkUsernameServerResponse = try await client.load(Resource(url: URL.usernameCheck, method: .post(data)))
        
        if usernameAvail.status != "success" {
            return false
        }else {
            return true
        }
    }

}

struct checkUsernameServerResponse: Codable {
    let status: String
    let message: String?
}

struct profileResponseApi: Codable{
    var status: String
    var message: String?
    var profile: UserProfile
}

struct userProfileUpdateResponse: Codable {
    var status: String
    var message: String?
}

enum ProfileModelErros: Error {
    case defaultError(message: String)
    case jsonFailedEncode
    case statusNotSuccess
    case noUserFriends
}


struct UserProfile: Codable {
    var email: String
    var name: String
    var username: String
    var followers: Int
    var following: Int
    var moviesCount: Int
    var showsCount: Int
}

//@Model
//class UserProfile: Codable {
//    var email: String
//    var name: String
//    var username: String
//    var followers: Int
//    var following: Int
//    var moviesCount: Int
//    var showsCount: Int
//    
//    
//    
//    init(email: String, name: String, username: String, followers: Int, following: Int, moviesCount: Int, showsCount: Int) {
//        self.email = email
//        self.name = name
//        self.username = username
//        self.followers = followers
//        self.following = following
//        self.moviesCount = moviesCount
//        self.showsCount = showsCount
//    }
//    
//    
//    // MARK: codable
//    enum CodingKeys: CodingKey {
//        case email, name, username, followers, following, moviesCount, showsCount
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container =  try decoder.container(keyedBy: CodingKeys.self)
//        email = try container.decode(String.self, forKey: .email)
//        name = try container.decode(String.self, forKey: .name)
//        username = try container.decode(String.self, forKey: .username)
//        followers = try container.decode(Int.self, forKey: .followers)
//        following = try container.decode(Int.self, forKey: .following)
//        moviesCount = try container.decode(Int.self, forKey: .moviesCount)
//        showsCount = try container.decode(Int.self, forKey: .showsCount)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(email, forKey: .email)
//        try container.encode(name, forKey: .name)
//        try container.encode(username, forKey: .username)
//        try container.encode(followers, forKey: .followers)
//        try container.encode(following, forKey: .following)
//        try container.encode(moviesCount, forKey: .moviesCount)
//        try container.encode(showsCount, forKey: .showsCount)
//    }
//}
