//
//  MediaSearchResult.swift
//  kinode
//
//  Created by  on 11/22/23.
//

import SwiftUI

struct MediaSearchResult: View {
    @Binding var searchResult: [Media]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading){
                ForEach($searchResult, id: \.id) { $searchItem in
                    NavigationLink(destination: MediaDetailView(mediaItem: searchItem)){
                        HStack(alignment: .top, spacing: 10){
                            AsyncImage(url:URL(string:getImgUrl(imgPath: tmdbImage(imagePath: searchItem.posterPath ?? "NOT")))
                            ){img in
                                img.resizable()
                            } placeholder: {
                                Image("DefaultPoster")
                                    .resizable()
                            }
                            .frame(width: 100, height: 130)
                            .cornerRadius(20)
                            
                            VStack(alignment: .leading, spacing: 0){
                                HStack(alignment: .top){
                                    Text((searchItem.name ?? searchItem.title) ?? "Unable to fetch Name")
                                        .font(.headline)
                                        .lineLimit(1)
                                    Spacer()
                                    
                                    if let releaseDate = searchItem.releaseDate ?? searchItem.firstAirDate {
                                        
                                        if let date = dateFormatter.date(from: releaseDate) {
                                            
                                            let calendar = Calendar.current
                                            let year = calendar.component(.year, from: date)
                                            Text(verbatim: "\(year)")
                                                .font(.footnote)
                                        }
                                    }
                                }
                                Spacer()
                                if let summaryText = searchItem.overview {
                                    Text(summaryText)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                }
                                Spacer()
                                HStack(alignment: .center, spacing:0){
                                    
                                    if let voteAverage = searchItem.voteAverage {
                                        
                                        if(voteAverage >= 0.1){
                                            Image(systemName: "star.fill")
                                                .padding(.trailing, 3)
                                            let rating = String(format: "%.1f", voteAverage)
                                            Text("\(rating)/10")
                                                .font(.system(size:17))
                                        }
                                        
                                    }
                                }
                                
                                
                                
                            }
                            .padding(.top)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    MediaSearchResult(searchResult: .constant(exampleSearchResults))
}


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
    }()
