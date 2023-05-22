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
    var albums : [Album] = []
    var artists : [Artist] = []
    var similarArtists : [Artist] = []
    var songsBySameArtist : [Track] = []
    var userPlaylists : [Playlist] = []
    var filteredUserPlaylists : [Playlist] = []
    var tempTrack : [PlaylistItem] = []
    var isLoading = true
    
    private let apiCaller = APICaller.shared
    
    init() {
        startGame()
    }
    
    
    func startGame() {
        let words = ["lofi", "relax", "cover", "chill"]
        loadPlaylists()
        while(isLoading){
            ProgressView()
        }
        isLoading = true
        self.filteredUserPlaylists = []
        self.filteredUserPlaylists = self.userPlaylists.filter{ playlist in
            return !words.contains { word in
                    if let range = playlist.name.range(of: word, options: .caseInsensitive) {
                        return true
                    }
                        return false
                }
            }
        
        
        
        questions = generateRandomQuestions()
        questions.shuffle()
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
                questions = []
                questions = generateRandomQuestions()
                questions.shuffle()
            }
            
            if currentQuestionIndex == 5 {
                questions.append(contentsOf: generateRandomQuestionsLv2())
                questions.shuffle()
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
        var questionsTemp : [Question2] = []
        
        // Genera domande di tipo "chi cantante canta questa canzone"
        let artistQuestions = generateArtistQuestions()
        questionsTemp.append(contentsOf: artistQuestions)
        
        
        
//        // Genera domande di tipo "a quale album appartiene la canzone 'TITOLO'?"
//        let albumSongQuestions = generateAlbumSongQuestions()
//        questionsTemp.append(contentsOf: albumSongQuestions)
        
//        let listenSongQuestions = generateListenSongQuestions()
//        questionsTemp.append(contentsOf: listenSongQuestions)

        return questionsTemp
    }
    
    func generateRandomQuestionsLv2() -> [Question2] {
        
        var questionsTemp : [Question2] = []
        // Genera domande di tipo "in che anno è stato pubblicato quest'album"
        let albumQuestions = generateAlbumQuestions()
        questionsTemp.append(contentsOf: albumQuestions)
        
        // Genera domande di tipo "qual è l'anno di pubblicazione di questa canzone?"
        let releaseYearQuestions = generateReleaseYearQuestions()
        questionsTemp.append(contentsOf: releaseYearQuestions)
        
        return questionsTemp
    }
    private func generateArtistQuestions() -> [Question2] {
        var questions: [Question2] = []
        self.topTracks = []
        
        loadTopTracks()
//                fetchData(){
//                    result in
//                    switch result {
//                        case true :
//                            self.isLoading = true
//                        case false:
//                            self.isLoading = true
//                    }
//                }
        while(isLoading) {
            ProgressView()
        }
        isLoading = true
        
        loadTracksFromPlaylists()
        
        
        self.topTracks.shuffle()
        
        for track in self.topTracks {
            
            let correctAnswer = track.artists.first!.name
            var similarArtistsNames : [String] = []
            
            loadArtistRelatedArtists(track: track)
            while(isLoading) {
                ProgressView()
            }
            isLoading = true
            
            if !similarArtists.isEmpty{
                for i in 0...2{
                    similarArtistsNames.append(similarArtists[i].name)
                }
                
                let question = Question2(questionText: "Who sings the song '\(track.name)'?",
                                         correctAnswer: correctAnswer,
                                         wrongAnswers: similarArtistsNames)
                questions.append(question)
            }
            
            
        }
       
        
        return questions
    }
    
    private func generateAlbumQuestions() -> [Question2] {
        var questions: [Question2] = []
        
        loadAlbums()
        while(isLoading) {
            ProgressView()
        }
        isLoading = true

        for album in self.albums {
            let correctAnswer = getOnlyYear(allDate: album.release_date)
            
            let similarDates = generateRandomDates(originalYear: getOnlyYear(allDate: album.release_date), originalArtist : album.artists.first!)
            
            let question = Question2(questionText: "What year was the album '\(album.name)' released?",
                                     correctAnswer: correctAnswer,
                                     wrongAnswers: similarDates)
           
            questions.append(question)
        }
        
        return questions
    }
    
    private func generateReleaseYearQuestions() -> [Question2] {
       var questions: [Question2] = []
       self.topTracks = []
       
       loadTopTracks()

        while(isLoading) {
            ProgressView()
        }
        isLoading = true
        
        loadTracksFromPlaylists()
        
        
        self.topTracks.shuffle()
        
       for track in self.topTracks {
           let correctAnswer = getOnlyYear(allDate: track.album!.release_date)
           
           let similarDates = generateRandomDates(originalYear: getOnlyYear(allDate : track.album!.release_date), originalArtist : track.album!.artists.first!)

           let question = Question2(questionText: "What year was the song '\(track.name)' released?",
                                    correctAnswer: correctAnswer,
                                    wrongAnswers: similarDates)
           questions.append(question)
       }
               
           return questions
       }
    
    
    private func generateListenSongQuestions() -> [Question2]{
       var questions: [Question2] = []
       self.topTracks = []
       
       loadTopTracks()

        while(isLoading) {
            ProgressView()
        }
        isLoading = true
        
        loadTracksFromPlaylists()
        
        while(isLoading){
            ProgressView()
        }
        isLoading = true
        
        self.topTracks.shuffle()
        
       for track in self.topTracks {
           let correctAnswer = track.name
           if(track.preview_url != nil){
               let question = Question2(questionText: "Guess the title of the song!",
                                        correctAnswer: correctAnswer,
                                        isShazam : true,
                                        songUrl : track.preview_url,
                                        wrongAnswers: [])
               questions.append(question)
           }
           
       }
               
           return questions
       }
    
//    private func generateAlbumSongQuestions() -> [Question2] {
//        
//        
//    }

    
    private func generateRandomDates(originalYear: String, originalArtist : Artist) -> [String] {
           var randomYears: [String] = []
        
           guard let originalYearInt = Int(originalYear) else {
           return randomYears //aggiungere gestione eccezioni
           }
        
        var years : [Int] = []
        years.append(originalYearInt)
        let randomYearFromSameArtist = getRandomYearFromSameArtist(originalYear: originalYearInt, originalArtist : originalArtist, years: years)
        
        randomYears.append(randomYearFromSameArtist)
        years.append(Int(randomYearFromSameArtist)!)
        
        let randomYear2 = getRandomYearInRange(startYear: originalYearInt - 10, endYear: originalYearInt + 10 <= Calendar.current.component(.year , from: Date()) ? originalYearInt + 10 : originalYearInt, years: years  )
        
        years.append(randomYear2)
        let randomYear3 = getRandomYearInRange(startYear: originalYearInt - 10, endYear: originalYearInt + 10 <= Calendar.current.component(.year , from: Date()) ? originalYearInt + 10 : originalYearInt,years: years )
        
        randomYears.append(String(randomYear2))
        randomYears.append(String(randomYear3))
        
           return randomYears
       }
    
    private func getRandomYearFromSameArtist(originalYear: Int, originalArtist : Artist, years: [Int]) -> String {

            loadArtistTopTracks(originalArtist: originalArtist)
//            fetchData(){
//                result in
//                switch result {
//                    case true :
//                        self.isLoading = true
//                    case false:
//                        self.isLoading = false
//                }
//            }
        while(isLoading) {
            ProgressView()
        }
        isLoading = true
        
        
        
            let filteredSongs = self.songsBySameArtist.filter { getOnlyYear(allDate: $0.album!.release_date) != String(originalYear) }
          
            if let randomSong = filteredSongs.randomElement() {
                return getOnlyYear(allDate: randomSong.album!.release_date)
            }
            
        return String(getRandomYearInRange(startYear: originalYear - 10, endYear: originalYear + 10 <= Calendar.current.component(.year , from: Date()) ? originalYear + 10 : originalYear, years: years))
        }
          
    private func getRandomYearInRange(startYear: Int, endYear: Int, years: [Int]) -> Int {
            var randInt = 0;
            repeat {
                 randInt = Int.random(in: startYear...endYear)
            }while years.contains(randInt)
            
         return randInt
        }
         
        private func getOnlyYear(allDate : String) -> (String){
            return allDate.components(separatedBy: "-").first!
        }

    
    private func loadTopTracks(){
        
        apiCaller.getTopTracks { result in
            switch result{
                case .success(var model):
                    model.shuffle()
                    let firstTenElements = Array(model.prefix(model.count > 10 ? 10 : model.count))
                    self.topTracks.append(contentsOf: firstTenElements)
                    self.isLoading = false
                    
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
                case .success(var model):
                    model.shuffle()
                    self.similarArtists = model
                    self.isLoading = false
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    //self?.failedToGetProfile()
            }
        }
    }
    
    private func loadTracksFromPlaylists(){
        self.filteredUserPlaylists.shuffle()
        
       // let nrOfPlaylist = self.filteredUserPlaylists.count > 2 ? 2: self.filteredUserPlaylists.count
            
//        if(nrOfPlaylist >= 1) {
//            for i in 0...nrOfPlaylist-1 {
                self.tempTrack = []
                loadTracksFromPlaylist(playlist: self.filteredUserPlaylists[0])
                while(isLoading){
                    ProgressView()
                }
                var trackList : [Track] = []
                var length = self.tempTrack.count > 10 ? 10 : self.tempTrack.count
                
                if(length >= 1){
                    for i in 0...length-1
                    {
                            trackList.append(self.tempTrack[i].track!)
                    }
                }
                    
                                   
                self.topTracks.append(contentsOf: trackList)
                
                isLoading = true
//            }
//        }
       
    }
    
    private func loadTracksFromPlaylist(playlist : Playlist){
        
        apiCaller.getPlaylistsTracks(for : playlist) {  result in
            switch result{
                case .success(var model):
                    model.tracks.items.shuffle()
                    self.tempTrack = model.tracks.items
                    self.isLoading = false
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    //self?.failedToGetProfile()
            }
        }
    }
    private func loadAlbums(){
            
             apiCaller.getUserAlbums {result in
                switch result{
                    case .success(let model):
                        self.albums = model
                        self.isLoading = false
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        //self?.failedToGetProfile()
                }
                
            }
        }
    
    private func loadPlaylists(){
            
             apiCaller.getCurrentUserPlaylist {result in
                switch result{
                    case .success(let model):
                        self.userPlaylists = model
                        self.isLoading = false
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        //self?.failedToGetProfile()
                }
                
            }
        }

    private func loadArtistTopTracks(originalArtist : Artist){

        apiCaller.getArtistTopTracks(for : originalArtist) {result in
            switch result{
                case .success(let model):
                    self.songsBySameArtist = model
                    self.isLoading = false
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    //self?.failedToGetProfile()
            }
        }
    }
    
    private func fetchData(completion: @escaping (Bool) -> Void) {
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 5)
                
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
   
}

struct Question2 : Equatable {
    let id = UUID()
    let questionText: String?
    let correctAnswer: String
    var isShazam = false
    var songUrl : String? = nil
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



