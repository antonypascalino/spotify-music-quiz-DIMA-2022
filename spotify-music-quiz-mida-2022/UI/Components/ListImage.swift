//
//  ListImage.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/05/23.
//

import SwiftUI

struct ListImage: View {
    
    var imageString : String
    
    var body: some View {
         
        if (imageString != "") {
            AsyncImage(url: URL(string: imageString)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
            }
        }
        else {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
        }
    }
}

struct ImageToLoad_Previews: PreviewProvider {
    static var previews: some View {
        ListImage(imageString: "")
            .background(.black)
    }
}
