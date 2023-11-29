//
//  PeopleSearchResultView.swift
//  kinode
//
//  Created by mops on 11/22/23.
//

import SwiftUI

struct PeopleSearchResultView: View {
    @Binding var searchResult: [Person]
    @Environment(AuthModel.self) private var authModel: AuthModel
    
    @State var followApiLoading: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading){
                ForEach($searchResult, id: \.id) { $searchItem in
                    
                    HStack(alignment: .center, spacing: 10){
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
                        
                        
                        
                        
                        VStack{
//                            if let yearJoin = getJoinYear(createdAt: searchItem.createdAt) {
//                                Text(verbatim: "\(yearJoin)")
//                                    .padding(10)
//                                    .background(.gray)
//                                    .cornerRadius(10)
//                                    .font(.caption)
//                                    .padding(.vertical)
//                            }
                            
                            if searchItem.isFollowing {
                                // FOLLOW BUTTON
                                Button(action: {
                                    self.followApiLoading = true
                                    Task {
                                        do {
                                            
                                            let unFollowedUser = try await unFollowUser(reqInput: userFollowServerInput(sessionToken: authModel.authToken!, userToFollowId: searchItem.userId))
                                            
                                            if unFollowedUser == true {
                                                print("unfollowed user success")
                                                searchItem.isFollowing = false
                                                
                                            }
                                            
                                            
                                            
                                            
                                            self.followApiLoading = false
                                        } catch {
                                            print("failed to unfollow user")
                                            print(error.localizedDescription)
                                            self.followApiLoading = false
                                        }
                                    }
                                    
                                    
                                }, label: {
                                    if followApiLoading {
                                        ProgressView()
                                    } else {
                                        Text("Following")
                                            .padding(10)
                                            .background(.green)
                                            .cornerRadius(10)
                                            .font(.subheadline)
                                            .foregroundStyle(.black)
                                    }
                                })
                            }
                            // TODO: ADD ELSE IF THE SEARCH RESULT IS THE USER'S OWN ACCOUNT THEN DON'T DISPLAY ANY BUTTON, ALSO LINK TO PROFILE, AND ALSO ADD USERID FIELD TO AUTHMODEL
                            else {
                                // Unfollow button
                                Button(action: {
                                    self.followApiLoading = true
                                    
                                    Task {
                                        do {
                                            let followedUser = try await followUser(reqInput: userFollowServerInput(sessionToken: authModel.authToken!, userToFollowId: searchItem.userId))
                                            if followedUser {
                                                print("followed user success")
                                                searchItem.isFollowing = true
                                                
                                            }
                                            self.followApiLoading = false
                                        } catch {
                                            print("failed to follow user")
                                            print(error.localizedDescription)
                                            self.followApiLoading = false
                                        }
                                    }
                                    
                                    
                                    
                                }, label: {
                                    if followApiLoading {
                                        ProgressView()
                                    } else {
                                        Text("Follow")
                                            .padding(10)
                                            .background(.green)
                                            .cornerRadius(10)
                                            .font(.subheadline)
                                            .foregroundStyle(.black)
                                    }
                                })
                            }

                        }
                    }
                    .padding([.horizontal], 10)
                    
                    Divider()
                }
                
            }
            .padding(.horizontal)
            
        }
    }
}

#Preview {
    PeopleSearchResultView(searchResult: .constant(fakePeopleResult))
        .environment(AuthModel())
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
