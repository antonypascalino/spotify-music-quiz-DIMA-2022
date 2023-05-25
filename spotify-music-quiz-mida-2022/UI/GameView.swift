//
//  GameView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 17/03/23.
//

import SwiftUI
import AVFoundation

struct GameView: View {
    
    @StateObject var gameManager = GameManager()
    @State private var isShowingGuessView = true
    @State private var userAnswer = ""
    
    var body: some View {
        
        let currentAnwers = gameManager.currentAnswers!
        let currentQuestion = gameManager.getNextQuestion()!
        let playerMiss = gameManager.playerMiss
        let gameIsOver = gameManager.gameIsOver
        
        
        if gameIsOver {
            GameOverView(score: gameManager.correctAnswersCount)
        } else {
            VStack(alignment: .leading, spacing: 30) {
                
                Spacer()
                Text("Score: \(gameManager.correctAnswersCount)")
                    .font(TextStyle.score(50))
                    .foregroundColor(Color(playerMiss ? "Red" : "Green"))
                    .padding(.leading)
                
                Text(.init((gameManager.getNextQuestion()?.questionText)!))
                    .font(TextStyle.LoginTitle())
                    .lineLimit(3)
                    .frame(width: 360.0, height: 60, alignment: .leading)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                if(gameManager.getNextQuestion()!.isShazam){
                    
                    GuessTheSongView(correctAnswer: gameManager.currentQuestion!.correctAnswer)
                        .environmentObject(gameManager)
                        .onAppear {
                            AudioPlayer.shared.play(audioURL: URL(string: gameManager.getNextQuestion()!.songUrl!)!)
                        }
                        .onChange(of: gameManager.getNextQuestion()!.songUrl!) { newValue in
                            AudioPlayer.shared.play(audioURL: URL(string: gameManager.getNextQuestion()!.songUrl!)!)
                        }
                        .onDisappear {
                            AudioPlayer.shared.stop()
                        }
                        .frame(height: 380)
                } else {
                    VStack {
                        ForEach(currentAnwers, id: \.self) { answer in
                            Answer(answer: answer)
                                .environmentObject(gameManager)
                        }
                        .padding([.top, .bottom] , 12)
                        .padding(.leading , 5)
                    }
                    .frame(height: 380)
                    .offset(y: -18)
                }
                
                VStack {
                    TimeBar(duration: gameManager.currentQuestion!.isShazam ? 25 : 10)
                        .environmentObject(gameManager)
                    GameControls()
                        .environmentObject(gameManager)
                }
                .offset(y: -33)
                Spacer()
                
                
            }
            .background(Color("Black"))
            .navigationBarHidden(true)
        }
    }
}



class AudioPlayer: ObservableObject {
    static let shared = AudioPlayer()
    
    private var player: AVPlayer?
    
    func play(audioURL: URL) {
        let playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
    
    func stop() {
        player?.pause()
        player = nil
        
        //stop dopo tot secondi
//        player.addBoundaryTimeObserver(forTimes: [NSValue(time: CMTime(seconds: duration, preferredTimescale: 1))], queue: .main) {
//            playerViewController.player?.pause()
//        }
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
