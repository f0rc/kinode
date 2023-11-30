//
//  MediaMoreModal.swift
//  movieapp
//
//  Created by  on 11/1/23.
//

import SwiftUI

struct MediaMoreModal: View {
    @Binding var isShown: Bool
    @Binding var mediaItem: Media
    var mediaId: Int
    @Environment(AuthModel.self) private var auth
    
    @State var newReviewFormInput: NewReviewForm
    @State private var loadedReview: Bool = false
    
    
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
                        $newReviewFormInput.liked.wrappedValue.toggle()
                    }, label: {
                        VStack{
                            if $newReviewFormInput.liked.wrappedValue != false {
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
                        $newReviewFormInput.watched.wrappedValue.toggle()
                    }, label: {
                        VStack{
                            if $newReviewFormInput.watched.wrappedValue != false {
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
                    
                    
                    RatingView(rating: $newReviewFormInput.rating)
                }
                Divider()
                Spacer()
                
                Section{
                    Button(action: {
                        Task{
                            guard let authToken = auth.authToken else {
                                print("no auth token in MediaMoreModal")
                                return
                            }
                            do {
                                _ = try await createReview(
                                    mediaId: mediaItem.id,
                                    rating: $newReviewFormInput.rating.wrappedValue, watched: $newReviewFormInput.watched.wrappedValue, content: $newReviewFormInput.content.wrappedValue, liked: $newReviewFormInput.liked.wrappedValue, sessionToken: authToken)
                                print("successfully made review")
                            }
                            catch {
                                print("failed to create review")
                            }
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
        .onAppear {
            Task {
                do {
                    if let token = auth.authToken {
                        let j = try await getOneReview(authToken: token, mediaId: mediaItem.id)
                        
                        print("FOUND REVIEW")
                        loadedReview = true
                        guard let joemama = j else {
                            return
                        }
                    newReviewFormInput = NewReviewForm(mediaId: joemama.mediaId, rating: joemama.rating, watched: joemama.watched, liked: joemama.liked, content: joemama.content)
                    }
                } catch {
                    loadedReview = true
                    print("No review found new review created")
                }
            }
        }
    }
}

#Preview {
    MediaMoreModal(isShown: .constant(false), mediaItem: .constant(exampleSearchResults[0]), mediaId: 123, newReviewFormInput: fakeReviewPage)
        .environment(AuthModel())
    
}

let fakeReviewPage: NewReviewForm = NewReviewForm(mediaId: 1234, rating: 4, watched: false, liked: true)


