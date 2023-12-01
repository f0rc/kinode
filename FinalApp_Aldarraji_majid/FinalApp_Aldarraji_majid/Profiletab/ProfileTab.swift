//
//  ProfileTab.swift
//  movieapp
//
//  Created by mops on 10/7/23.
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
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 200, height: 200)
                                
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
                        
                        VStack(alignment: .leading) {
                            Text("Top 4 Movies")
                                .font(.title2)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(1..<5, id: \.self) { index in
                                        let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: index, type: 0)
                                        if let poster = topMediaPoster {
                                            getButton(index, type: 0, imageName: poster)
                                                .frame(width: 100, height: 150)
                                            
                                        } else {
                                            getButton(index, type: 0)
                                                .frame(width: 100, height: 150)
                                            
                                            
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Top 4 Movies")
                                .font(.title2)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(1..<5, id: \.self) { index in
                                        let topMediaPoster = getPosterIfTop(mediaItems: topMedia, index: index, type: 1)
                                        if let poster = topMediaPoster {
                                            getButton(index, type: 1, imageName: poster)
                                                .frame(width: 100, height: 150)
                                            
                                        } else {
                                            getButton(index, type: 1)
                                                .frame(width: 100, height: 150)
                                            
                                            
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        .padding(.horizontal)
                        
                        
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
                        .presentationBackground(Color("onbg"))
                        
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
        return GeometryReader { geometry in
            Button(action: {
                print("\(i), type: \(type)")
                activeItemTop4 = ActiveItem(typeOfMedia: type, id: i)
            }) {
                if let imageName = imageName {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                        AsyncImage(url: URL(string: tmdbImage(imagePath: imageName).fullPath)) { img in
                            img
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                
                        } placeholder: {
                            Image("DefaultPoster")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    .frame(width: 100, height: 150)
                } else {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                        Image(systemName: "plus")
                            .foregroundColor(Color("text"))
                    }
                    .frame(width: 100, height: 150)
                        
                }
            }
        }
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
