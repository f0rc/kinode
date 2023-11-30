//
//  DiaryTab.swift
//  movieapp
//
//  Created by  on 10/7/23.
//

import SwiftUI
import SwiftData

struct DiaryTab: View {
    @State var colors = [Color(.purple), Color(.black)]
    @Environment(AuthModel.self) private var authModel: AuthModel
    
    
    @Environment(\.modelContext) private var reviewModelContext
    @Query private var reviewFeed: [CReview]
    
    
    
    var body: some View {
        ZStack{
            if reviewFeed.count > 0 {
                List{
                    ForEach(reviewFeed, id: \.id) { re in
                            
                    }
                    
                }
            }
            else {
                
                VStack{
                    Image(systemName: "theatermasks.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 100)
                    
                    Text("No Reviews made yet please add one and it will be displayed here")
                        .padding()
                        .multilineTextAlignment(.center)
                        .bold()
                }
                
            }
            
            
        }
        .onAppear{
            if let authToken = authModel.authToken {
                Task {
                    do {
                        let res = try await loadReviewsApi(authToken: authToken)
                        
                        guard let apiReviewList = res else {
                            print("unable to get reviews from api")
                            return
                        }
                        
                        apiReviewList.forEach { rev in
                            reviewModelContext.insert(rev)
                            try? reviewModelContext.save()
                        }
                    }
                    catch {
                        print("failed to fetch reviews from api")
                    }
                }
            }
        }
    }
}


func reviewDescription(liked: Bool?, watched: Bool?, rating: Int?, mediaName: String, username: String) -> String {
    var description = username
    
    if liked != nil {
        description += "liked"
    }
    
    if watched != nil {
        description += " watched"
    }
    
    if rating != nil {
        description += " and rated"
    }
    
    description += " \(mediaName)"
    
    return description
}

#Preview {
    DiaryTab()
        .environment(AuthModel())
}
