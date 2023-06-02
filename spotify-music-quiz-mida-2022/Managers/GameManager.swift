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
    @Published private(set) var currentQuestionIndex = 0
    @Published private(set) var correctAnswersCount = 0
    @Published private(set) var answerSelected = false
    
    @State var userProfile : UserProfile?
    
    
    
    init() {}
    
    
    func startGame() {
        QuestionManager.shared.importAllData()
        self.genQuestions()
    }
    
    func genQuestions() {
        questions = QuestionManager.shared.genRandomQuestions()
        print("Count \(questions.count)")
        questions.shuffle()
        currentQuestionIndex = 0
        correctAnswersCount = 0
        currentQuestion = questions[currentQuestionIndex]
        currentAnswers = currentQuestion?.getAnswers()
    }
    func restartGame() {
        gameIsOver = false
        playerMiss = false
        answerSelected = false
        QuestionManager.shared.isLoadingQuestions = true
        genQuestions()
    }
    
    func setNextQuestion() {
        answerSelected = false
        
        if (playerMiss) {
            gameOver()
        } else {
            
            // Only setting next question if index is smaller than the number of questions set
            if currentQuestionIndex < questions.count {
                currentQuestionIndex += 1
                currentQuestion = questions[currentQuestionIndex]
                currentAnswers = currentQuestion?.getAnswers() ?? [String]()
            } else {
                questions = []
                questions = QuestionManager.shared.genRandomQuestions()
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





