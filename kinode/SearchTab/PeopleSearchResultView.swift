//
//  PeopleSearchResultView.swift
//  kinode
//
//  Created by mops on 11/22/23.
//

import SwiftUI

struct PeopleSearchResultView: View {
    @Binding var searchResult: [Person]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading){
                ForEach($searchResult, id: \.id) { $searchItem in
                    
                    HStack(alignment: .top, spacing: 10){
                        Image("DefaultAvi")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                        
                        VStack(alignment: .leading, spacing: 0){
                            HStack(alignment: .top){
                                Text(searchItem.displayName)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                Spacer()
                            }
                            Text("@\(searchItem.username)")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            HStack{
                                HStack{
                                    Image(systemName: "tv")
                                    Text("\(searchItem.showsCount)")
                                        .font(.caption)
                                }
                                
                                HStack{
                                    Image(systemName: "film")
                                    Text("\(searchItem.moviesCount)")
                                        .font(.caption)
                                }
                                
                                
                            }
                        }
                        .padding(.vertical)
                        
                        
                        
                        
                        if let yearJoin = getJoinYear(createdAt: searchItem.createdAt) {
                            Text(verbatim: "\(yearJoin)")
                                .padding(10)
                                .background(.gray)
                                .cornerRadius(10)
                                .font(.caption)
                                .padding(.vertical)
                        }
                            

                    }
                    
                    Divider()
                }
                
            }
            .padding(.horizontal)
            
        }
    }
}

#Preview {
    PeopleSearchResultView(searchResult: .constant(fakePeopleResult))
}


func getJoinYear(createdAt: String) -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    if let date = dateFormatter.date(from: createdAt) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return year
    }
    return nil
}
