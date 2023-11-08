//
//  SearchTab.swift
//  movieapp
//
//  Created by  on 10/7/23.
//

import SwiftUI
import Combine

struct SearchTab: View {
    @State private var searchResult: [SearchResult] = []
    @Environment(AuthModel.self) private var auth
    
    
    @StateObject private var searchText = DebouncedState(initValue: "")
        private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack(spacing: 0){
                    Group{
                        HStack{
                            Image(systemName: "magnifyingglass")
                            TextField("Search people, movies or shows", text: $searchText.currValue)
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                                .onChange(of: searchText.deValue){
                                    Task {
                                        do{
                                            guard let reqRes = try await searchApi(req: searchRequest(query: searchText.deValue, sessionToken: auth.authToken ?? "")) else {
                                                return
                                            }
                                            
                                            searchResult = reqRes
                                        }catch {
                                            print("epic fail")
                                        }
                                    }
                                }
                        }
                        .padding(EdgeInsets(top: 7, leading: 8, bottom: 7, trailing: 8))
                        .font(.headline)
                        .background(.ultraThinMaterial)
                        .foregroundStyle(.white.opacity(0.6))
                        .cornerRadius(10)
                    }
                    .padding(EdgeInsets(top: 30, leading:20, bottom: 20, trailing: 20))
                    if searchText.currValue == "" {
                        ScrollView{
                            VStack {
                                ScrollSearch(data: exampleSearchResults, SectionTitle: "New Movie Releases")
                                
                                ScrollSearch(data: exampleSearchResults, SectionTitle: "Popular Movie")
                                
                                ScrollSearch(data: exampleSearchResults, SectionTitle: "New TV Show Releases")
                                
                                ScrollSearch(data: exampleSearchResults, SectionTitle: "Popular TV Show")
                            }
                            
                        }
                    }else if searchText.currValue.count > 1 {
                        
                        
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
            }
            .background(.gray)
        }
    }
    
}

#Preview {
    SearchTab()
        .environment(AuthModel())
}



class DebouncedState: ObservableObject {
    @Published var currValue: String
    @Published var deValue: String
    
    init(initValue: String, delay: Double = 0.3) {
        _currValue = Published(initialValue: initValue)
        _deValue = Published(initialValue: initValue)
        
        $currValue
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .assign(to: &$deValue)
    }
}
