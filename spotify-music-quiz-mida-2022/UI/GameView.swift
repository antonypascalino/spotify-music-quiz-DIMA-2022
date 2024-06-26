//
//  GameView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 17/03/23.
//

import SwiftUI
import AVFoundation

struct GameView: View {
    
    let mode : Mode
    let userManager : UserManager!
    @EnvironmentObject var gameManager : GameManager
    @EnvironmentObject var questionManager : QuestionManager
    @State private var isShowingGuessView = true
    @State private var userAnswer = ""
    @State private var isLoading = true
    @State private var showAlert = false
    
    var body: some View {
        
        let playerMiss = gameManager.playerMiss
        let gameIsOver = gameManager.gameIsOver
        VStack {
            if questionManager.isLoadingQuestions {
                LoadingView()
            } else if gameIsOver {
                GameOverView(userManager: userManager, mode: mode)
                    .environmentObject(gameManager)
                    .environmentObject(questionManager)
            } else {
                let currentAnwers = gameManager.currentAnswers!
                
                ZStack {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        Spacer()
                        Text("Score: \(gameManager.correctAnswersCount)")
                            .font(TextStyle.score(50))
                            .foregroundColor(Color(playerMiss ? "Red" : "Green"))
                            .padding(.leading)
                        
                        Text(.init((gameManager.getNextQuestion()?.questionText)!))
                            .font(TextStyle.LoginTitle())
                            .lineLimit(gameManager.getNextQuestion()!.isShazam ? 1 : 3)
                            .frame(height: 60, alignment: .leading)
                            .minimumScaleFactor(0.1)
                            .foregroundColor(.white)
                            .padding(.leading)
                            .blur(radius: gameManager.isTimerRunning ? 0 : 10)
                        
                        if(gameManager.getNextQuestion()!.isShazam){
                            
                            GuessTheSongView(correctAnswer: gameManager.currentQuestion!.correctAnswer)
                                .environmentObject(gameManager)
                                .frame(height: 380)
                        } else {
                            HStack {
                                Spacer()
                                VStack {
                                    ForEach(currentAnwers, id: \.self) { answer in
                                        Answer(answer: answer)
                                            .environmentObject(gameManager)
                                    }
                                    .padding([.top, .bottom] , 12)
                                    .padding(.leading , 5)
                                }
                                .frame(height: 380)
                                .frame(height: 380)
                                .offset(y: -18)
                                .blur(radius: gameManager.isTimerRunning ? 0 : 10)
                                Spacer()
                            }
                        }
                        
                        VStack {
                            TimeBar(duration: gameManager.currentQuestion!.isShazam ? 25 : 10)
                                .environmentObject(gameManager)
                            GameControls(userManager: userManager, showAlert: $showAlert)
                                .environmentObject(gameManager)
                        }
                        .offset(y: -33)
                        Spacer()
                    }
                    .background(Color("Black"))
                    .onAppear {
                        print("onAppear")
                        AudioPlayer.shared.play(audioURL: URL(string: gameManager.getNextQuestion()!.songUrl!)!)
                    }
                    .onChange(of: gameManager.getNextQuestion()!.songUrl!) { newValue in
                        AudioPlayer.shared.play(audioURL: URL(string: gameManager.getNextQuestion()!.songUrl!)!)
                    }
                    .onChange(of: gameManager.isTimerRunning) { newValue in
                        if newValue == false {
                            AudioPlayer.shared.pause()
                        } else {
                            AudioPlayer.shared.resume()
                        }
                    }
                    
                    if (showAlert) {
                        CustomAlert(userManager: userManager, showAlert: $showAlert)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
    }   
}



class AudioPlayer: ObservableObject {
    static let shared = AudioPlayer()
    
    private var player: AVPlayer?
    private var playerLooper: AVPlayerLooper?
    
    func play(audioURL: URL) {
        let playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)

//        playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)

        player?.play()
    }
    
    func stop() {
//        player?.setVolume(0, fadeDuration: 2.0) // Sfuma il volume a zero in 2 secondi
        player?.pause()
        player = nil
        playerLooper = nil
    }
    
    func pause() {
        player?.pause()
    }
    
    func resume() {
        player?.play()
    }
}

//
//struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameView()
//            .environmentObject(GameManager())
//    }
//}
