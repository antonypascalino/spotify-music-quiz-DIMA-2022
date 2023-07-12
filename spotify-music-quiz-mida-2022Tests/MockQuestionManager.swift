//
//  MockAuthManager.swift
//  spotify-music-quiz-mida-2022Tests
//
//  Created by Antony Pascalino on 26/06/23.
//

import Foundation
@testable import spotify_music_quiz_mida_2022

final class MockQuestionManager: QuestionManagerProtocol, Mockable {
    

    private(set) var whoSingsQuestion : [Question] = []
    private(set) var yearSongQuestion : [Question] = []
    private(set) var yearAlbumQuestion : [Question] = []
    private(set) var shazamTitleQuestion : [Question] = []
    private(set) var shazamAuthorQuestion : [Question] = []
    private(set) var authorSongQuestion : [Question] = []
    private(set) var albumSongQuestion : [Question] = []
    private(set) var popularArtistsQuestion : [Question] = []
    private(set) var allQuestions: [Question] = []
    private(set) var leaderboardQuestions: [Question] = []

    private(set) var userPlaylists : [Playlist] = []
    private(set) var userTracks : [Track] = []
    private(set) var albums : [SimpleAlbum] = []
    private(set) var artists : [Artist] = []
    private(set) var similarArtists : [Artist] = []
    private(set) var songsBySameArtist : [Track] = []
    private(set) var filteredUserPlaylists : [Playlist] = []
    private(set) var tempTrack : [PlaylistItem] = []
    private(set) var reccTracks : [Track] = []
    private(set) var similarSongs : [Track] = []
    private(set) var isLoading = true
    var loadedData = false
    private let predSongURL = "https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=0b297fa8a249464ba34f5861d4140e58"
    @Published var isLoadingQuestions = true
    
    init() {
        
    }
    

    func importAllData() async throws {
        print("import")
        if !loadedData {
            importPlaylists()
            print("import 1")
            importAlbums()
            print("import 2")
            importTracks()
            print("import 3")
            loadedData = true
            print("in import")

        }
        print("end import")

    }
    
    func genRandomQuestions(code: String, regenQuest: Bool) async throws -> [Question] {
        
        var questionsTemp : [Question] = []
        
        
        switch code {
            case "whoIsTheAuthor" :
                if(regenQuest ){
                    self.whoSingsQuestion = genWhoSingsQuestions()
                }
                questionsTemp.append(contentsOf: self.whoSingsQuestion)
                print("Mode: Who")
                break
            case "recallTheYear" :
                if(regenQuest){
                    self.yearSongQuestion = genYearSongQuestions()
                    self.yearAlbumQuestion = genYearAlbumQuestions()

                }
                questionsTemp.append(contentsOf: self.yearSongQuestion)
                questionsTemp.append(contentsOf: self.yearAlbumQuestion)
                print("Mode: Recall")
                break
            case "guessTheSong" :
                if(regenQuest){
                    self.shazamTitleQuestion = genShazamTitleQuestions()

                }
                questionsTemp.append(contentsOf: self.shazamTitleQuestion)
                print("Mode: guessTheSong")
                break
            case "guessTheSinger" :
                if(regenQuest){
                    self.shazamAuthorQuestion = genShazamAuthorQuestions()

                }
                questionsTemp.append(contentsOf: self.shazamAuthorQuestion)
                print("Mode: guessTheSinger")
                break
            case "authorSong" :
                if(regenQuest){
                    self.authorSongQuestion = genAuthorSongQuestion()
                    //self.leaderboardQuestions = try await genLeaderBoardQuestions()
                }
                questionsTemp.append(contentsOf: self.authorSongQuestion)
                //questionsTemp.append(contentsOf: self.leaderboardQuestions)
                print("Mode: authorSong")
                break
            case "whichAlbum" :
                if(regenQuest){
                    self.albumSongQuestion = genAlbumSongQuestions()
                }
                questionsTemp.append(contentsOf: self.albumSongQuestion)
                print("Mode: whichAlbum")
                break
            case "classic" :
                if(regenQuest) {
                    print("Regen Classic")
                try await questionsTemp.append(contentsOf: genAllQuestions())
                }
                else{
                    print(" No Regen Classic")
                    questionsTemp.append(contentsOf: allQuestions)
                }
            case "home":
                try await questionsTemp.append(contentsOf: genAllQuestions())
//                print("Home")
            default:
                print("Mode: classic")
        }
        
       
        questionsTemp.shuffle()
        return questionsTemp
    }
    
    func genAllQuestions() async throws -> [Question] {
        
        var questionsTemp : [Question] = []
        self.allQuestions = []
        
        self.whoSingsQuestion = genWhoSingsQuestions()
        questionsTemp.append(contentsOf: self.whoSingsQuestion)
        print("Prima")
        self.yearSongQuestion = genYearSongQuestions()
        questionsTemp.append(contentsOf: self.yearSongQuestion)
        print("Prima2")
        self.yearAlbumQuestion = genYearAlbumQuestions()
        questionsTemp.append(contentsOf: self.yearAlbumQuestion)
        print("Prima3")
        self.shazamTitleQuestion = genShazamTitleQuestions()
        questionsTemp.append(contentsOf: self.shazamTitleQuestion)
        print("Prima4")
        self.shazamAuthorQuestion = genShazamAuthorQuestions()
        questionsTemp.append(contentsOf: self.shazamAuthorQuestion)
        print("Prima5")
        self.albumSongQuestion = genAlbumSongQuestions()
        questionsTemp.append(contentsOf: self.albumSongQuestion)
        print("Prima6")
        self.authorSongQuestion = genAuthorSongQuestion()
        questionsTemp.append(contentsOf: self.authorSongQuestion)
        print("Prima7")
        //self.leaderboardQuestions = try await genLeaderBoardQuestions()
        //questionsTemp.append(contentsOf:self.leaderboardQuestions)
        //print("Prima8")
        
        questionsTemp.shuffle()
        self.allQuestions = questionsTemp
        
      //  return try await genLeaderBoardQuestions()
        return questionsTemp
    }
    
    
    
    //Functions to generate each type of questions
    
     func genWhoSingsQuestions() -> [Question] {
         print("1")
        var questions: [Question] = []
        
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 5)
        
        for track in tempTracks {
            
            let correctAnswer = filterString(track.artists.first!.name)
            var similarArtistsNames : [String] = []
            
            self.similarArtists = []
            
            loadArtistRelatedArtists(artistId: track.artists.first!.id)
            while(isLoading) {
                 
            }
            isLoading = true
            
            if !similarArtists.isEmpty{
                for i in 0...2 {
                    similarArtistsNames.append(filterString(similarArtists[i].name))
                }
                
                let question = Question(questionText: "Who is the author of the song _\(filterString(track.name))_?",
                                        correctAnswer: correctAnswer,
                                        songUrl : track.preview_url ?? predSongURL,
                                        author: track.artists.first!.name,
                                        authorId: track.artists.first!.id,
                                        songName: track.name,
                                        wrongAnswers: similarArtistsNames)
                
                questions.append(question)
            }
            
            
        }
       
        return questions
    }
    
     func genAuthorSongQuestion() -> [Question] {
         print("2")

        var questions: [Question] = []
        
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 5)
        
        for track in tempTracks {
            
            let correctAnswer = filterString(track.name)
//            var similarSongsNames : [String] = []
            
            self.similarSongs = []
            
            loadReccom(track: track)
            while(isLoading) {
                 
            }
            isLoading = true
            
            if !similarSongs.isEmpty{
                var similarSongsNames : [String] = []
                for i in 0...self.similarSongs.count-1{
                    if(similarSongs[i].name != correctAnswer){
                        similarSongsNames.append(filterString(similarSongs[i].name))
                    }
                    if similarSongsNames.count == 3 {
                        break;
                    }
                }
                
                let question = Question(questionText: "Which of these songs is of _\(filterString(track.artists.first!.name))_?",
                                        correctAnswer: correctAnswer,
                                        songUrl : track.preview_url ?? predSongURL,
                                        author: track.artists.first!.name,
                                        authorId: track.artists.first!.id,
                                        songName: track.name,
                                        wrongAnswers: similarSongsNames)
                questions.append(question)
            }
            
            
        }
       
      
        return questions
    }
    
     func genYearAlbumQuestions() -> [Question] {
         print("3")

        var questions: [Question] = []
        

        var tempAlbums : [SimpleAlbum] = []
        tempAlbums = reduceAlbumDim(num: 5)

        for album in tempAlbums {
            let correctAnswer = getOnlyYear(allDate: album.release_date)
            
            let similarDates = generateRandomDates(originalYear: getOnlyYear(allDate: album.release_date), originalArtist : album.artists.first!)
//            print("songUrlAll: \(album.tracks.items)")

            let songsWithUrl = album.tracks.items.filter {
                $0.preview_url != nil
            }
//            print("songUrl1: \(songsWithUrl)")
            
            let question = Question(questionText: "What year was the album _\(album.name)_ released?",
                                    correctAnswer: correctAnswer,
                                    songUrl : songsWithUrl.first?.preview_url ?? predSongURL,
                                    author: album.artists.first!.name,
                                    authorId: album.artists.first!.id,
                                    songName: "",
                                    wrongAnswers: similarDates)
            
            questions.append(question)
        }
        
        return questions
    }
    
     func genYearSongQuestions() -> [Question] {
         print("4")

        var questions: [Question] = []
        
        
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 5)
        
        for track in tempTracks {
            let correctAnswer = getOnlyYear(allDate: track.album!.release_date)
            
            let similarDates = generateRandomDates(originalYear: getOnlyYear(allDate : track.album!.release_date), originalArtist : track.album!.artists.first!)
            
            let question = Question(questionText: "What year was the song _\(filterString(track.name))_ released?",
                                    correctAnswer: correctAnswer,
                                    songUrl : track.preview_url ?? predSongURL,
                                    author: track.artists.first!.name,
                                    authorId: track.artists.first!.id,
                                    songName: track.name,
                                    wrongAnswers: similarDates)
            questions.append(question)
        }
        
        return questions
    }
    
     func genShazamTitleQuestions() -> [Question]{
       var questions: [Question] = []
       
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 5)
        
        for track in tempTracks {
        
            let correctAnswer = filterString(track.name)
            
            if(track.preview_url != nil){
                let question = Question(questionText: "Guess the title of the song!",
                                        correctAnswer: correctAnswer,
                                        isShazam : true,
                                        songUrl : track.preview_url,
                                        albumImage : track.album!.images.first!.url,
                                        author : track.artists.first!.name,
                                        authorId : track.artists.first!.id,
                                        songName: track.name,
                                        wrongAnswers: [])
                questions.append(question)
            }
            
        }
               
           return questions
       }
    
     func genShazamAuthorQuestions() -> [Question]{
       var questions: [Question] = []
       
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 5)
        
        for track in tempTracks {
        
            let correctAnswer = track.artists.first!.name
            
            if(track.preview_url != nil) {
                let question = Question(questionText: "Guess the author of the song!",
                                        correctAnswer: filterString(correctAnswer),
                                        isShazam : true,
                                        songUrl : track.preview_url,
                                        albumImage : track.album!.images.first!.url,
                                        author: track.artists.first!.name,
                                        authorId: track.artists.first!.id,
                                        songName : filterString(track.name),
                                        wrongAnswers: [])
                questions.append(question)
            }
            
        }
               
           return questions
       }
    
     func genAlbumSongQuestions() -> [Question] {
            var questions: [Question] = []

            var tempAlbums : [SimpleAlbum] = []
            tempAlbums = reduceAlbumDim(num: 5)

            for var album in tempAlbums {
                album.tracks.items.shuffle()
                let correctTrack = album.tracks.items.first!
                let correctAnswer = filterString(correctTrack.name)

                self.reccTracks = []
                loadRecc(track: correctTrack)
                while(isLoading) {
                     
                }
                isLoading = true
                self.reccTracks.shuffle()

                var similarTracksNames : [String] = []
                if !reccTracks.isEmpty && reccTracks.count > 3{
                    
                    for i in 0...reccTracks.count-1{
                        if(reccTracks[i].artists.first!.name != album.artists.first!.name){
                            similarTracksNames.append(filterString(reccTracks[i].name))
                        }
                        if similarTracksNames.count == 3 {
                            break;
                        }
                    }
//                    print("songUrLWhichAll: \(album.tracks.items)")
                    let songsWithUrl = album.tracks.items.filter {
                        $0.preview_url != nil
                    }
                    
//                    print("songUrlWhich: \(songsWithUrl)")

                    let question = Question(questionText: "Which of these songs is in the album _\(album.name)_?",
                                            correctAnswer: correctAnswer,
                                            songUrl : songsWithUrl.first?.preview_url ?? predSongURL,
                                            author: album.artists.first!.name,
                                            authorId: album.artists.first!.id,
                                            songName: correctTrack.name,
                                            wrongAnswers: similarTracksNames)
                    questions.append(question)
                }


            }
                return questions

        }
    
    
    //Functions for generate random number/dates
    
    
     func generateRandomDates(originalYear: String, originalArtist : Artist) -> [String] {
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
    
     func getRandomYearFromSameArtist(originalYear: Int, originalArtist : Artist, years: [Int]) -> String {

            loadArtistTopTracks(originalArtist: originalArtist)

            while(isLoading) {
                
            }
            isLoading = true
        
            self.songsBySameArtist.shuffle()
        
            let filteredSongs = self.songsBySameArtist.filter { getOnlyYear(allDate: $0.album!.release_date) != String(originalYear) }
          
            if let randomSong = filteredSongs.randomElement() {
                return getOnlyYear(allDate: randomSong.album!.release_date)
            }
            
        
        return String(getRandomYearInRange(startYear: originalYear - 10, endYear: originalYear + 10 <= Calendar.current.component(.year , from: Date()) ? originalYear + 10 : originalYear, years: years))
        }
          
     func getRandomYearInRange(startYear: Int, endYear: Int, years: [Int]) -> Int {
            var randInt = 0;
            repeat {
                 randInt = Int.random(in: startYear...endYear)
            }while years.contains(randInt)
            
         return randInt
        }
         
        private func getOnlyYear(allDate : String) -> (String){
            return allDate.components(separatedBy: "-").first!
        }

    
    
    //Load API Date
    
    private func loadTopTracks(){
        self.userTracks = loadJSON(filename: "UserTopTracks", type: LibraryTrackResponse.self).items
            self.isLoading = false
    }
    
    private func loadSavedTracks(){
        
        self.userTracks = loadJSON(filename: "SavedTracks", type: LibrarySavedTrackResponse.self).items.compactMap({ $0.track })
            self.isLoading = false
    }
    
   
    private func loadArtistRelatedArtists(artistId: String){
        
        self.similarArtists = loadJSON(filename: "ArtistRelatedArtists", type: RelatedArtistResponse.self).artists
            self.isLoading = false
        
    }
    
    private func loadTracksFromPlaylists(){
        //shuffle of userPlaylists
        self.filteredUserPlaylists.shuffle()
        
        if(self.filteredUserPlaylists.count >= 1){
            
            for i in 0...self.filteredUserPlaylists.count-1 {
                
                //save in tempTrack the tracks of the all playlists
                self.tempTrack = []
                loadTracksFromPlaylist(playlist: self.filteredUserPlaylists[i])
        
                while(isLoading){
                     
                }
        
                var trackList : [Track] = []
                
                if(self.tempTrack.count >= 1){
                    for i in 0...self.tempTrack.count-1
                    {
                        if self.tempTrack[i].track != nil {
                            trackList.append(self.tempTrack[i].track!)
                        }
                    }
                }
                    
                                   
                self.userTracks.append(contentsOf: trackList)
                
                isLoading = true
            }
        }
        
    }
    
    private func loadTracksFromPlaylist(playlist : Playlist){
        
        self.tempTrack = loadJSON(filename: "PlaylistTracks2", type: PlaylistTracks.self).tracks.items
            self.isLoading = false
        
    }
    
    private func loadAlbums(){
        
        self.albums = loadJSON(filename: "UserAlbums", type: LibraryAlbumResponse.self).items.compactMap({
            $0.album
        })
        self.isLoading = false
    }
    
    private func loadRecc(track: SimpleTrack){
        let reccTracks = loadJSON(filename: "ReccTracks", type: RecommendationsResponse.self)
        self.reccTracks = reccTracks.tracks
        self.isLoading = false
        }
    
    private func loadReccom(track: Track){
            let reccTracks = loadJSON(filename: "ReccTracks", type: RecommendationsResponse.self)
            self.similarSongs = reccTracks.tracks
            self.isLoading = false
        }
    
    private func loadPlaylists(){
        self.userPlaylists = loadJSON(filename: "UserPlaylist", type: LibraryPlaylistsResponse.self).items
        self.isLoading = false
            
        }

    private func loadArtistTopTracks(originalArtist : Artist){
        let artistTopTracks = loadJSON(filename: "ArtistTopTracks", type: Tracks.self).tracks
            
            self.songsBySameArtist = artistTopTracks
            self.isLoading = false

    }
    
    
    func filterString(_ inputString: String) -> String {
        var filteredString = inputString
        
        if let separatorIndex = filteredString.range(of: " -")?.lowerBound {
            filteredString = String(filteredString[..<separatorIndex])
        }
        
        if let parenthesisIndex = filteredString.range(of: " (")?.lowerBound {
            filteredString = String(filteredString[..<parenthesisIndex])
        }
        
        return filteredString.trimmingCharacters(in: .whitespaces)
    }
    
    private func importTracks(){
        print("CIAOOOOO Top")

        loadTopTracks()
        
        while(isLoading) {
             
        }
        isLoading = true
        print("Saved Tracks Inizio")
        loadSavedTracks()
        while(isLoading) {
             
        }
        isLoading = true
        print("Saved Tracks Fine")
        loadTracksFromPlaylists()
        

        
    }
    
    private func importAlbums(){
        
        loadAlbums()
        
        while(isLoading) {
             
        }
        isLoading = true
        

    }
    
    private func importPlaylists() {

        let words = ["lofi", "relax", "cover", "chill"]
        loadPlaylists()
        while(isLoading){
             
        }
        isLoading = true
        print("Fine Playlist")
        self.filteredUserPlaylists = []
        self.filteredUserPlaylists = self.userPlaylists.filter{ playlist in
            return !words.contains { word in
                    if let range = playlist.name.range(of: word, options: .caseInsensitive) {
                        return true
                    }
                        return false
                }
            }
        
    }
    
    private func reduceArrayDim(num: Int) -> [Track] {
        self.userTracks.shuffle()
        return Array(self.userTracks.prefix(self.userTracks.count > num ? num : self.userTracks.count))
    }

    private func reduceAlbumDim(num: Int) -> [SimpleAlbum] {
        self.albums.shuffle()
        return Array(self.albums.prefix(self.albums.count > num ? num : self.albums.count))
    }
}
