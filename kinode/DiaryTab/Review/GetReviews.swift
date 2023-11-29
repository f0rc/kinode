//
//  GetReviews.swift
//  movieapp
//
//  Created by  on 11/2/23.
//

import Foundation


struct ReviewList: Codable {
    var review: Review
    var media: SearchResult
    var author: Author
    
    
    struct Author: Codable {
        var id: String
        var username: String
    }
}

struct GetReviewsServerResponse: Codable {
    var status: String
    var message: String?
    var reviewList: [ReviewList]?
}


@Observable
class GetReviews{
    var reviewList: [ReviewList] = []
    
    
    init(authToken: String){
        Task {
            self.reviewList = try await loadReviews(authToken: authToken) ?? []
        }
    }
}

func loadReviews(authToken: String) async throws -> [ReviewList]? {
    let client = StoreHTTPClient()
    
    struct serverInput: Codable {
        var sessionToken: String
    }
    
    let data = try JSONEncoder().encode(serverInput(sessionToken:authToken))
    
    
    let res: GetReviewsServerResponse  = try await client.load(Resource(url: URL.getReviews, method: .post(data)))
    
    if res.status != "success" {
        return nil
    }
    
    if let gotReviews = res.reviewList {
        return gotReviews
    }
    
    return nil
}

