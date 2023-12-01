//
//  MediaDetailView.swift
//  movieapp
//
//  Created by mops on 11/1/23.
//

import SwiftUI
import SwiftData

struct MediaDetailView: View {
    @State var mediaItem: Media
    @Environment(AuthModel.self) private var authModel: AuthModel
    
    
    @State var gradient = [Color(.clear), Color(.black)]
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var modalSelection = false
    
    @State private var apiReivew: Review? = nil
    @State private var loadedReview = false
    
    var body: some View {
        ZStack{
            ScrollView{
                ZStack(alignment: .top){
                    AsyncImage(url:URL(string:getImgUrl(imgPath:tmdbImage(imagePath:mediaItem.posterPath ?? "NOT")))){img in
                        img.resizable()
                    } placeholder: {
                        Image("DefaultPoster")
                            .resizable()
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                    VStack{
                        LinearGradient(colors: gradient, startPoint: .top, endPoint: .bottom).frame(height: 600)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                VStack(alignment: .leading){
                    HStack{
                        if let movieTitle = mediaItem.name ?? mediaItem.title {
                            Text(movieTitle)
                                .font(.title)
                                .foregroundStyle(.white)
                        }
                        Spacer()
                        if let releaseDate = mediaItem.releaseDate ?? mediaItem.firstAirDate {
                            
                            if let date = dateFormatter.date(from: releaseDate) {
                                
                                let calendar = Calendar.current
                                let year = calendar.component(.year, from: date)
                                Text(verbatim: "\(year)")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                    }
                    
                    VStack{
                        if let movieOverview = mediaItem.overview {
                            Text(movieOverview)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                    
                    //TODO: show rating
                    //TODO: show cast + crew
                    //TODO: show if friends likes
                    //TODO: show related tv,movie
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 200)
                .background(.black.opacity(0.1))
            }
            
            VStack(spacing: 0.0){
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    },label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.yellow)
                            .font(.title)
                            .fontWeight(.bold)
                        
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        modalSelection.toggle()
                    },label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundStyle(.yellow)
                            .font(.title)
                            .fontWeight(.bold)
                    })
                    
                }
                .padding(EdgeInsets(top: 46, leading: 20, bottom: 0, trailing: 20))
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .sheet(isPresented: $modalSelection){
                MediaMoreModal(isShown: $modalSelection, mediaItem: $mediaItem, mediaId: mediaItem.id, newReviewFormInput: NewReviewForm(mediaId: mediaItem.id, rating: apiReivew?.rating ?? 0, watched: apiReivew?.watched ?? false, liked: apiReivew?.liked ?? false, content: apiReivew?.content))
                    .presentationDetents([.fraction(0.4)])
                    .presentationDragIndicator(.visible)
                
            }
        }
        
        
        .navigationBarBackButtonHidden(true)
        .background(.black)
        .ignoresSafeArea()
        
    }
}

#Preview {
    MediaDetailView(mediaItem: exampleSearchResults[0])
        .environment(AuthModel())
}
