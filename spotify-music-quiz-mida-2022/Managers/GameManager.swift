import Foundation
import SwiftUI

class GameManager: ObservableObject {
    static let shared = GameManager()
    let userManager = UserManager.shared
    
    private(set) var questions: [Question] = []
    private(set) var tempQuestions: [Question] = []
    private(set) var currentQuestion : Question?
    private(set) var currentAnswers : [String]?
    private(set) var gameIsOver = false
    private(set) var playerMiss = false
    private(set) var codeQuestion = ""
    @Published private(set) var isTimerRunning = true
    @Published private(set) var currentQuestionIndex = 0
    @Published private(set) var correctAnswersCount = 0
    @Published private(set) var answerSelected = false
    
    @State var userProfile : UserProfile?
    
    
    
    init() {}
    
    
    func startGame(codeQuestion: String) async throws {
        self.codeQuestion = codeQuestion
//        if(questions.count == 0 || correctAnswersCount != 0) {
        try await resetGame()
        QuestionManager.shared.isLoadingQuestions = true
        try await QuestionManager.shared.importAllData()
        try await self.genQuestions(codeQuestion: codeQuestion)
//        }
    }
    
    func genQuestions(codeQuestion: String) async throws {
        print("GEN QUESTION: QUESTION COUNT: \(questions.count) Answer Count: \(correctAnswersCount)")
        if(questions.count == 0 || correctAnswersCount != 0) {
//            tempQuestions = []
//            questions = []
            questions = try await QuestionManager.shared.genRandomQuestions(code: codeQuestion)
            print("Count \(questions.count)")
            questions.shuffle()
            DispatchQueue.main.async {
                self.currentQuestionIndex = 0
                //self.correctAnswersCount = 0 //is necessary?
                self.currentQuestion = self.questions[self.currentQuestionIndex]
                self.currentAnswers = self.currentQuestion?.getAnswers()
            }
        }
        
    }
    func restartGame(codeQuestion: String) async throws {
        self.codeQuestion = codeQuestion
        try await resetGame()
        QuestionManager.shared.isLoadingQuestions = true
        try await genQuestions(codeQuestion: codeQuestion)
    }
    
    func resetGame() async throws {
        
        print("Enter RESET GAME")
        self.questions = []
        DispatchQueue.main.async {
            self.gameIsOver = false
            self.playerMiss = false
            self.answerSelected = false
            self.correctAnswersCount = 0
        }
        print("Exit RESET GAME")
        print("RESET GAME: QUESTION COUNT: \(questions.count)")
    }
    
    func setNextQuestion() async throws {
        DispatchQueue.main.async {
            self.answerSelected = false
        }
        
        if (playerMiss) {
            gameOver()
        } else {
            
            // Only setting next question if index is smaller than the number of questions set
            print("Current question index : \(currentQuestionIndex), question.count: \(questions.count)")
            if currentQuestionIndex < questions.count - 1 {
                DispatchQueue.main.async {
                    self.currentQuestionIndex += 1
                    self.currentQuestion = self.questions[self.currentQuestionIndex]
                    self.currentAnswers = self.currentQuestion?.getAnswers() ?? [String]()
                }
                    if (currentQuestionIndex == (questions.count - 3))  {
                        print("CURRENT INDEX: \(currentQuestionIndex)")
                        tempQuestions = try await QuestionManager.shared.genRandomQuestions(code: self.codeQuestion)
                    }

            } else {
                print("Reload questions")
                DispatchQueue.main.async {
                    self.questions = []
                    self.questions = self.tempQuestions
                    self.tempQuestions = []
                    //questions = try await QuestionManager.shared.genRandomQuestions()
                    self.questions.shuffle()
                    self.currentQuestionIndex = 0
                    print("Questions.count: \(self.questions.count)")
                    //self.correctAnswersCount = 0 //is necessary?
                    self.currentQuestion = self.questions[self.currentQuestionIndex]
                    self.currentAnswers = self.currentQuestion?.getAnswers()
                }
            }
            
//            
        }
        
    }
    
    func getNextQuestion() -> Question? {
        print("Risposta esatta: \(currentQuestion?.correctAnswer)")
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
                try await userManager.addAuthor(artist: currentQuestion.author!, artistId: currentQuestion.authorId!)
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





