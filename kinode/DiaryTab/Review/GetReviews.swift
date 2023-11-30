//
//  GetReviews.swift
//  movieapp
//
//  Created by  on 11/2/23.
//

import Foundation


func loadReviewsApi(authToken: String) async throws -> [CReview]? {
    struct serverInput: Codable {
        let sessionToken: String
    }
    
    let httpClient = StoreHTTPClient()
    
    let jsonDataInput = try JSONEncoder().encode(serverInput(sessionToken: authToken))
    
    let response: GetReviewsApiResponseType = try await httpClient.load(Resource(url: URL.getReviews, method: .post(jsonDataInput)))
    
    if response.status != "success" {
        print("SERVER ERROR: \(response.message ?? "NO MESSAGE")")
        throw GetReviewsApiErro.failedToFetch
    }
    
    
    
    // converting to [CReview] Type
    let reviewListWithAuthors: [GetReviewsApiResponseType.ReviewListWithAuthor] = [response.reviewList]
    let cReviews: [CReview] = reviewListWithAuthors.map { reviewListWithAuthor in
        let review = reviewListWithAuthor.review
        let author = reviewListWithAuthor.author
        let media = reviewListWithAuthor.media
        
        return CReview(review: review, author: author, media: media)
    }
    
    return cReviews
}


struct GetReviewsApiResponseType: Codable {
    let status: String
    let message: String?
    
    var reviewList: ReviewListWithAuthor
    
    
    struct ReviewListWithAuthor: Codable {
        var review: NewReviewForm
        var author: Author
        var media: Media
    }
}

struct Review: Codable {
    var id: String
    var userId: String
    var mediaId: Int
    var rating: Int
    var watched: Bool
    var liked: Bool
    var content: String?
    var createdAt: String
}

enum GetReviewsApiErro: Error {
    case failedToDecode
    
    case failedToFetch
    
    case unlucky
}



struct getOneReviewResponseType: Codable {
    let status: String
    let message: String?
    let review: Review
}

func getOneReview(authToken: String, mediaId: Int) async throws -> Review? {
    struct serverInput: Codable {
        let sessionToken: String
        let mediaId: Int
    }
    
    let httpClient = StoreHTTPClient()
    
    let jsonDataInput = try JSONEncoder().encode(serverInput(sessionToken: authToken, mediaId: mediaId))
    
    let response: getOneReviewResponseType = try await httpClient.load(Resource(url: URL.getOneReview, method: .post(jsonDataInput)))
    
    if response.status != "success" {
        print("SERVER ERROR: \(response.message ?? "NO MESSAGE")")
        throw GetReviewsApiErro.failedToFetch
    }
    
    return response.review

}
