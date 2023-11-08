//
//  GetReviews.swift
//  movieapp
//
//  Created by  on 11/2/23.
//

import Foundation


struct ReviewList: Codable {
    var id: String
    var userId: String
    var mediaId: Int
    var rating: Int?
    var watched: Bool?
    var liked: Bool?
    var content: String?
    var createdAt: String?
    var media: SearchResult
}

struct GetReviewsServerResponse: Codable {
    var status: String
    var message: String?
    var reviewList: [ReviewList]?
}


@Observable
class GetReviews{
    var reviewList: [ReviewList] = []
    let client = StoreHTTPClient()
    
    init(authToken: String){
        Task {
            self.reviewList = try await self.loadReviews(authToken: authToken) ?? []
        }
    }
    
    func loadReviews(authToken: String) async throws -> [ReviewList]? {
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

}
