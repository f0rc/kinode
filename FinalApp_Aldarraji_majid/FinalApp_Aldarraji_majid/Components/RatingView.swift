//
//  RatingView.swift
//  movieapp
//
//  Created by mops on 11/1/23.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var label = ""
    
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    var body: some View {
        
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
                    .font(.largeTitle)
            }
            
            Button(action: {
                rating = 0
            }, label: {
                Image(systemName: "x.circle")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
            })
            
        }
        
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
