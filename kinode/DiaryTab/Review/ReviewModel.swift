//
//  ReviewModel.swift
//  movieapp
//
//  Created by  on 11/1/23.
//

import Foundation
import SwiftUI


@Observable
class ReviewModel {
    
    
    var reviews: [Review] = []
    
    let client = StoreHTTPClient()
    
    init() {
        self.loadReviews()
    }
    
    func loadReviews() {
        let userDefaults = UserDefaults.standard
        
        // Loop through UserDefaults keys and load reviews
        for key in userDefaults.dictionaryRepresentation().keys {
            if key.contains("_") {
                // Assuming that keys with "_" in the name correspond to review data
                if let data = userDefaults.data(forKey: key) {
                    let decoder = JSONDecoder()
                    if let review = try? decoder.decode(Review.self, from: data) {
                        reviews.append(review)
                    }
                }
            }
        }
    }
    
    func getReview(forMediaItem mediaItem: SearchResult) -> Review? {
        return reviews.first { $0.mediaId == mediaItem.id }
    }
    
    func saveReviewToUserDefaults(review: Review) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(review) {
            UserDefaults.standard.set(encoded, forKey: "\(review.mediaId)_\(review.id)")
        }else {
            print("failed to save to user dfaults")
        }
    }

    
    func sendReviewToServer(review: Review, sessionToken: String) async throws -> Bool{
        let reviewServer = ReviewServerInput(sessionToken: sessionToken, mediaId: review.mediaId, rating: review.rating, liked: review.liked, content: "CONTENT IDK WHAT")
        
        let data = try JSONEncoder().encode(reviewServer)
        
        
        let isSessionValid: ReviewServerResponse  = try await client.load(Resource(url: URL.review, method: .post(data)))
        
        
        if isSessionValid.status != "success" {
            return false
        }
        
        return true
    }
    
    func addReview(review: Review, sessionToken: String) async {
        reviews.append(review)
        saveReviewToUserDefaults(review: review)
        do {
           _ = try await sendReviewToServer(review: review, sessionToken: sessionToken)
        }catch {
            print("unable to post review")
        }
    }
    
}
struct Review: Codable {
    
    var id: String
    var userId: String
    var mediaId: Int
    var rating: Int = 0
    var watched: Bool?
    var liked: Bool = false
    var content: String?
    var createdAt: String
}


struct ReviewServerResponse: Codable {
    var status: String
    var message: String
}

struct ReviewServerInput: Codable {
    let sessionToken: String
    var mediaId: Int
    var rating: Int?
    var liked: Bool?
    var watched: Bool?
    var content: String?
}
