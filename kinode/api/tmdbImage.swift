//
//  tmdbImage.swift
//  movieapp
//
//  Created by  on 11/1/23.
//

import Foundation


struct tmdbImage{
    let baseURL = "https://image.tmdb.org/t/p/w500"
    let imagePath: String
    var fullPath: String {
        return baseURL + imagePath
    }
    
    let defaultImage = "https://www.themoviedb.org/assets/2/v4/glyphicons/basic/glyphicons-basic-38-picture-grey-c2ebdbb057f2a7614185931650f8cee23fa137b93812ccb132b9df511df1cfac.svg"
}


func getImgUrl(imgPath: tmdbImage) -> String{

    if imgPath.imagePath == "NOT" {
        return imgPath.defaultImage
    }else{
        return imgPath.fullPath
    }
}
