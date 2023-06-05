import Foundation
import SwiftUI

class GameManager: ObservableObject {
    static let shared = GameManager()
    let userManager = UserManager.shared
    
    private(set) var questions: [Question] = []
    private(set) var currentQuestion : Question?
    
    private(set) var currentAnswers : [String]?
    private(set) var gameIsOver = false
    private(set) var playerMiss = false
    @Published private(set) var isTimerRunning = true
    
    @Published private(set) var currentQuestionIndex = 0
    @Published private(set) var correctAnswersCount = 0
    @Published private(set) var answerSelected = false
    
    @State var userProfile : UserProfile?
    
    
    
    init() {}
    
    
    func startGame() async throws {
        try await QuestionManager.shared.importAllData()
        try await self.genQuestions()
    }
    
    func genQuestions() async throws {
        questions = try await QuestionManager.shared.genRandomQuestions()
        print("Count \(questions.count)")
        questions.shuffle()
        DispatchQueue.main.async {
            self.currentQuestionIndex = 0
            self.correctAnswersCount = 0
            self.currentQuestion = self.questions[self.currentQuestionIndex]
            self.currentAnswers = self.currentQuestion?.getAnswers()
        }
    }
    func restartGame() async throws {
        try await endGame()
        try await genQuestions()
    }
    
    func endGame() async throws {
        DispatchQueue.main.async {
            self.gameIsOver = false
            self.playerMiss = false
            self.answerSelected = false
        }
        QuestionManager.shared.isLoadingQuestions = true
    }
    
    func setNextQuestion() async throws {
        DispatchQueue.main.async {
            self.answerSelected = false
        }
        
        if (playerMiss) {
            gameOver()
        } else {
            
            // Only setting next question if index is smaller than the number of questions set
            if currentQuestionIndex < questions.count {
                DispatchQueue.main.async {
                    self.currentQuestionIndex += 1
                    self.currentQuestion = self.questions[self.currentQuestionIndex]
                    self.currentAnswers = self.currentQuestion?.getAnswers() ?? [String]()
                }
                
            } else {
                DispatchQueue.main.async {
                    self.questions = []
                }
                questions = try await QuestionManager.shared.genRandomQuestions()
                questions.shuffle()
            }
            
//            if currentQuestionIndex == 20 {
//                questions.append(contentsOf: generateRandomQuestionsLv2())
//                questions.shuffle()
//            }
        }
        
    }
    
    func getNextQuestion() -> Question? {
        return currentQuestion
    }
    
    func gameOver() {
        gameIsOver = true
    }
    
    func selectAnswer(_ isCorrect : Bool) {
        
        answerSelected = true
        
        let currentQuestion = questions[currentQuestionIndex]
        if isCorrect {
            correctAnswersCount += 1
            Task {
                try await userManager.setUserAuthorScore(author: currentQuestion.author!)
            }
        } else {
            playerMiss = true
        }
    }
    
    func pauseTimer() {
        isTimerRunning = false
    }
        
    func resumeTimer() {
        isTimerRunning = true
    }
    

    

    
    
    
    
    
    
    
    
//    private func generateAlbumSongQuestions() -> [Question] {
//        var questions: [Question] = []
//        self.albums.shuffle()
//
//        for var album in self.albums {
//            album.tracks.items.shuffle()
//            let correctTrack = album.tracks.items.first!
//            let correctAnswer = correctTrack.name
//
//            self.reccTracks = []
//            loadRecc(track: correctTrack)
//            while(isLoading){
//                ProgressView()
//            }
//            isLoading = true
//
//            if !similarArtists.isEmpty{
//                for i in 0...2{
//                    similarArtistsNames.append(similarArtists[i].name)
//                }
//
//                let question = Question(questionText: "Who sings the song _\(filterString(track.name))_?",
//                                         correctAnswer: correctAnswer,
//                                         wrongAnswers: similarArtistsNames)
//                questions.append(question)
//            }
//
//
//        }
//
//            return questions
//
//
//
//    }

    
   
    
   
   
}





