//
//  ProfileTab.swift
//  movieapp
//
//  Created by  on 10/7/23.
//

import SwiftUI
import SwiftData


struct ActiveItem : Identifiable {
    var typeOfMedia: Int
    var id: Int
}

struct ProfileTab: View {
    @Environment(AuthModel.self) private var auth
    
    @State private var toggleSettings: Bool = false
    @State private var activeItemTop4: ActiveItem?
    
    @State var profileVM: ProfileModelController
    
    @State var topMedia: [top4MediaWithReview] = []
    
    init(sessionToken: String) {
        self.profileVM = ProfileModelController(sessionToken: sessionToken)
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    VStack{
                        Image("DefaultAvi")
                            .clipShape(Circle())
                            .frame(width: 82, height: 82)
                            .padding()
                        
                        // display name
                        Text(profileVM.user.name)
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("@\(profileVM.user.username)")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                        
                        
                        HStack{
                            VStack{
                                Text("\(profileVM.user.followers)")
                                    .font(.title)
                                Text("Followers")
                                    .font(.footnote)
                            }
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("\(profileVM.user.following)")
                                    .font(.title)
                                Text("Following")
                                    .font(.footnote)
                            }
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("\(profileVM.user.moviesCount)")
                                    .font(.title)
                                Text("Movies")
                                    .font(.footnote)
                            }
                            
                            Spacer()
                            Divider()
                            Spacer()
                            VStack{
                                Text("\(profileVM.user.showsCount)")
                                    .font(.title)
                                Text("Shows")
                                    .font(.footnote)
                            }
                            
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8, maxHeight: 100)
                        
                        Divider()
                            .padding()
                        
                        VStack(alignment: .leading){
                            Text("Top 4 Shows")
                                .font(.title2)
                            VStack{
                                HStack{
                                    if let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: 0, type: 0){
                                        getButton(0, type: 0, imageName: topMediaPoster)
                                    }else {
                                        getButton(0, type: 0)
                                    }
                                    
                                    if let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: 1, type: 0){
                                        getButton(1, type: 0, imageName: topMediaPoster)
                                    }else {
                                        getButton(1, type: 0)
                                    }
                                    
                                    if let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: 2, type: 0){
                                        getButton(2, type: 0, imageName: topMediaPoster)
                                    }else {
                                        getButton(2, type: 0)
                                    }
                                    
                                    if let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: 3, type: 0){
                                        getButton(3, type: 0, imageName: topMediaPoster)
                                    }else {
                                        getButton(3, type: 0)
                                    }
                                }
                                
                            }
                        }
                        
                        VStack(alignment: .leading){
                            
                            Text("Top 4 Movies")
                                .font(.title2)
                            VStack{
                                HStack{
                                    if let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: 0, type: 1){
                                        getButton(0, type: 1, imageName: topMediaPoster)
                                    }else {
                                        getButton(0, type: 1)
                                    }
                                    
                                    if let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: 1, type: 1){
                                        getButton(1, type: 1, imageName: topMediaPoster)
                                    }else {
                                        getButton(1, type: 1)
                                    }
                                    
                                    if let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: 2, type: 1){
                                        getButton(2, type: 1, imageName: topMediaPoster)
                                    }else {
                                        getButton(2, type: 1)
                                    }
                                    
                                    if let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: 3, type: 1){
                                        getButton(3, type: 1, imageName: topMediaPoster)
                                    }else {
                                        getButton(3, type: 1)
                                    }
                                }
                            }
                        }
                        
                        
                        //TODO: list of recently watched with selector
                        
                    }
                    
                    
                }
                .toolbar {
                    Button(action: {
                        toggleSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .foregroundStyle(Color("accentC"))
                            .font(.title2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("backgroundColor"))
                .sheet(isPresented: $toggleSettings){
                    SettingsSheet(userProfileInfo: $profileVM.user, userModel: $profileVM)
                        .presentationDetents([.large])
                        .presentationBackground(.yellow)
                        .presentationDragIndicator(.visible)
                }
                
                .sheet(item: $activeItemTop4, onDismiss: {
                    if let authTok = auth.authToken {
                        Task {
                            try await fetchTop4List(sesstionToken: authTok)
                        }
                    }
                }) {item in
                    AddTop4Sheet(typeOfTop: item.typeOfMedia, index: item.id)
                        .presentationDragIndicator(.visible)
                        
                }
                
            }
        }
        .onAppear {
            if let authTok = auth.authToken {
                self.profileVM = ProfileModelController(sessionToken: authTok)
                
                Task {
                    try await fetchTop4List(sesstionToken: authTok)
                }
            }
        }
    }
    
    func getButton(_ i: Int, type: Int, imageName: String? = nil) -> some View {
        return Button(action: {
            print("\(i), type: \(type)")
            activeItemTop4 = ActiveItem(typeOfMedia: type, id: i)
        },
                      label: {
            if imageName != nil {
                
                AsyncImage(url: URL(string: tmdbImage(imagePath: imageName ?? "").fullPath)){img in
                    img.resizable()
                } placeholder: {
                    Image("DefaultPoster")
                        .resizable()
                }
                .frame(width: 80, height: 150)
                
            } else {
                Image(systemName: "plus")
                    .frame(width: 80, height: 150)
                    .background(.gray)
                    .foregroundStyle(Color("text"))
            }
        })
    }
    
    func fetchTop4List(sesstionToken: String) async throws {
        struct serverInput: Codable {
            let sessionToken: String
        }
        
        let httpClient = StoreHTTPClient()
        
        let jsonDataInput = try JSONEncoder().encode(serverInput(sessionToken: sesstionToken))
        
        let response: top4MediaResponseType = try await httpClient.load(Resource(url: URL.top4Fetch, method: .post(jsonDataInput)))
        
        if response.status != "success" {
            print("SERVER ERROR: \(response.message ?? "NO MESSAGE")")
            throw GetReviewsApiErro.failedToFetch
        }
        
        topMedia = response.reviews
    }
    
    
}



#Preview {
    ProfileTab(sessionToken: "1234")
        .environment(AuthModel())
    
}



struct top4MediaWithReview: Codable {
    var id: String
    var userId: String
    var mediaId: Int
    var rating: Int
    var watched: Bool
    var liked: Bool
    var content: String?
    var createdAt: String
    var topMovie0: Bool
    var topMovie1: Bool
    var topMovie2: Bool
    var topMovie3: Bool
    
    var topShow0: Bool
    var topShow1: Bool
    var topShow2: Bool
    var topShow3: Bool

    var media: Media
}

struct top4MediaResponseType: Codable {
    let status: String
    let message: String?
    let reviews: [top4MediaWithReview]
}
