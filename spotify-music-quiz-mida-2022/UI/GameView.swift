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
            VStack {
                Spacer()
                Text("Oh no!\n Your score is:\n \(gameManager.correctAnswersCount)")
                    .font(TextStyle.score())
                    .foregroundColor(Color("Green"))
                    .padding(.leading)
                Spacer()
                HStack {
                    NavigationLink {
                        HomeView()
                    } label: {
                        Text("Go back to the homepage")
                    }
                    NavigationLink {
                        GameView()
                    } label: {
                        Text("Play again!")
                    }
                }
            }
            .navigationBarHidden(true)
            .background(Color("Black"))
        } else {
            VStack(alignment: .leading, spacing: 30) {
                
                Spacer()
                Text("Score: \(gameManager.correctAnswersCount)")
                    .font(TextStyle.score())
                    .foregroundColor(Color(playerMiss ? "Red" : "Green"))
                    .padding(.leading)
                
                
                Text((gameManager.getNextQuestion()?.questionText)!)
                    .font(TextStyle.LoginTitle())
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .frame(width: 360.0, height: 60, alignment: .leading)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(.white)
                    .padding([.leading, .bottom])
                
                if(gameManager.getNextQuestion()!.isShazam){
                    if isShowingGuessView {
                        GuessTheSongView(userAnswer : $userAnswer, isShowingGuessView: $isShowingGuessView)
                            .onAppear {
                            AudioPlayer.shared.play(audioURL: URL(string: gameManager.getNextQuestion()!.songUrl!)!)
                                
                            }.onDisappear{
                                AudioPlayer.shared.stop()
                                
                            }
                    } else {
                        
                        //sicuramente da fixare e creare un'altra struttura per queste risposte
                        Answer(answer: userAnswer)
                        
                    }
                } else {
                    
                    ForEach(currentAnwers, id: \.self) { answer in
                        Answer(answer: answer)
                            .environmentObject(gameManager)
                    }
                }
                
                HStack {
                    Spacer()
                    TimeBar(duration: 10)
                        .environmentObject(gameManager)
                    Spacer()
                }
                .padding(.top, 32)
                
                GameControls()
                    .environmentObject(gameManager)
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
