//
//  TimeBar.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 24/03/23.
//

import SwiftUI

struct TimeBar: View {
    
    @State var duration: Double
    @State private var currentIteration = 0
    @State private var progress: CGFloat = 0
    
    
    @EnvironmentObject var gameManager : GameManager
    
    var body: some View {
        
        let currentSecond = Int(duration * progress)
        let missingSeconds = Int(duration) - currentSecond
        
//        var currentQuestion = gameManager.currentQuestion!

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
                }
            }
            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 600 : 355, height: 3)
            .padding(.bottom, 3)
            ///TODO:  To call ony one time
            .onAppear {
                startTimer()
            }
            .onChange(of: gameManager.currentQuestion) { newValue in
                startTimer()
            }
            
            //Timer to show in both sides of the bar
            HStack {
                if (currentSecond < 10) {
                    Text("0:0\(String(currentSecond))")
                        .foregroundColor(.gray)
                        .font(TextStyle.time())
                        .padding(.leading, 16.0)
                }
                else {
                    
                    Text("0:\(String(currentSecond))")
                        .foregroundColor(.gray)
                        .font(TextStyle.time())
                        .padding(.leading, 16.0)
                }
                Spacer()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 525 : 280)
                if (missingSeconds < 10) {
                    Text("-0:0\(String(missingSeconds))")
                        .foregroundColor(.gray)
                        .font(TextStyle.time())
                        .padding(.trailing, 16.0)
                }
                else {
                    
                    Text("-0:\(String(missingSeconds))")
                        .foregroundColor(.gray)
                        .font(TextStyle.time())
                        .padding(.trailing, 16.0)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func startTimer() {
        
        let iterations = Int(duration / 0.01)
        progress = 0
        currentIteration = 0
        duration = Double(gameManager.currentQuestion!.isShazam ? 25 : 10)
        print("DURATION: \(duration)")
        
        Timer.scheduledTimer(withTimeInterval: duration/Double(iterations), repeats: true) { timer in
            if gameManager.answerSelected {
                timer.invalidate()
            } else {
                if currentIteration >= iterations {
                    timer.invalidate()
                    gameManager.selectAnswer(false)
                } else {
                    if gameManager.isTimerRunning {
                        self.progress += 1/CGFloat(iterations)
                        currentIteration += 1
                    }
                }
            }
        }
    }
}

struct TimeBar_Previews: PreviewProvider {
    
    static var previews: some View {
        TimeBar(duration: 10)
            .environmentObject(GameManager())
            .frame(height: 60.0)
            .background(Color("Black")) 
    }
}
