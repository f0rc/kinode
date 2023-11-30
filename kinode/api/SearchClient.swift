//
//  SearchClient.swift
//  movieapp
//
//  Created by  on 10/31/23.
//

import Foundation


struct Person: Codable {
    let id, displayName, userId: String
    let avatar: String?

    let createdAt, updatedAt: String
    let followers: Int
    let following: Int
    let moviesCount: Int
    let showsCount: Int
    let username: String
    var isFollowing: Bool
}

struct searchRequest: Codable{
    let query: String
    let sessionToken: String
}

struct searchServerResponse: Codable {
    let status: String
    let message: String
    let searchResult: [Media]
}


struct searchPeopleServerResponse: Codable {
    let status: String
    let message: String?
    let people: [Person]
}


func searchApi(req: searchRequest) async throws -> [Media]? {
    let client = StoreHTTPClient()
    
    let data = try JSONEncoder().encode(req)
    
    let searchRes: searchServerResponse  = try await client.load(Resource(url: URL.search, method: .post(data)))
    
    
    
    if searchRes.status != "success" {
        return nil
    }
    
    return searchRes.searchResult
}

func searchPeopleApi(req: searchRequest) async throws -> [Person]? {
    let client = StoreHTTPClient()
    
    let data = try JSONEncoder().encode(req)
    
    let searchResult: searchPeopleServerResponse = try await client.load(Resource(url: URL.searchPeople, method: .post(data)))
    
    if searchResult.status != "success" {
        return nil
    }
    
    return searchResult.people
}






let fakePeopleResult = [
    Person(id: "1aBcDeFgHi", displayName: "JohnDoe", userId: "user_123", avatar: "avatar1.png", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-22 14:45:00", followers: 532, following: 213, moviesCount: 765, showsCount: 123, username: "Johndow", isFollowing: true),
    Person(id: "2XyZaBcDeF", displayName: "AliceSmith", userId: "user_456", avatar: "avatar2.jpg", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-22 16:55:00", followers: 287, following: 442, moviesCount: 765, showsCount: 123, username: "alicesmith_456", isFollowing: false),
    Person(id: "3PqRsTuVwX", displayName: "BobJohnson", userId: "user_789", avatar: "avatar3.png", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-22 18:10:00", followers: 674, following: 129, moviesCount: 765, showsCount: 123, username: "bobjohnson_789", isFollowing: false),
    Person(id: "4MnOpQrStU", displayName: "EmilyBrown", userId: "user_012", avatar: "avatar4.jpg", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-22 20:25:00", followers: 421, following: 311, moviesCount: 765, showsCount: 123, username: "emilybrown_012", isFollowing: false),
    Person(id: "5JkLmNoPqR", displayName: "MichaelAdams", userId: "user_345", avatar: "avatar5.png", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-22 22:40:00", followers: 839, following: 208, moviesCount: 765, showsCount: 123, username: "michaeladams_345", isFollowing: false),
    Person(id: "6EfGhIjKlM", displayName: "SophiaWilson", userId: "user_678", avatar: "avatar6.jpg", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-23 00:55:00", followers: 572, following: 123, moviesCount: 765, showsCount: 123, username: "sophiawilson_678", isFollowing: false),
    Person(id: "7ZxYwVuTsR", displayName: "DavidMiller", userId: "user_901", avatar: "avatar7.png", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-23 03:10:00", followers: 376, following: 468, moviesCount: 765, showsCount: 123, username: "davidmiller_901", isFollowing: false),
    Person(id: "8HgFeDcBaZ", displayName: "OliviaGarcia", userId: "user_234", avatar: "avatar8.jpg", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-23 05:25:00", followers: 714, following: 212, moviesCount: 765, showsCount: 123, username: "oliviagarcia_234", isFollowing: false),
    Person(id: "9YtRxQwPoN", displayName: "WilliamMartinez", userId: "user_567", avatar: "avatar9.png", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-23 07:40:00", followers: 295, following: 642, moviesCount: 765, showsCount: 123, username: "williammartinez_567", isFollowing: false),
    Person(id: "10AzByCxVw", displayName: "EmmaTaylor", userId: "user_890", avatar: "avatar10.jpg", createdAt: "2023-11-27T20:12:55.766Z", updatedAt: "2023-11-23 09:55:00", followers: 765, following: 123, moviesCount: 765, showsCount: 123, username: "emmataylor_890", isFollowing: false)
]
