//
//  ProfileModel.swift
//  kinode
//
//  Created by  on 11/7/23.
//

import Foundation

struct userInfo: Codable{
    var email: String
    var name: String
    var username: String
    var followers: Int
    var following: Int
    var moviesCount: Int
    var showsCount: Int
}

struct userFriendsModel: Codable {
    var userFollowing: [userInfo]?
    var userFollowers: [userInfo]?
}


struct userFriendsServerResponse: Codable {
    var status: String
    var message: String?
    var userFriends: userFriendsModel?
}



@Observable
class ProfileModel {
    var user: userInfo?
    var userFriends: userFriendsModel?
    var userSession: String
    
    let client = StoreHTTPClient()
    
    init(authToken: String){
        // load up userinfo
        Task {
            self.user = try await loadUserAppStorage()
        }
        self.userSession = authToken
        userFriends = nil
    }
    
    func loadUserAppStorage() async throws -> userInfo {
        // try to load userinfo from app storage
        
    }
    
    func loadUserApi() async throws -> userFriendsModel {
        struct userIdJson: Codable {
            let sessionToken: String
        }
        
        let data = try JSONEncoder().encode(userIdJson(sessionToken: userSession))
        
        let userFriends: userFriendsServerResponse  = try await client.load(Resource(url: URL.userFriends, method: .post(data)))
        
        if userFriends.status != "success" {
            throw ProfileModelErros.statusNotSuccess
        }
        
        if let fren = userFriends.userFriends {
            return fren
        }else {
            throw ProfileModelErros.noUserFriends
        }
    }

}

enum ProfileModelErros: Error {
    case defaultError(message: String)
    case jsonFailedEncode
    case statusNotSuccess
    case noUserFriends
}
