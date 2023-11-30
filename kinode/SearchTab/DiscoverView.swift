//
//  DiscoverView.swift
//  kinode
//
//  Created by  on 11/22/23.
//

import SwiftUI

struct DiscoverView: View {
    
    @State var newMovieRelease: [Media] = []
    @State var popularMovie: [Media] = []
    @State var newTVShows: [Media] = []
    @State var popularTVShows: [Media] = []
    @Environment(AuthModel.self) private var auth
    
    var body: some View {
        ScrollView{
            VStack {
                
                ScrollSearch(data: $popularMovie, SectionTitle: "Popular Movies")
                ScrollSearch(data: $newMovieRelease, SectionTitle: "New Movie Releases")
                
                
                
                ScrollSearch(data: $newTVShows, SectionTitle: "New TV Show Releases")
                
                ScrollSearch(data: $popularTVShows, SectionTitle: "Popular TV Shows")
            }
            
        }
        .onAppear {
            Task {
                if let token = auth.authToken {
                    do {
                        print("SHOW DISCOVER")
                        try await fetchDiscover(sesstionToken: token)
                    }
                    catch {
                        print("unable to fetch discover page")
                    }
                }
            }
        }
    }
    
    func fetchDiscover(sesstionToken: String) async throws {
        struct serverInput: Codable {
            let sessionToken: String
        }
        
        let httpClient = StoreHTTPClient()
        
        let jsonDataInput = try JSONEncoder().encode(serverInput(sessionToken: sesstionToken))
        
        let response: DiscoverApiResonponseType = try await httpClient.load(Resource(url: URL.discover, method: .post(jsonDataInput)))
        
        if response.status != "success" {
            print("SERVER ERROR: \(response.message ?? "NO MESSAGE")")
            throw GetReviewsApiErro.failedToFetch
        }
        

        
        
        newMovieRelease = response.newFilms
        popularMovie = response.popularFilms
        newTVShows = response.newShows
        popularTVShows = response.popularShows
        
    }

}


struct DiscoverApiResonponseType: Codable {
    let status: String
    let message: String?
    let newFilms: [Media]
    let popularFilms: [Media]
    let newShows: [Media]
    let popularShows: [Media]
}


#Preview {
    DiscoverView(newMovieRelease: exampleSearchResults)
        .environment(AuthModel())
}
