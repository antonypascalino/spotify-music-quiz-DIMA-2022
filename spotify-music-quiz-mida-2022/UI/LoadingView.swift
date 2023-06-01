//
//  Loading.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 30/05/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black
            
            ForEach(0..<6) { index in
                Rectangle()
                    .frame(width: 4, height: 20)
                    .foregroundColor(.white)
                    .cornerRadius(2)
                    .scaleEffect(isAnimating ? 1 : 0.3, anchor: .bottom)
                    .offset(y: isAnimating ? -10 : 0)
                    .rotationEffect(.degrees(Double(index) * 60))
                    .animation(Animation.timingCurve(0.5, 0.15 + Double(index) * 0.1, 0.25, 1, duration: 1.2).repeatForever(autoreverses: false))
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

