//
//  DiaryTab.swift
//  movieapp
//
//  Created by  on 10/7/23.
//

import SwiftUI
import SwiftData

struct DiaryTab: View {
    @State var colors = [Color(.purple), Color(.black)]
    @Environment(AuthModel.self) private var authModel: AuthModel
    
    
    @State private var Feed: [CReview] = []
    
    
    
    var body: some View {
        ZStack{
            if Feed.count > 0 {
                VStack{
                    List{
                        ForEach($Feed, id: \.review.id) { re in
                            HStack {
                                AsyncImage(url: URL(string: tmdbImage(imagePath: re.media.posterPath.wrappedValue ?? "").fullPath)){img in
                                    img.resizable()
                                } placeholder: {
                                    Image("DefaultPoster")
                                        .resizable()
                                }
                                .frame(width: 100, height: 130)
                                .cornerRadius(20)
                                
                                VStack (alignment: .center){
                                    let desc = reviewDescription(liked: re.review.liked.wrappedValue, watched: re.review.watched.wrappedValue, rating: re.review.rating.wrappedValue, mediaName: (re.media.name.wrappedValue ?? re.media.title.wrappedValue) ?? "", username: re.author.username.wrappedValue)
                                    
                                    Text(desc)
                                        .padding(.horizontal, 20)
                                    
                                    Spacer()
                                    
                                    StarRatingView(rating: re.review.rating.wrappedValue)
                                        .padding(.bottom, 10)
                                }
                                .padding(.vertical, 10)
                            }
                        }
                    }
                }
            }
            else {
                
                VStack{
                    Image(systemName: "theatermasks.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 100)
                    
                    Text("No Reviews made yet please add one and it will be displayed here")
                        .padding()
                        .multilineTextAlignment(.center)
                        .bold()
                }
                .background(Color("onbg"))
                
            }
                
            
            
        }
        .background(Color("onbg"))
        .onAppear{
            if let authToken = authModel.authToken {
                Task {
                    do {
                        let res = try await loadReviewsApi(authToken: authToken)
                        
                        guard let apiReviewList = res else {
                            print("unable to get reviews from api")
                            return
                        }
                        
                        Feed = apiReviewList
                    }
                    catch {
                        print("failed to fetch reviews from api")
                    }
                }
            }
        }
    }
}


func reviewDescription(liked: Bool?, watched: Bool?, rating: Int?, mediaName: String, username: String) -> String {
    var description = username
    
    if liked != nil {
        description += " liked"
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


struct StarRatingView: View {
    let maxRating: Int = 5
    let rating: Int
    
    var body: some View {
        HStack {
            if rating != 0 {
                ForEach(1...maxRating, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}

#Preview {
    DiaryTab()
        .environment(AuthModel())
}
