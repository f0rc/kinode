

import Foundation
import SwiftData


//@Model
//class CReview: Identifiable {
//    
//    var internalId: String
//    
//    
//
//    
//    init(review: NewReviewForm, author: Author, media: Media) {
//        self.internalId = UUID().uuidString
//        self.review = review
//        self.author = author
//        self.media = media
//    }
//}

struct CReview: Codable {
    var review: Review
    var author: Author
    var media: Media
}

struct NewReviewForm: Codable {
    var mediaId: Int
    var rating: Int
    var watched: Bool
    var liked: Bool
    var content: String?
}

struct Author: Codable {
    var userId: String
    var username: String
}

struct Media: Codable, Hashable {
    
    var id: Int
    
    var adult: Bool?
    var backdropPath: String?
    
    var originalLanguage: String?
    var originalName: String?
    
    var posterPath: String?
    var mediaType: String?
    var genreIDS: [Int]
    var popularity: Double?

    var voteAverage: Double?
    var voteCount: Int?
    var name: String?
    var title: String?
    var originalTitle: String?
    var overview: String?
    
    let releaseDate: String?
    var firstAirDate: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        
        
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case title
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
}

let exampleSearchResults: [Media] = [Media(id: 1234, genreIDS: [123,123], releaseDate: "NOT")]


let mediaItem = Media(id: 1234, adult: false, backdropPath: "/aslkjdfalskdfj", originalLanguage: "fr", originalName: "Sopranos", posterPath: "/alsjkdfas", mediaType: "tv", genreIDS: [13,1], popularity: 34.1, voteAverage: 31.3, voteCount: 1235, name: "Sopranos", title: "sopranos", originalTitle: "not sopranos", overview: "This is a very nice show", releaseDate: "1239u02", firstAirDate: "008owjiflaks")
