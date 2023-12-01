
import Foundation


func getPosterIfTop(mediaItems: [top4MediaWithReview], index: Int, type: Int) -> String? {
    
    var propertyKey = ""
    var isTopKey = ""
    
    if type == 0 {
        propertyKey = "topShow"
        isTopKey = "topShow\(index - 1)"
    } else {
        propertyKey = "topMovie"
        isTopKey = "topMovie\(index - 1)"
    }
    
    let isTop = mediaItems.contains { item in
        let mirror = Mirror(reflecting: item)
        for child in mirror.children {
            if let key = child.label, key == isTopKey, let value = child.value as? Bool, value {
                return true
            }
        }
        return false
    }
    
    if isTop {
        if let posterPathAvil = mediaItems.first(where: { item in
            let mirror = Mirror(reflecting: item)
            for child in mirror.children {
                if let key = child.label, key == isTopKey, let value = child.value as? Bool, value {
                    return true
                }
            }
            return false
        }) {
            return posterPathAvil.media.posterPath
        }
    }
    
    return nil
}
