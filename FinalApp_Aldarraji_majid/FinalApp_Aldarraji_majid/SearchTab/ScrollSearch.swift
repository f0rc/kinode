//
//  ScrollSearch.swift
//  movieapp
//
//  Created by mops on 11/1/23.
//

import SwiftUI

struct ScrollSearch: View {
    @Binding var data: [Media]
    @State var SectionTitle: String = "New title"
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text(SectionTitle)
                    .font(.title2)
                    .foregroundStyle(Color.text)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    HStack{
                        ForEach(data.sorted { (item1, item2) -> Bool in
                            
                            let date1 = item1.firstAirDate ?? item1.releaseDate ?? ""
                            let date2 = item2.firstAirDate ?? item2.releaseDate ?? ""
                            
                            guard let time1 = dateFormatter.date(from: date1)?.timeIntervalSince1970,
                                  let time2 = dateFormatter.date(from: date2)?.timeIntervalSince1970 else {
                                return true
                            }
                            
                            return time1 > time2
                        }, id: \.id) { poster in
                            NavigationLink(destination: MediaDetailView(mediaItem: poster)){
                                HStack(alignment: .top, spacing: 10){
                                    AsyncImage(url: URL(string: tmdbImage(imagePath: poster.posterPath ?? "").fullPath)){img in
                                        img.resizable()
                                    } placeholder: {
                                        Image("DefaultPoster")
                                            .resizable()
                                    }
                                    .frame(width: 100, height: 130)
                                    .cornerRadius(20)
                                }
                                
                            }
                        }
                    }
                    .offset(x: 20)
                    .padding(.trailing, 40)
                }
            }
        }
    }
}

#Preview {
    ScrollSearch(data: .constant([]))
}
