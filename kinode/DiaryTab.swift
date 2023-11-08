//
//  DiaryTab.swift
//  movieapp
//
//  Created by mops on 10/7/23.
//

import SwiftUI

struct DiaryTab: View {
    @State var colors = [Color(.purple), Color(.black)]
    @Environment(AuthModel.self) private var authModel: AuthModel
    @State var reviews: GetReviews? = nil
    
    func reviewDescription(liked: Bool?, watched: Bool?, rating: Int?, mediaName: String, username: String) -> String {
        var description = username
        
        if var like = liked {
            description += "liked"
        }
        
        if var watch = watched {
            description += " watched"
        }
        
        if let rating = rating {
            description += " and rated \(rating)/10"
        }
        
        description += " \(mediaName)"
        
        return description
    }
    
    var body: some View {
        ZStack{
            
            if let reviewList = reviews?.reviewList {
                if reviewList.count > 0 {
                    List(reviewList, id: \.id) { re in
                        HStack {
                            AsyncImage(url: URL(string: tmdbImage(imagePath: re.media.posterPath ?? "").fullPath)){img in
                                img.resizable()
                            } placeholder: {
                                Image("DefaultPoster")
                                    .resizable()
                            }
                            .frame(width: 100, height: 130)
                            .cornerRadius(20)
                            
                            VStack{
                                let desc = reviewDescription(liked: re.liked, watched: re.watched, rating: re.rating, mediaName: (re.media.name ?? re.media.title) ?? "NA", username: "[user] ")
                                Text(desc)
                            }
                        }
                    }
                }else {
                    Text("No Reviews made yet please add one and it will show here")
                }
            }
            
        }
        .onAppear{
            if let auth = authModel.authToken {
                self.reviews = GetReviews(authToken: auth)
            }
            
        }
    }
}

#Preview {
    DiaryTab(reviews: GetReviews(authToken: "nope"))
        .environment(AuthModel())
}
