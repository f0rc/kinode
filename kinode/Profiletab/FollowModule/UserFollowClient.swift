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
        print(response.message)
        throw UserFollowApiError.statusNotSuccess
    }
    
    return true
}
