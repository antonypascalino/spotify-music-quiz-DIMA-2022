import XCTest
@testable import spotify_music_quiz_mida_2022

class APICallerTests: XCTestCase {
    var apiCaller: MockAPICaller!
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Crea un'istanza di MockAPICaller
        apiCaller = MockAPICaller()
       // apiCaller = APICaller(userManager: UserManager, authManager: <#AuthManagerProtocol#>)
        
    }
    
    override func tearDownWithError() throws {
        // Ripristina lo stato predefinito
        apiCaller = nil
        try super.tearDownWithError()
    }
    
    func testGetUserAlbums() {
        let expectation = XCTestExpectation(description: "Get user albums")
        


        apiCaller.getUserAlbums { result in
            switch result {
            case .success(let albums):
                // Verifica che l'array degli album non sia vuoto
                XCTAssertFalse(albums.isEmpty)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to get user albums: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
//    func testGetArtistRelatedArtists() {
//        let expectation = XCTestExpectation(description: "Get artist related artists")
//
//
//
//
//        apiCaller.getArtistRelatedArtists(for: "artist_id") { result in
//            switch result {
//            case .success(let artists):
//                // Verifica che l'array degli artisti non sia vuoto
//                XCTAssertFalse(artists.isEmpty)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get related artists: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetArtistTopTracks() {
//        let expectation = XCTestExpectation(description: "Get artist top tracks")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getArtistTopTracks(for: Artist(id: "artist_id")) { result in
//            switch result {
//            case .success(let tracks):
//                // Verifica che l'array delle tracce non sia vuoto
//                XCTAssertFalse(tracks.isEmpty)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get artist top tracks: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetCurrentUserPlaylist() {
//        let expectation = XCTestExpectation(description: "Get current user playlists")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getCurrentUserPlaylist { result in
//            switch result {
//            case .success(let playlists):
//                // Verifica che l'array delle playlist non sia vuoto
//                XCTAssertFalse(playlists.isEmpty)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get current user playlists: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetPlaylistsTracks() {
//        let expectation = XCTestExpectation(description: "Get playlists tracks")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getPlaylistsTracks(for: Playlist(id: "playlist_id")) { result in
//            switch result {
//            case .success(let tracks):
//                // Verifica che l'array delle tracce non sia vuoto
//                XCTAssertFalse(tracks.items.isEmpty)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get playlists tracks: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetSavedTracks() {
//        let expectation = XCTestExpectation(description: "Get saved tracks")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getSavedTracks { result in
//            switch result {
//            case .success(let tracks):
//                // Verifica che l'array delle tracce non sia vuoto
//                XCTAssertFalse(tracks.isEmpty)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get saved tracks: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetUserProfile() {
//        let expectation = XCTestExpectation(description: "Get user profile")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getUserProfile { result in
//            switch result {
//            case .success(let userProfile):
//                // Verifica che il profilo restituito non sia nullo
//                XCTAssertNotNil(userProfile)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get user profile: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetFollowedArtists() {
//        let expectation = XCTestExpectation(description: "Get followed artists")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getFollowedArtists { result in
//            switch result {
//            case .success(let artists):
//                // Verifica che l'array degli artisti non sia vuoto
//                XCTAssertFalse(artists.isEmpty)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get followed artists: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetTopArtists() {
//        let expectation = XCTestExpectation(description: "Get top artists")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getTopArtists { result in
//            switch result {
//            case .success(let artists):
//                // Verifica che l'array degli artisti non sia vuoto
//                XCTAssertFalse(artists.isEmpty)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get top artists: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetTopTracks() {
//        let expectation = XCTestExpectation(description: "Get top tracks")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getTopTracks { result in
//            switch result {
//            case .success(let tracks):
//                // Verifica che l'array delle tracce non sia vuoto
//                XCTAssertFalse(tracks.isEmpty)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get top tracks: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetTrack() {
//        let expectation = XCTestExpectation(description: "Get track")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getTrack(for: Track(id: "track_id")) { result in
//            switch result {
//            case .success(let track):
//                // Verifica che la traccia restituita non sia nulla
//                XCTAssertNotNil(track)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get track: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
//
//    func testGetRecommendation() {
//        let expectation = XCTestExpectation(description: "Get recommendation")
//
//        // Imposta un token di autenticazione fittizio
//
//
//        apiCaller.getRecommendation(songID: "song_id") { result in
//            switch result {
//            case .success(let recommendations):
//                // Verifica che le raccomandazioni restituite non siano vuote
//                XCTAssertFalse(recommendations.tracks.isEmpty)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Failed to get recommendation: \(error)")
//            }
//        }
//
//        wait(for: [expectation], timeout: 10.0)
//    }
    
    
}
