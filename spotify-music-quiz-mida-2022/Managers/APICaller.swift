import Foundation
import SwiftUI



enum HTTPMethod: String{
    case GET
    case POST
    case DELETE
    case PUT
}


protocol APICallerProtocol {
    func createRequest(with url: URL?,type: HTTPMethod,completion: @escaping ((URLRequest)->Void))
    func getUserAlbums(completion: @escaping ((Result<[SimpleAlbum],Error>)->Void))
}

//All the function which uses SpotifyAPI to retrieve user song/author information
final class APICaller {
    
    
    var userManager : UserManager!
    var authManager : AuthManagerProtocol!
    var currentUserProfile : UserProfile?
    var isLoading = true
    
    init(userManager: UserManager, authManager: AuthManagerProtocol) {
        self.userManager = userManager
        self.authManager = authManager
    }
    
    struct Constants{
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error{
        case failedToGetData
    }
    
    /*
    public func getAlbumsDetails(for album: Album, completion: @escaping ((Result<AlbumDetailsResponse,Error>)->Void)){
        createRequest(with: URL(string: "\(Constants.baseAPIURL)/albums/\(album.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }*/
    
    public func getUserAlbums(completion: @escaping ((Result<[SimpleAlbum],Error>)->Void)){
        createRequest(with: URL(string: "\(Constants.baseAPIURL)/me/albums"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    print("data problem")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    //print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(LibraryAlbumResponse.self, from: data) //o Album
                    completion(.success(result.items.compactMap({
                        $0.album
                    })))
                }catch{
                    print("\nError Albums")
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }

    public func getArtistRelatedArtists( for artistId: String , completion: @escaping ((Result<[Artist],Error>)->Void)){
        createRequest(with: URL(string: "\(Constants.baseAPIURL)/artists/\(artistId)/related-artists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    //print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(RelatedArtistResponse.self, from: data)
                    completion(.success(result.artists)) //LibraryArtistResponse è corretto con items o ha senso result.artists
                }catch{
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }

    public func getArtistTopTracks( for artist: Artist , completion: @escaping ((Result<[Track],Error>)->Void)){
        createRequest(with: URL(string: "\(Constants.baseAPIURL)/artists/\(artist.id)/top-tracks?market=IT"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    //print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(Tracks.self, from: data)
                    
                    completion(.success(result.tracks))
                    
                }catch{
                    print("Error: ArtistTopTracks not found")
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    public func getCurrentUserPlaylist(completion: @escaping ((Result<[Playlist],Error>)->Void)) {
        createRequest(with: URL(string: "\(Constants.baseAPIURL)/me/playlists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                   // print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
                    let filteredResult = result.items.filter { $0.owner.id == self.currentUserProfile?.id }
                    completion(.success(filteredResult))
                }catch{
                    print("\nError Playlist")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getPlaylistsTracks(for playlist: Playlist ,completion: @escaping ((Result<PlaylistTracks,Error>)->Void)) {
        createRequest(with: URL(string: "\(Constants.baseAPIURL)/playlists/\(playlist.id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    //print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(PlaylistTracks.self, from: data)
                    
                    completion(.success(result))
                }catch{
                    print("\nError Single Playlist")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getSavedTracks(completion: @escaping ((Result<[Track],Error>) ->Void)){
        let url = "\(Constants.baseAPIURL)/me/tracks"
        createRequest(with: URL(string: url), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, URLResponse , error in
                guard let data = data, error == nil else{
                    print("Failure to Get data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    //print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(LibrarySavedTrackResponse.self, from: data)
                    completion(.success(result.items.compactMap({
                        $0.track
                    })))
                }
                catch {
                    print("Error Fetch UserProfile, Saved Tracks \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getUserProfile(completion: @escaping ((Result<UserProfile,Error>) ->Void)) async throws {
        let url = "\(Constants.baseAPIURL)/me"
        createRequest(with: URL(string: url), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, URLResponse, error in
                guard let data = data, error == nil else{
                    print("Failure to Get data")
                    DispatchQueue.main.async {
                        completion(.failure(APIError.failedToGetData))
                    }
                    return
                }
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    self.currentUserProfile = result
                    let currentUser = result.mapWithUser()
                    
                    self.loadUserManager(currentUser: currentUser)
                    while(self.isLoading){
                        
                        }
                    self.isLoading = true
                    
                        completion(.success(result))
                    
                }
                catch {
                    print("Error Fetch UserProfile \(error.localizedDescription)")
                    completion(.failure(error))
                   
                }
            }
            task.resume()
        }
    }
    
    private func loadUserManager(currentUser: User ){
        Task {
            try await userManager.setUser(user: currentUser) { result in
                    switch result {
                        case .success(let boolean):
                            self.isLoading = boolean
                            break;
                        case .failure(let error):
                            print(error)
                            break;
                    }
                }
            }
    }
    
    public func getFollowedArtists(completion: @escaping ((Result<LibraryArtistResponse,Error>) ->Void)){
        let url = "\(Constants.baseAPIURL)/me/following?type=artist"
        createRequest(with: URL(string: url), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, URLResponse, error in
                guard let data = data, error == nil else{
                    print("Failure to Get data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(Artists.self, from: data)
                    completion(.success(result.artists))
                }
                catch {
                    print("Error Fetch UserProfile \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    public func getTopArtists(completion: @escaping ((Result<[Artist],Error>) ->Void)){
        let url = "\(Constants.baseAPIURL)/me/top/artists"
        createRequest(with: URL(string: url), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, URLResponse, error in
                guard let data = data, error == nil else{
                    print("Failure to Get data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }

                do{
                    let result = try JSONDecoder().decode(LibraryArtistResponse.self, from: data)
                    completion(.success(result.items))
                }
                catch {
                    print("Error Fetch UserProfile, Top Artists \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    public func getTopTracks(completion: @escaping ((Result<[Track],Error>) ->Void)){
        let url = "\(Constants.baseAPIURL)/me/top/tracks"
        createRequest(with: URL(string: url), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, URLResponse , error in
                guard let data = data, error == nil else{
                    print("Failure to Get data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    //print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(LibraryTrackResponse.self, from: data)
                    completion(.success(result.items))
                }
                catch {
                    print("Error Fetch UserProfile, Top Tracks \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }

    //Dovrebbe essere funzionante
    public func getTrack(for track: Track, completion: @escaping ((Result<Track,Error>) ->Void)){
        let url = "\(Constants.baseAPIURL)/me/tracks/\(track.id)"
        createRequest(with: URL(string: url), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, URLResponse, error in
                guard let data = data, error == nil else{
                    print("Failure to Get data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(Track.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print("Error Fetch UserProfile \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendation(songID: String,completion: @escaping ((Result<RecommendationsResponse, Error>)->Void)){
        //let seeds = songs.joined(separator: ",")
        createRequest(
            with: URL(string: "\(Constants.baseAPIURL)/recommendations?seed_tracks=\(songID)"),
            type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                }
                catch{
                    print("Error Fetch Recommendations \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
    
    
    private func createRequest(with url: URL?,type: HTTPMethod,completion: @escaping ((URLRequest)->Void)) {
        authManager.withValidToken { token in
            guard let apiURL = url else{
                print("Incorrect Url")
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            completion(request)
        }
    }
}

