//
//  MediaMoreModal.swift
//  movieapp
//
//  Created by mops on 11/1/23.
//

import SwiftUI

struct MediaMoreModal: View {
    @Binding var isShown: Bool
    @Binding var mediaItem: SearchResult
    var mediaId: Int
    @Environment(ReviewModel.self) private var reviews
    @Environment(AuthModel.self) private var auth
    
    @State var newReview: Review

    
    var body: some View {
        
        ZStack{
            Color.black
                .opacity(0.9)
                .ignoresSafeArea()
                .onTapGesture{
                    isShown = false
                }
            
            VStack(spacing: 10){
                Spacer()
                HStack(spacing:0){
                    Button(action: {
                        newReview.liked.toggle()
                    }, label: {
                        VStack{
                            if newReview.liked != false {
                                Image(systemName:"heart.fill")
                                    .foregroundStyle(.red)
                                    .font(.largeTitle)
                            }else{
                                Image(systemName:"heart")
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                            }
                            Text("Like")
                                .foregroundStyle(.white)
                                .font(.caption)
                        }
                    })
                    Spacer()
                    
                    Button(action: {
                        self.newReview.watched?.toggle()
                    }, label: {
                        VStack{
                            if newReview.watched != false {
                                Image(systemName:"eye.fill")
                                    .foregroundStyle(.blue)
                                    .font(.largeTitle)
                            }else{
                                Image(systemName:"eye")
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                            }
                            Text("Watched")
                                .foregroundStyle(.white)
                                .font(.caption)
                        }
                    })
                    Spacer()
                    Button(action: {
                        print("add to watched")
                    }, label: {
                        VStack{
                            Image(systemName:"list.bullet.rectangle")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                            Text("Watchlist")
                                .foregroundStyle(.white)
                                .font(.caption)
                        }
                    })
                }
                Divider()
                Spacer()
                Section{
                    Text("Rate")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    
                    
                    RatingView(rating: $newReview.rating)
                }
                Divider()
                Spacer()
                
                Section{
                    Button(action: {
                        Task{
                            if let token = auth.authToken {
                                await reviews.addReview(review: newReview, sessionToken: token)
                            }
                            
                            reviews.loadReviews()
                            isShown.toggle()
                        }
                    }, label: {
                        Text("Done")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                    })
                        
                }
                
            }
            .padding(.horizontal, 40)
        }
        .onAppear{
            if let reviewMade = reviews.getReview(forMediaItem: mediaItem) {
                newReview = reviewMade
            }
        }
    }
}

#Preview {
    MediaMoreModal(isShown: .constant(false), mediaItem: .constant(exampleSearchResults[0]), mediaId: 123, newReview: Review(id: "1234", userId: "1234", mediaId: 1, createdAt: "w13alskfdj"))
        .environment(ReviewModel())
        .environment(AuthModel())

}


