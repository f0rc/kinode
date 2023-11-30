//
//  FormInput.swift
//  movieapp
//
//  Created by  on 10/10/23.
//

import SwiftUI

struct FormInput: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(Color.text))
                .fontWeight(.semibold)
                .font(.footnote)
            
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(Color(Color.text))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
                    .foregroundColor(Color(Color.text))
            }
            
            Divider()
        }
    }
}

#Preview {
    FormInput(text: .constant(""), title: "test title", placeholder: "test placeholder")
}
