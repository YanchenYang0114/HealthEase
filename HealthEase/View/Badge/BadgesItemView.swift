//
//  BadgesItemView.swift
//
//  Created by Yang on on 11/3/2025.
//

import SwiftUI

struct BadgesItemView: View {
    var imageName = "icon_perfect"
    var title = "Perfect Month"
    var body: some View {
        
        
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 102)
                
            Text(title)
                .font(Font.system(size: 17, weight: .medium))
        }
    }
}

#Preview {
    BadgesItemView()
}
