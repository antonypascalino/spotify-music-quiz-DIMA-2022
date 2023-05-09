//
//  TimeBar.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 24/03/23.
//

import SwiftUI

struct TimeBar: View {
    
    let duration: Double
    @State private var progress: CGFloat = 0
    
    var body: some View {
        
        let currentSecond = Int(duration * progress)
        let missingSeconds = Int(duration) - currentSecond
        
        
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color.gray)
                        .cornerRadius(100)
                        .opacity(0.6)
                    Rectangle()
                        .foregroundColor(Color.white)
                        .frame(width: geometry.size.width * progress, height: 4)
                        .cornerRadius(100)
                    //.animation(.linear)
                }
            }
            .frame(width: 355, height: 3)
            .padding(.bottom, 3)
            .onAppear {
                let iterations = Int(duration / 0.05)
                var currentIteration = 0
                
                Timer.scheduledTimer(withTimeInterval: duration/Double(iterations), repeats: true) { timer in
                    if currentIteration >= iterations {
                        timer.invalidate()
                    } else {
                        self.progress += 1/CGFloat(iterations)
                        currentIteration += 1
                    }
                }
            }
            
            HStack {
                if (currentSecond < 10) {
                    Text("0:0\(String(currentSecond))")
                        .foregroundColor(.gray)
                        .font(TextStyle.time())
                        .padding(.leading, 8.5)
                }
                else {
                    
                    Text("0:\(String(currentSecond))")
                        .foregroundColor(.gray)
                        .font(TextStyle.time())
                        .padding(.leading, 8.5)
                }
                Spacer()
                if (missingSeconds < 10) {
                    Text("-0:0\(String(missingSeconds))")
                        .foregroundColor(.gray)
                        .font(TextStyle.time())
                        .padding(.trailing, 8.5)
                }
                else {
                    
                    Text("-0:\(String(missingSeconds))")
                        .foregroundColor(.gray)
                        .font(TextStyle.time())
                        .padding(.trailing, 8.5)
                }
            }
        }
        
    }
}

struct TimeBar_Previews: PreviewProvider {
    
    static var previews: some View {
        TimeBar(duration: 10)
            .frame(height: 60.0)
            .background(Color("Black"))
    }
}