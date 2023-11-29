//
//  DiaryTab.swift
//  movieapp
//
//  Created by  on 10/7/23.
//

import SwiftUI

struct DiaryTab: View {
    @State var colors = [Color(.purple), Color(.black)]
    @Environment(AuthModel.self) private var authModel: AuthModel
    @State var reviews: [ReviewList] = []
    
    func reviewDescription(liked: Bool?, watched: Bool?, rating: Int?, mediaName: String, username: String) -> String {
        var description = username
        
        if liked != nil {
            description += "liked"
        }
        
        if watched != nil {
            description += " watched"
        }
        
        if rating != nil {
            description += " and rated"
        }
        
        description += " \(mediaName)"
        
        return description
    }
    
    var body: some View {
        ZStack{
            if reviews.count > 0 {
                List($reviews, id: \.review.id) { re in
                    HStack {
                        if let posterPath: String = re.media.posterPath.wrappedValue {
                            AsyncImage(url: URL(string: tmdbImage(imagePath: posterPath ).fullPath)){img in
                                img.resizable()
                            } placeholder: {
                                Image("DefaultPoster")
                                    .resizable()
                            }
                            .frame(width: 100, height: 130)
                            .cornerRadius(20)
                        } else {
                            let _ = print("unable ot get posterpath")
                        }
                        
                        VStack{
                            let desc = reviewDescription(liked: re.review.liked.wrappedValue, watched: re.review.watched.wrappedValue, rating: re.review.rating.wrappedValue, mediaName: ((re.media.name.wrappedValue ?? re.media.title.wrappedValue) ?? "NA"), username: "[user] ")
                            Text(desc)
                        }
                    }
                }
            }else {
                Text("No Reviews made yet please add one and it will be displayed here")
            }
            
        }
        .onAppear{
            if let auth = authModel.authToken {
                Task {
                    guard let findReviews = try await loadReviews(authToken: auth) else {
                        print("unable to load reviews")
                        return
                    }
                    reviews = findReviews
                }
            }
            
        }
    }
}

#Preview {
    DiaryTab()
        .environment(AuthModel())
}
