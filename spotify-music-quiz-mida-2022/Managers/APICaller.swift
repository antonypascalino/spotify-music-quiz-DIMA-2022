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
    
    public func getUserAlbums(completion: @escaping ((Result<[Album],Error>)->Void)){
        createRequest(with: URL(string: "\(Constants.baseAPIURL)/me/albums"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    print(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
                    let result = try JSONDecoder().decode(LibraryAlbumResponse.self, from: data) //o Album
                    completion(.success(result.items.compactMap({
                        $0.album
                    })))
                }catch{
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
                    let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data) // o Playlist
                    completion(.success(result.items))
                }catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    public func getUserProfile(completion: @escaping ((Result<UserProfile,Error>) ->Void)){
        let url = "\(Constants.baseAPIURL)/me"
        createRequest(with: URL(string: url), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else{
                    print("Failure to Get data")
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                }
                catch {
                    print("Error Fetch UserProfile \(error.localizedDescription)")
                    print("\nDATA: \(data)")
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

