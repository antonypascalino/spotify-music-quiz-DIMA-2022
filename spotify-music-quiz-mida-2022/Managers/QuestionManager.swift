//
//  QuestionManager.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 30/05/23.
//

import Foundation
import SwiftUI

class QuestionManager: ObservableObject {
    static let shared = QuestionManager()
    private let apiCaller = APICaller.shared

    
    private(set) var whoSingsQuestion : [Question] = []
    private(set) var yearSongQuestion : [Question] = []
    private(set) var yearAlbumQuestion : [Question] = []
    private(set) var shazamTitleQuestion : [Question] = []
    private(set) var shazamAuthorQuestion : [Question] = []
    private(set) var authorSongQuestion : [Question] = []
    private(set) var albumSongQuestion : [Question] = []
    private(set) var popularArtistsQuestion : [Question] = []

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
    private(set) let predSongURL = "https://p.scdn.co/mp3-preview/74698d907d114f4ba0b2c129bbf260724be80b64?cid=0b297fa8a249464ba34f5861d4140e58"
    var isLoadingQuestions = true

    func importAllData() async throws {
        importPlaylists()
        importAlbums()
        importTracks()
    }
    
    func genRandomQuestions() async throws -> [Question] {
        
        var questionsTemp : [Question] = []
        
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
        
        isLoadingQuestions = false
        questionsTemp.shuffle()
        
        return questionsTemp
    }
    
    //Functions to generate each type of questions
    
    private func genWhoSingsQuestions() -> [Question] {
        var questions: [Question] = []
        
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 3)
        
        for track in tempTracks {
            
            let correctAnswer = track.artists.first!.name
            var similarArtistsNames : [String] = []
            
            self.similarArtists = []
            
            loadArtistRelatedArtists(track: track)
            while(isLoading) {
                ProgressView()
            }
            isLoading = true
            
            if !similarArtists.isEmpty{
                for i in 0...2{
                    similarArtistsNames.append(similarArtists[i].name)
                }
                
                let question = Question(questionText: "Who sings the song _\(filterString(track.name))_?",
                                        correctAnswer: correctAnswer,
                                        songUrl : track.preview_url ?? predSongURL,
                                        author: correctAnswer,
                                        wrongAnswers: similarArtistsNames)
                
                questions.append(question)
            }
            
            
        }
       
      
        return questions
    }
    
    private func genAuthorSongQuestion() -> [Question] {
        var questions: [Question] = []
        
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 3)
        
        for track in tempTracks {
            
            let correctAnswer = track.name
            var similarSongsNames : [String] = []
            
            self.similarSongs = []
            
            loadReccom(track: track)
            while(isLoading) {
                ProgressView()
            }
            isLoading = true
            
            if !similarSongs.isEmpty{
                for i in 0...2{
                    similarSongsNames.append(similarSongs[i].name)
                }
                
                let question = Question(questionText: "Quale canzone è di _\(filterString(track.artists.first!.name))_?",
                                        correctAnswer: correctAnswer,
                                        songUrl : track.preview_url ?? predSongURL,
                                        author: track.artists.first!.name,
                                        wrongAnswers: similarSongsNames)
                questions.append(question)
            }
            
            
        }
       
      
        return questions
    }
    
    private func genYearAlbumQuestions() -> [Question] {
        var questions: [Question] = []
        

        var tempAlbums : [Album] = []
        tempAlbums = reduceAlbumDim(num: 3)

        for album in tempAlbums {
            let correctAnswer = getOnlyYear(allDate: album.release_date)
            
            let similarDates = generateRandomDates(originalYear: getOnlyYear(allDate: album.release_date), originalArtist : album.artists.first!)
            
            let question = Question(questionText: "What year was the album _\(album.name)_ released?",
                                    correctAnswer: correctAnswer,
                                    songUrl : track.preview_url ?? predSongURL,
                                    author: album.artists.first!.name,
                                    wrongAnswers: similarDates)
            
            questions.append(question)
        }
        
        return questions
    }
    
    private func genYearSongQuestions() -> [Question] {
        var questions: [Question] = []
        
        
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 3)
        
        for track in tempTracks {
            let correctAnswer = getOnlyYear(allDate: track.album!.release_date)
            
            let similarDates = generateRandomDates(originalYear: getOnlyYear(allDate : track.album!.release_date), originalArtist : track.album!.artists.first!)
            
            let question = Question(questionText: "What year was the song _\(filterString(track.name))_ released?",
                                    correctAnswer: correctAnswer,
                                    songUrl : track.preview_url ?? predSongURL,
                                    author: track.artists.first!.name,
                                    wrongAnswers: similarDates)
            questions.append(question)
        }
        
        return questions
    }
    
    private func genShazamTitleQuestions() -> [Question]{
       var questions: [Question] = []
       
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 3)
        
        for track in tempTracks {
        
            let correctAnswer = filterString(track.name)
            
            if(track.preview_url != nil){
                let question = Question(questionText: "Guess the title of the song!",
                                         correctAnswer: correctAnswer,
                                         isShazam : true,
                                         songUrl : track.preview_url,
                                         albumImage : track.album!.images.first!.url,
                                         author : track.artists.first!.name,
                                         wrongAnswers: [])
                questions.append(question)
            }
            
        }
               
           return questions
       }
    
    private func genShazamAuthorQuestions() -> [Question]{
       var questions: [Question] = []
       
        var tempTracks : [Track] = []
        tempTracks = reduceArrayDim(num: 3)
        
        for track in tempTracks {
        
            let correctAnswer = track.artists.first!.name
            
            if(track.preview_url != nil){
                let question = Question(questionText: "Guess the author of the song!",
                                        correctAnswer: correctAnswer,
                                        isShazam : true,
                                        songUrl : track.preview_url,
                                        albumImage : track.album!.images.first!.url,
                                        author: track.artists.first!.name,
                                        songName : filterString(track.name),
                                        wrongAnswers: [])
                questions.append(question)
            }
            
        }
               
           return questions
       }
    
    private func genAlbumSongQuestions() -> [Question] {
            var questions: [Question] = []

            var tempAlbums : [Album] = []
            tempAlbums = reduceAlbumDim(num: 3)

            for var album in tempAlbums {
                album.tracks.items.shuffle()
                let correctTrack = album.tracks.items.first!
                let correctAnswer = correctTrack.name

                self.reccTracks = []
                loadRecc(track: correctTrack)
                while(isLoading){
                    ProgressView()
                }
                isLoading = true
                self.reccTracks.shuffle()

                var similarTracksNames : [String] = []
                if !reccTracks.isEmpty && reccTracks.count > 3{
                    
                    for i in 0...reccTracks.count-1{
                        if(reccTracks[i].artists.first!.name != album.artists.first!.name){
                            similarTracksNames.append(reccTracks[i].name)
                        }  
                        if similarTracksNames.count == 3 {
                            break;
                        }
                    }
                    
                    let question = Question(questionText: "Quale canzone è dell'album '\(album.name)'?",
                                            correctAnswer: correctAnswer,
                                            songUrl : track.preview_url ?? predSongURL,
                                            author: album.artists.first!.name,
                                            wrongAnswers: similarTracksNames)
                    questions.append(question)
                }


            }
                return questions

        }
    
    
    //Functions for generate random number/dates
    
    
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

            while(isLoading) {
                ProgressView()
            }
            isLoading = true
        
            self.songsBySameArtist.shuffle()
        
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

    
    
    //Load API Date
    
    private func loadTopTracks(){
        
        apiCaller.getTopTracks { result in
            switch result{
                case .success(let model):
                    self.userTracks.append(contentsOf: model)
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
    
    private func loadTracksFromPlaylists(){
        //shuffle of userPlaylists
        self.filteredUserPlaylists.shuffle()
        
        if(self.filteredUserPlaylists.count >= 1){
            
            for i in 0...self.filteredUserPlaylists.count-1 {
                
                //save in tempTrack the tracks of the all playlists
                self.tempTrack = []
                loadTracksFromPlaylist(playlist: self.filteredUserPlaylists[i])
        
                while(isLoading){
                    ProgressView()
                }
        
                var trackList : [Track] = []
                
                if(self.tempTrack.count >= 1){
                    for i in 0...self.tempTrack.count-1
                    {
                        trackList.append(self.tempTrack[i].track!)
                    }
                }
                    
                                   
                self.userTracks.append(contentsOf: trackList)
                
                isLoading = true
            }
        }
        
    }
    
    private func loadTracksFromPlaylist(playlist : Playlist){
        
        apiCaller.getPlaylistsTracks(for : playlist) {  result in
            switch result{
                case .success(let model):
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
    
    private func loadRecc(track: SimpleTrack){
            apiCaller.getRecommendation(songID: track.id) {result in
                switch result{
                    case .success(let model):
                        self.reccTracks = model.tracks
                        self.isLoading = false
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        //self?.failedToGetProfile()
                }
            }
        }
    
    private func loadReccom(track: Track){
            apiCaller.getRecommendation(songID: track.id) {result in
                switch result{
                    case .success(let model):
                        self.similarSongs = model.tracks
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
        
        loadTopTracks()
        
        while(isLoading) {
            ProgressView()
        }
        isLoading = true
        
        loadTracksFromPlaylists()
        
    }
    
    private func importAlbums(){
        
        loadAlbums()
        
        while(isLoading) {
            ProgressView()
        }
        isLoading = true
        

    }
    
    private func importPlaylists() {
        
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
        
    }
    
    private func reduceArrayDim(num: Int) -> [Track] {
        self.userTracks.shuffle()
        return Array(self.userTracks.prefix(self.userTracks.count > num ? num : self.userTracks.count))
    }

    private func reduceAlbumsDim(num: Int) -> [Album] {
        self.albums.shuffle()
        return Array(self.albums.prefix(self.albums.count > num ? num : self.albums.count))
    }
    
}
