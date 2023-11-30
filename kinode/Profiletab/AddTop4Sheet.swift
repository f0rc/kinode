//
//  AddTop4Sheet.swift
//  kinode
//
//  Created by  on 11/29/23.
//

import SwiftUI

struct AddTop4Sheet: View {
    // if 0 then shows its if 1 then movies
    var typeOfTop: Int = 0
    var index: Int = 0
    var mediaList: [Media] = []
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(alignment: .leading){
                    Text("Add your top 4 \(typeOfTop == 0 ? "Show" : "Movie")")
                        .foregroundStyle(Color("text"))
                        .font(.title)
                        .bold()
                    
                    Text("top # \(index) \(typeOfTop == 0 ? "show" : "movie")")
                        .foregroundStyle(Color("text"))
                    
                    
                    List {
                        ForEach(mediaList, id: \.self) { name in
                            Text((name.title ?? name.name) ?? "No Name")
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("secondaryColor"))
        }
        .onAppear {
            // fetch media list
        }
        
    }
    
    mutating func getTop4Media(sesstionToken: String, typeOfMedia: Int) async throws {
        struct serverInput: Codable {
            let sessionToken: String
            let mediaType: Int
        }
        
        let httpClient = StoreHTTPClient()
        
        let jsonDataInput = try JSONEncoder().encode(serverInput(sessionToken: sesstionToken, mediaType: typeOfMedia))
        
        let response: GetTop4ApiResponse = try await httpClient.load(Resource(url: URL.getTop4, method: .post(jsonDataInput)))
        
        if response.status != "success" {
            print("SERVER ERROR: \(response.message ?? "NO MESSAGE")")
            throw GetReviewsApiErro.failedToFetch
        }
        
        self.mediaList = response.media
    }
}


struct GetTop4ApiResponse: Codable {
    let status: String
    let message: String?
    let media: [Media]
}


#Preview {
    AddTop4Sheet()
}
