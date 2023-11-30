//
//  Top4Utils.swift
//  kinode
//
//  Created by  on 11/30/23.
//

import Foundation


func getPosterIfTop(mediaItems: [top4MediaWithReview], index: Int, type: Int) -> String? {
    
    
    if type == 0 {
        if index == 0 {
            let isTop = mediaItems.contains(where: { t in
                t.topShow0
            })
            
            if isTop == true {
                if let posterPathAvil = mediaItems.first(where: { t in
                    t.topShow0
                }){
                    return posterPathAvil.media.posterPath
                }
            }
        } 
        else if index == 1 {
            let isTop = mediaItems.contains(where: { t in
                t.topShow1
            })
            
            if isTop == true {
                if let posterPathAvil = mediaItems.first(where: { t in
                    t.topShow1
                }){
                    return posterPathAvil.media.posterPath
                }
            }
        }
        
        else if index == 2 {
            let isTop = mediaItems.contains(where: { t in
                t.topShow2
            })
            
            if isTop == true {
                if let posterPathAvil = mediaItems.first(where: { t in
                    t.topShow2
                }){
                    return posterPathAvil.media.posterPath
                }
            }
        }
        else if index == 3 {
            let isTop = mediaItems.contains(where: { t in
                t.topShow3
            })
            
            if isTop == true {
                if let posterPathAvil = mediaItems.first(where: { t in
                    t.topShow3
                }){
                    return posterPathAvil.media.posterPath
                }
            }
        }
    }else {
        if index == 0 {
            let isTop = mediaItems.contains(where: { t in
                t.topMovie0
            })
            
            if isTop == true {
                if let posterPathAvil = mediaItems.first(where: { t in
                    t.topMovie0
                }){
                    return posterPathAvil.media.posterPath
                }
            }
        }
        else if index == 1 {
            let isTop = mediaItems.contains(where: { t in
                t.topMovie1
            })
            
            if isTop == true {
                if let posterPathAvil = mediaItems.first(where: { t in
                    t.topMovie1
                }){
                    return posterPathAvil.media.posterPath
                }
            }
        }
        if index == 2 {
            let isTop = mediaItems.contains(where: { t in
                t.topMovie2
            })
            
            if isTop == true {
                if let posterPathAvil = mediaItems.first(where: { t in
                    t.topMovie2
                }){
                    return posterPathAvil.media.posterPath
                }
            }
        }
        if index == 3 {
            let isTop = mediaItems.contains(where: { t in
                t.topMovie3
            })
            
            if isTop == true {
                if let posterPathAvil = mediaItems.first(where: { t in
                    t.topMovie3
                }){
                    return posterPathAvil.media.posterPath
                }
            }
        }
    }
    
//    print("nothing works return nil indes: \(index) , type: \(type)")
    
    
    return nil
}
