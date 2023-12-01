

import SwiftUI

struct AddTop4Sheet: View {
    // if 0 then shows its if 1 then movies
    var typeOfTop: Int = 0
    var index: Int = 0
    var mediaId: String = ""
    @State var mediaLista: [reviewWithMedia] = []
    
    
    @Environment(AuthModel.self) private var auth
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack(alignment: .leading){
                    Text("Add your top 4 \(typeOfTop == 0 ? "show" : "movie")")
                        .foregroundStyle(Color("text"))
                        .font(.title)
                        .bold()
                    
                    
                    List {
                        if mediaLista.count > 0 {
                            ForEach(mediaLista
                                .filter {
                                    if typeOfTop == 0 {
                                        return $0.media.mediaType == "tv"
                                    }else {
                                        return $0.media.mediaType == "movie"
                                    }
                                }
                                .sorted { (item1, item2) -> Bool in
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                    let date1 = dateFormatter.date(from: item1.createdAt)
                                    let date2 = dateFormatter.date(from: item2.createdAt)
                                    
                                    
                                    guard let time1 = date1?.timeIntervalSince1970 else {
                                        return true
                                    }
                                    
                                    guard let time2 = date2?.timeIntervalSince1970 else {
                                        return true
                                    }
                                    
                                    return time1 > time2
                                }, id: \.id) { medi in
                                    HStack{
                                        AsyncImage(url: URL(string: tmdbImage(imagePath: medi.media.posterPath ?? "").fullPath)){img in
                                            img
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                            
                                        } placeholder: {
                                            Image("DefaultPoster")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        }
                                        .frame(width: 100, height: 130)
                                        .cornerRadius(20)
                                        Text("\((medi.media.name ?? medi.media.title) ?? "NONAME")")
                                    }
                                    .foregroundStyle(.text)
                                    .listRowBackground(Color.clear)
                                    .onTapGesture {
                                        Task {
                                            do {
                                                if let token = auth.authToken {
                                                    try await addTop4(sesstionToken: token, mediaId: medi.mediaId, top4Index: index)
                                                    presentationMode.wrappedValue.dismiss()
                                                }
                                                
                                            }
                                            catch {
                                                print("UN ABLE TO ADD TO TOP 4")
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                        }
                                    }
                                    
                                }
                        } else {
                            Text("Review more \(typeOfTop == 0 ? "shows" : "movies")")
                                .foregroundStyle(.text)
                                .listRowBackground(Color.clear)
                            
                        }
                    }
                    
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    
                    
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("onbg"))
        }
        .onAppear {
            Task{
                do {
                    if let token = auth.authToken {
                        try await fetchTop4List(sesstionToken: token)
                    }
                }
                catch {
                    print("unable to fetch top 4 in sheet")
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
        
        let response: top4FetchResponseType = try await httpClient.load(Resource(url: URL.top4Fetch, method: .post(jsonDataInput)))
        
        if response.status != "success" {
            print("SERVER ERROR: \(response.message ?? "NO MESSAGE")")
            throw GetReviewsApiErro.failedToFetch
        }
        
        mediaLista = response.reviews
    }
    
    func addTop4(sesstionToken: String, mediaId: Int, top4Index: Int) async throws {
        struct serverInput: Codable {
            let sessionToken: String
            let mediaId: Int
            let top4Index: Int
        }
        
        let httpClient = StoreHTTPClient()
        
        let jsonDataInput = try JSONEncoder().encode(serverInput(sessionToken: sesstionToken, mediaId: mediaId, top4Index: top4Index))
        
        let response: addTop4ResponseType = try await httpClient.load(Resource(url: URL.top4Review, method: .post(jsonDataInput)))
        
        if response.status != "success" {
            print("SERVER ERROR: \(response.message ?? "NO MESSAGE")")
            throw GetReviewsApiErro.failedToFetch
        }
    }
}


struct reviewWithMedia: Codable {
    var id: String
    var userId: String
    var mediaId: Int
    var rating: Int
    var watched: Bool
    var liked: Bool
    var content: String?
    var createdAt: String
    var media: Media
}

struct top4FetchResponseType: Codable {
    let status: String
    let message: String?
    let reviews: [reviewWithMedia]
}

struct addTop4ResponseType: Codable {
    let status: String
    let message: String?
    let review: reviewWithMedia
}





#Preview {
    AddTop4Sheet()
        .environment(AuthModel())
}
