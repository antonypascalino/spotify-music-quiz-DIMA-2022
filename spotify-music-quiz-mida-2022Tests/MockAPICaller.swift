//
//  MockAuthManager.swift
//  spotify-music-quiz-mida-2022Tests
//
//  Created by Antony Pascalino on 26/06/23.
//

import Foundation
@testable import spotify_music_quiz_mida_2022



final class MockAPICaller:  APICallerProtocol, Mockable {
    
    struct Constants{
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    func getUserAlbums(completion: @escaping ((Result<[SimpleAlbum],Error>)->Void)){
        createRequest(with: URL(string: "\(Constants.baseAPIURL)/me/albums"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    print("data problem")
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
    func createRequest(with url: URL?,type: spotify_music_quiz_mida_2022.HTTPMethod,completion: @escaping ((URLRequest)->Void))
        {
            var token = "NgCXRKc...MzYjw";
        var request = URLRequest(url: url!)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            completion(request)
        }
    
}
    


