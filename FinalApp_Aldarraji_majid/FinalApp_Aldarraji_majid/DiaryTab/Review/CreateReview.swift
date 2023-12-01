

import Foundation


func createReview(mediaId: Int, rating: Int, watched: Bool, content: String?, liked: Bool, sessionToken: String) async throws -> Review {
    
    let client = StoreHTTPClient()
    
    struct serverInput: Codable {
        let sessionToken: String
        let mediaId: Int
        let rating: Int
        let watched: Bool
        let contnet: String?
        let liked: Bool
    }
    
    let jsonDataInput = try JSONEncoder().encode(serverInput(sessionToken: sessionToken, mediaId: mediaId, rating: rating, watched: watched, contnet: content, liked: liked))
    
    let response: getOneReviewResponseType = try await client.load(Resource(url: URL.createReview, method: .post(jsonDataInput)))
    
    if response.status != "success" {
        print("SERVER ERROR: \(response.message ?? "NO MESSAGE")")
        throw GetReviewsApiErro.failedToFetch
    }
    
    return response.review
}
