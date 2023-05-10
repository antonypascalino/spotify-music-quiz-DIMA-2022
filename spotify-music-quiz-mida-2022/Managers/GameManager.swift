import Foundation
import SwiftUI

class GameManager: ObservableObject {
    static let shared = GameManager()
    
    @Published var questions: [Question2] = []
    @Published var currentQuestionIndex = 0
    @Published var correctAnswersCount = 0
    @State var userProfile : UserProfile?

    private let apiCaller = APICaller.shared 
    
    private init() {}
    
    func startGame() { 
        
        generateRandomQuestions()

        currentQuestionIndex = 0
        correctAnswersCount = 0
        

    }
    
    func getNextQuestion() -> Question2? {
        guard currentQuestionIndex < questions.count else {
            return nil
        }
        let question = questions[currentQuestionIndex]
        currentQuestionIndex += 1
        return question
    }
    
    func handleAnswer(_ answer: String) {
        let currentQuestion = questions[currentQuestionIndex - 1]
        if currentQuestion.isCorrect(answer) {
            correctAnswersCount += 1
        }
    }
    
   
    

    func generateRandomQuestions() {
        // Resetta l'array delle domande
        questions = []

        // Genera domande di tipo "chi cantante canta questa canzone"
        let artistQuestions = generateArtistQuestions()
        questions.append(contentsOf: artistQuestions)

        // Genera domande di tipo "in che anno è stato pubblicato quest'album"
        let albumQuestions = generateAlbumQuestions()
        questions.append(contentsOf: albumQuestions)

        // Genera domande di tipo "qual è l'anno di pubblicazione di questa canzone?"
        let releaseYearQuestions = generateReleaseYearQuestions()
        questions.append(contentsOf: releaseYearQuestions)

        // Randomizza l'ordine delle domande
        questions.shuffle()
    }

    private func generateArtistQuestions() -> [Question2] {
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

            let correctAnswer = track.artists.first!.name

            var similarArtists : [Artist] = []
            var similarArtistsNames : [String] = []
        
            apiCaller.getArtistRelatedArtists(for : track.artists.first!) {result in
                    switch result{
                        case .success(let model):
                            similarArtists = model
                            break
                        case .failure(let error):
                            print(error.localizedDescription)
                            //self?.failedToGetProfile()
                    }  
                }
            for artist in similarArtists {
                similarArtistsNames.append(artist.name)
            }
            

            let question = Question2(questionText: "Who sings the song \(track.name)?",
                                    correctAnswer: correctAnswer,
                                    wrongAnswers: similarArtistsNames)
            questions.append(question)
        }

        return questions
    }

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
    }

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
    
    let filteredSongs = songsBySameArtist.filter { ($0.release_date).components(separatedBy: "-").first != String(originalYear) } //potrebbe non funzionare: in questo caso prendere la prima canzone e tramite apiCaller.getTrack(id) ricavarci l'anno

    
    if let randomSong = filteredSongs.randomElement() {
        return randomSong.release_date.components(separatedBy: "-").first!
    }
    
    return String(getRandomYearInRange(startYear: originalYear - 10, endYear: originalYear + 10))
}

func getRandomYearInRange(startYear: Int, endYear: Int) -> Int {
    return Int.random(in: startYear...endYear)
}


}


struct Question2 {
    let questionText: String?
    let correctAnswer: String
    let wrongAnswers: [String]
    
    func isCorrect(_ answer: String) -> Bool {
        return answer == correctAnswer
    }
}



