import Foundation


final class APICaller{
    static let shared = APICaller()
    
    private init() {}
    
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
    
    //Dovrebbe funzionare
    public func getUserAlbums(completion: @escaping ((Result<[Album],Error>)->Void)){
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

    //Da verificare altrimenti cambiare con le cose commentate in completion
    public func getArtistRelatedArtists( for artist: Artist , completion: @escaping ((Result<[Artist],Error>)->Void)){
        createRequest(with: URL(string: "\(Constants.baseAPIURL)/artists/\(artist.id)/related-artists"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    //print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(RelatedArtistResponse.self, from: data) //Potrebbe non funzionare perchè prende items e non artists
                    completion(.success(result.artists)) //LibraryArtistResponse è corretto con items o ha senso result.artists
                }catch{
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }

    //Da verificare altrimenti cambiare con le cose commentate in completion
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
    
    
    //Dovrebbe essere funzionante
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
                    completion(.success(result.items))
                }catch{
                    print("\nError Playlist")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    //Funziona
    public func getUserProfile(completion: @escaping ((Result<UserProfile,Error>) ->Void)){
        let url = "\(Constants.baseAPIURL)/me"
        createRequest(with: URL(string: url), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, URLResponse, error in
                guard let data = data, error == nil else{
                    print("Failure to Get data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
//                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments )
                    print("RESULT: \(result) ")
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
    
    //Forse non funziona, per ora non viene utilizzata -> bisogna recuperare l'array di Artists
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

    //Dovrebbe essere funzionante
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

    //Dovrebbe essere funzionante
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
    
    //NON UTILIZZATA : DA VERIFICARE IL FUNZIONAMENTO
    public func getRecommendation(songs: Set<String>,completion: @escaping ((Result<RecommendationsResponse, Error>)->Void)){
        let seeds = songs.joined(separator: ",")
        createRequest(
            with: URL(string: "\(Constants.baseAPIURL)/recommendations?limit=3&seed_tracks=\(seeds)"),
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
    
    enum HTTPMethod: String{
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    private func createRequest(with url: URL?,type: HTTPMethod,completion: @escaping ((URLRequest)->Void)) {
        AuthManager.shared.withValidToken { token in
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

