
//
//import SwiftUI
//import SwiftData
//
//
//struct DiaryTabv2: View {
//    @Environment(\.modelContext) private var reviewModelContext
//    
//    let userId = "name"
//    let mediaId = 12
//    let rating = 4
//    let watched = true
//    let liked = false
//    
//    @Query private var items: [CReview]
//    
//    
//    var body: some View {
//        Text("tap to add item")
//        
//        Button("add Item") {
//            addItem()
//        }
//        
//        List {
//            ForEach (items) { item in
//            
//                Text("\(item.id)")
//            }
//        }
//    }
//    
//    func addItem() {
//        let item = CReview(userId: "name")
//        
//        reviewModelContext.insert(item)  
//    }
//}
//
//#Preview {
//    DiaryTabv2()
//        .modelContainer(for: CReview.self)
//}
