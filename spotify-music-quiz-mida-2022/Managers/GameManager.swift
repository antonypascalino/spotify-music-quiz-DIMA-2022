import Foundation
import SwiftUI

class GameManager: ObservableObject {
    static let shared = GameManager()
    
    private(set) var questions: [Question2] = []
    private(set) var currentQuestion : Question2?
    private(set) var currentAnswers : [String]?
    private(set) var gameIsOver = false
    private(set) var playerMiss = false
    @Published private(set) var currentQuestionIndex = 0
    @Published private(set) var correctAnswersCount = 0
    @Published private(set) var answerSelected = false
    
    @State var userProfile : UserProfile?
    var topTracks : [Track] = []
    var artists : [Artist] = []
    var similarArtists : [Artist] = []
    var isLoading = true
    
    private let apiCaller = APICaller.shared
    
    init() {
        startGame()
    }
    
    
    func startGame() {
        questions = generateRandomQuestions()
        //questions.shuffle()
        currentQuestionIndex = 0
        correctAnswersCount = 0
        currentQuestion = questions[currentQuestionIndex]
        currentAnswers = currentQuestion?.getAnswers()
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
                //Generate more questions
            }
        }
        
    }
    
    func getNextQuestion() -> Question2? {
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
        } else {
            playerMiss = true
        }
    }
    
    
    
    
    func generateRandomQuestions() -> [Question2] {
        // Resetta l'array delle domande
        var questions2 : [Question2] = []
        
        // Genera domande di tipo "chi cantante canta questa canzone"
        let artistQuestions = generateArtistQuestions()
        questions2.append(contentsOf: artistQuestions)
        
        // Genera domande di tipo "in che anno è stato pubblicato quest'album"
        //let albumQuestions = generateAlbumQuestions()
        //questions.append(contentsOf: albumQuestions)
        
        // Genera domande di tipo "qual è l'anno di pubblicazione di questa canzone?"
        //let releaseYearQuestions = generateReleaseYearQuestions()
        //questions.append(contentsOf: releaseYearQuestions)
        
        // Randomizza l'ordine delle domande
        return questions2
    }
    
    private func generateArtistQuestions() -> [Question2] {
        var questions: [Question2] = []
        
        
        loadTopTracks()
        while(isLoading) {
            ProgressView()
        }
        isLoading = true
        
        for track in self.topTracks {
            
            let correctAnswer = track.artists.first!.name

            
            var similarArtistsNames : [String] = []
            
            
            loadArtistRelatedArtists(track: track)
            while(isLoading) {
                ProgressView()
            }
            isLoading = true
            
            for i in 0...2{
                similarArtistsNames.append(similarArtists[i].name)
            }
            
            let question = Question2(questionText: "Who sings the song \(track.name)?",
                                     correctAnswer: correctAnswer,
                                     wrongAnswers: similarArtistsNames)
            questions.append(question)
        }
        
        return questions
    }
    
    private func loadTopTracks(){
        
        apiCaller.getTopTracks { result in
            switch result{
                case .success(let model):
                    self.topTracks = model
                    self.isLoading = false
                    //print("TOP ARTISTS: \(model)")
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    //self?.failedToGetProfile()
            }
            
        }
    }
    
    private func loadArtistRelatedArtists(track : Track){
        apiCaller.getArtistRelatedArtists(for : track.artists.first!) {  result in
            switch result{
                case .success(let model):
                    self.similarArtists = model
                    self.isLoading = false
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    //self?.failedToGetProfile()
            }
        }
    }
    /*
    private func generateAlbumQuestions() -> [Question2] {
        var questions: [Question2] = []
        
        var savedAlbums : [Album] = []
        
        apiCaller.getUserAlbums {result in
            switch result{
                case .success(let model):
                    savedAlbums = model
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    //self?.failedToGetProfile()
            }
            
        }
        
        
        for album in savedAlbums {
            let correctAnswer = album.release_date
            
            let similarDates = generateRandomDates(originalYear: album.release_date, originalArtist : album.artists.first!)
            
            let question = Question2(questionText: "What year was the album \(album.name) released?",
                                     correctAnswer: correctAnswer,
                                     wrongAnswers: similarDates)
            questions.append(question)
        }
        
        return questions
    }*/
    /*
     private func generateReleaseYearQuestions() -> [Question2] {
     var questions: [Question2] = []
     
     var topTracks : [Track] = []
     
     apiCaller.getTopTracks {result in
     switch result{
     case .success(let model):
     topTracks = model
     break
     case .failure(let error):
     print(error.localizedDescription)
     //self?.failedToGetProfile()
     }
     
     }
     
     for track in topTracks {
     let correctAnswer = track.release_date
     
     let question = Question2(questionText: "What year was the song \(track.name) released?",
     correctAnswer: correctAnswer,
     wrongAnswers: [])
     questions.append(question)
     }
     
     return questions
     }
     
     func generateRandomDates(originalYear: String, originalArtist : Artist) -> [String] {
     var randomYears: [String] = []
     
     guard let originalYearInt = Int(originalYear) else {
     return randomYears
     }
     
     let randomYearFromSameArtist = getRandomYearFromSameArtist(originalYear: originalYearInt, originalArtist : originalArtist)
     randomYears.append(randomYearFromSameArtist)
     
     let randomYear2 = getRandomYearInRange(startYear: originalYearInt - 10, endYear: originalYearInt + 10)
     let randomYear3 = getRandomYearInRange(startYear: originalYearInt - 10, endYear: originalYearInt + 10)
     randomYears.append(String(randomYear2))
     randomYears.append(String(randomYear3))
     
     return randomYears
     }
     
     
     func getRandomYearFromSameArtist(originalYear: Int, originalArtist : Artist) -> String {
     
     var songsBySameArtist : [Track] = []
     
     apiCaller.getArtistTopTracks(for : originalArtist) {result in
     switch result{
     case .success(let model):
     songsBySameArtist = model
     break
     case .failure(let error):
     print(error.localizedDescription)
     //self?.failedToGetProfile()
     }
     
     }
     /*
      let filteredSongs = songsBySameArtist.filter { ($0.release_date).components(separatedBy: "-").first != String(originalYear) } //potrebbe non funzionare: in questo caso prendere la prima canzone e tramite apiCaller.getTrack(id) ricavarci l'anno
      */
     
     if let randomSong = filteredSongs.randomElement() {
     return randomSong.release_date.components(separatedBy: "-").first!
     }
     
     return String(getRandomYearInRange(startYear: originalYear - 10, endYear: originalYear + 10))
     }
     
     func getRandomYearInRange(startYear: Int, endYear: Int) -> Int {
     return Int.random(in: startYear...endYear)
     }
     
     
     }
     */
}

struct Question2 : Equatable {
    let id = UUID()
    let questionText: String?
    let correctAnswer: String
    let wrongAnswers: [String]
    
    func isCorrect(_ answer: String) -> Bool {
        return answer == correctAnswer
    }
    
    func getAnswers() -> [String] {
        var answers : [String] = []
        answers.append(correctAnswer)
        answers.append(contentsOf: wrongAnswers)
        answers.shuffle()
        
        return answers
    }
}



