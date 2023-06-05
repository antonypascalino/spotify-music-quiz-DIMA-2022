//
//  Loading.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 30/05/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var animating = false
    @State private var isMovingRight = false
    
    var body: some View {
        VStack(spacing: 100) {
            Image("Icon")
                .resizable()
                .foregroundColor(Color("Green"))
                .frame(width: 120, height: 120)
                .scaledToFit()
                .scaleEffect(animating ? 1.5 : 1)
            ZStack {
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.6)
                    .opacity(0.5)
                    .frame(width: 300, height: 10)
                    .cornerRadius(50)
                
                Rectangle()
                    .cornerRadius(50)
                    .foregroundColor(Color("Green"))
                    .frame(width: 60, height: 10)
                    .offset(x: isMovingRight ? 125 : -125)
//                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(), value: isMovingRight)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever()) {
                            isMovingRight.toggle()
                        }
                    }
                
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever()) {
                animating.toggle()
            }
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Black"))
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}


