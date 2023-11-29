//
//  UserFollowClient.swift
//  kinode
//
//  Created by mops on 11/27/23.
//

import Foundation


struct userFollowServerInput: Codable {
    let sessionToken: String
    let userToFollowId: String
}

struct UserFollowServerResponse: Codable {
    let status: String
    let message: String?
}

enum UserFollowApiError: Error {
    case failedJsonEncode
    case statusNotSuccess
}

func followUser(reqInput: userFollowServerInput) async throws -> Bool {
    let httpClient = StoreHTTPClient()
    
    let jsonDataInput = try JSONEncoder().encode(reqInput)
    
    let response: UserFollowServerResponse = try await httpClient.load(Resource(url: URL.followUser, method: .post(jsonDataInput)))
    
    if response.status != "success" {
        print("SERVER ERROR: \(response.message ?? "NO MESSAGE")")
        throw UserFollowApiError.statusNotSuccess
    }
    
    return true
}


func unFollowUser(reqInput: userFollowServerInput) async throws -> Bool {
    let httpClient = StoreHTTPClient()
    
    let jsonDataInput = try JSONEncoder().encode(reqInput)
    
    let response: UserFollowServerResponse = try await httpClient.load(Resource(url: URL.unfollowUser, method: .post(jsonDataInput)))
    
    if response.status != "success" {
        throw UserFollowApiError.statusNotSuccess
    }
    
    return true
}
