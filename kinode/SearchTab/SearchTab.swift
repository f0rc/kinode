//
//  SearchTab.swift
//  movieapp
//
//  Created by  on 10/7/23.
//

import SwiftUI
import Combine

struct SearchTab: View {
    @State private var searchResult: [Media] = []
    
    
    @State private var peopleSearchResult: [Person] = []
    
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
                                    if (searchText.deValue.contains("@")) {
                                        
                                        Task {
                                            do {
                                                guard let reqRes = try await searchPeopleApi(req: searchRequest(query: searchText.deValue, sessionToken: auth.authToken ?? "")) else {
                                                    return
                                                }
                                                
                                                peopleSearchResult = reqRes
                                            }catch {
                                                print("failed to fetch people or result is none")
                                            }
                                        }
                                        
                                    } else if (!searchText.deValue.contains("@") && searchText.deValue.count >= 3) {
                                        Task {
                                            do{
                                                guard let reqRes = try await searchApi(req: searchRequest(query: searchText.deValue, sessionToken: auth.authToken ?? "")) else {
                                                    return
                                                }
                                                
                                                searchResult = reqRes
                                            }catch {
                                                print("failed to fetch media items or result is none")
                                            }
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
                        DiscoverView(data: exampleSearchResults)
                    }
                    else if searchText.deValue.contains("@"){
                        PeopleSearchResultView(searchResult: $peopleSearchResult)
                    }
                    else if searchText.currValue.count > 1{
                        
                        MediaSearchResult(searchResult: $searchResult)
                        
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
            }
            .background(Color("backgroundColor"))
        }
    }
    
}

#Preview {
    SearchTab()
        .environment(AuthModel())
}




