//
//  SearchClient.swift
//  movieapp
//
//  Created by  on 10/31/23.
//

import Foundation

struct SearchResult: Codable {
    var adult: Bool?
    var backdropPath: String?
    var id: Int
    var name: String?
    var originalLanguage: String?
    var originalName: String?
    var overview: String?
    var posterPath: String?
    var mediaType: String?
    var genreIDS: [Int]
    var popularity: Double?
    var firstAirDate: String?
    var voteAverage: Double?
    var voteCount: Int?
    var originCountry: [String]?
    var title, originalTitle, releaseDate: String?
    var video: Bool?
    var newFilm: Bool?
    var newSeries: Bool?
    var popularFilm: Bool?
    var popularSeries: Bool?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
        case title
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case video
    }
}

struct searchRequest: Codable{
    let query: String
    let sessionToken: String
}

struct searchServerResponse: Codable {
    let status: String
    let message: String
    let searchResult: [SearchResult]
}


func searchApi(req: searchRequest) async throws -> [SearchResult]? {
    let client = StoreHTTPClient()
    
    let data = try JSONEncoder().encode(req)
    
    let searchRes: searchServerResponse  = try await client.load(Resource(url: URL.search, method: .post(data)))
    
    if searchRes.status != "success" {
        return nil
    }
    
    return searchRes.searchResult
}



let exampleSearchResults: [SearchResult] = [
    SearchResult(
        adult: false,
        backdropPath: "/lNpkvX2s8LGB0mjGODMT4o6Up7j.jpg",
        id: 1398,
        name: "The Sopranos",
        originalLanguage: "en",
        originalName: "The Sopranos",
        overview: "The story of New Jersey-based Italian-American mobster Tony Soprano and the difficulties he faces as he tries to balance the conflicting requirements of his home life and the criminal organization he heads. Those difficulties are often highlighted through his ongoing professional relationship with psychiatrist Jennifer Melfi. The show features Tony's family members and Mafia associates in prominent roles and story arcs, most notably his wife Carmela and his cousin and protégé Christopher Moltisanti.",
        posterPath: "/xjORbljyMZ8mgYlnftYOVujHoAi.jpg",
        mediaType: "tv",
        genreIDS: [18],
        popularity: 749.244,
        firstAirDate: "1999-01-10",
        voteAverage: 8.616,
        voteCount: 2333,
        originCountry: ["US"],
        title: nil,
        originalTitle: nil,
        releaseDate: nil,
        video: nil
    ),
    SearchResult(
        adult: false,
        backdropPath: "/r6nfGBql1SnEDo4VBz2qixz0F9h.jpg",
        id: 119063,
        name: "Soprano: Sing or Die",
        originalLanguage: "fr",
        originalName: "Soprano : à la vie, à la mort",
        overview: "The documentary series tells of the journey made by Saïd M’Roumbaba (aka Soprano), son of Comorian immigrants born in Marseille’s Northern neighborhoods and now one of France’s most popular artists. It reveals a key element of this success: a friendship “for life” with the three other craftsmen of this saga: Mateo, Mej and Djamali.",
        posterPath: "/iBw5E043Wofhh5R4kFjHy2urgx0.jpg",
        mediaType: "tv",
        genreIDS: [99, 18],
        popularity: 5.369,
        firstAirDate: "2022-06-15",
        voteAverage: 2,
        voteCount: 1,
        originCountry: ["FR"],
        title: nil,
        originalTitle: nil,
        releaseDate: nil,
        video: nil
    ),
    SearchResult(
        adult: false,
        backdropPath: nil,
        id: 716912,
        name: "The Real Sopranos",
        originalLanguage: "en",
        originalName: nil,
        overview: "This movie shows the connections between the TV series 'The Sopranos' and a real-life New Jersey Mob. The story of the rise and fall of New Jersey’s DeCavalcante crime family",
        posterPath: nil,
        mediaType: "movie",
        genreIDS: [99],
        popularity: 1.4,
        firstAirDate: nil,
        voteAverage: 0,
        voteCount: 0,
        originCountry: [],
        title: "The Real Sopranos",
        originalTitle: "The Real Sopranos",
        releaseDate: "2006-04-26",
        video: false
    ),
    SearchResult(
        adult: false,
        backdropPath: nil,
        id: 814755,
        name: "Sopranos Unauthorized: Shooting Sites Uncovered",
        originalLanguage: "en",
        originalName: nil,
        overview: "This independent documentary goes further than the Feds to reveal the most talked-about show on TV: its starts, production techniques, and secret locations deep in the heart of New Jersey. Hosted by John Fiore (Gigi of The Sopranos), and featuring Marie Ruffolo.",
        posterPath: "/8RB67PMQQfz0SLMQ0sB7QvX7mFc.jpg",
        mediaType: "movie",
        genreIDS: [99],
        popularity: 1.588,
        firstAirDate: nil,
        voteAverage: 10,
        voteCount: 1,
        originCountry: [],
        title: "Sopranos Unauthorized: Shooting Sites Uncovered",
        originalTitle: "Sopranos Unauthorized: Shooting Sites Uncovered",
        releaseDate: "2002-09-24",
        video: false
    ),
    SearchResult(
        adult: false,
        backdropPath: nil,
        id: 734802,
        name: "Sopranos Behind-The-Scenes Volume 1 of 2",
        originalLanguage: "en",
        originalName: nil,
        overview: "This show is not produced or released by HBO & includes rare never seen footage! See Bloopers, Retakes, & Candid Videos! Visit Filming Locations & watch Flights, Crashes & Whackings! 15 Cast Commentaries illustrate 6 Seasons!",
        posterPath: "/fNmaoALzuf3xKqVf8ipKUGfDRIB.jpg",
        mediaType: "movie",
        genreIDS: [99],
        popularity: 2.99,
        firstAirDate: nil,
        voteAverage: 9,
        voteCount: 2,
        originCountry: [],
        title: "Sopranos Behind-The-Scenes Volume 1 of 2",
        originalTitle: "Sopranos Behind-The-Scenes Volume 1 of 2",
        releaseDate: "2015-07-15",
        video: true
    ),
    SearchResult(
        adult: false,
        backdropPath: nil,
        id: 825118,
        name: "The Last Supper: A Sopranos Session",
        originalLanguage: "en",
        originalName: nil,
        overview: "An intimate and hugely entertaining dinner with key members of the cast of The Sopranos, as they reminisce about the show, filmed in the Little Italy restaurant, IL Cortile, that cast members would go to for a commiseration dinner after their character had been killed off in the show.",
        posterPath: "/j5sFZq6Z6s6oG7ZxB5W28YFkFxT.jpg",
        mediaType: "movie",
        genreIDS: [99],
        popularity: 2.622,
        firstAirDate: nil,
        voteAverage: 8,
        voteCount: 1,
        originCountry: [],
        title: "The Last Supper: A Sopranos Session",
        originalTitle: "The Last Supper: A Sopranos Session",
        releaseDate: "2020-12-27",
        video: false
    )]
