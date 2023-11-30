//
//  ScrollSearch.swift
//  movieapp
//
//  Created by  on 11/1/23.
//

import SwiftUI

struct ScrollSearch: View {
    @State var data: [Media] = []
    @State var SectionTitle: String = "New title"
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text(SectionTitle)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    HStack{
                        ForEach(data, id: \.id) { poster in
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
                                //                        Image("DefaultPoster")
                                //                            .resizable()
                                //                            .frame(width: 100, height: 130)
                                //                            .cornerRadius(20)
                                
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
    ScrollSearch()
}
