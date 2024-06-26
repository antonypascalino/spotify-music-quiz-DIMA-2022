//
//  UserManager.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 29/03/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


//Class which calls Firebase function to store and retrive data from the server
class UserManager {
    
    private(set) var currentUser = User(id: "", display_name: "", email: "", friends: [DocumentReference](), SpotifyID: "", image: "")
    private var currentUserReference : DocumentReference?
    private let db = Firestore.firestore()
    private let usersCollection = Firestore.firestore().collection("users")
    private let authorsCollection = Firestore.firestore().collection("authors")
    
    private func userDocument(documentID: String) async throws -> DocumentReference {
        usersCollection.document(documentID)
    }
    
    private func authorDocument(documentID: String) async throws -> DocumentReference {
        authorsCollection.document(documentID)
    }
    
    func getAllUsers() async throws -> [User] {
        let snapshot = try await usersCollection.getDocuments()
        var users : [User] = []
        
        for document in snapshot.documents {
            let user = try document.data(as: User.self)
            users.append(user)
        }
        return users
    }
    
    //On user log in updates their data on the server or create a new user if does not exist yet
    func setUser (user: User, completion: @escaping ((Result<Bool,Error>) ->Void)) async throws {
        
        let users = try await usersCollection.whereField("SpotifyID", isEqualTo: user.SpotifyID).getDocuments(as: User.self)
    
        if (users.isEmpty) {
            do {
                let newDocReference = try usersCollection.addDocument(from: user)
                print("New user stored with new document reference: \(newDocReference)")
                self.currentUser = try await newDocReference.getDocument(as: User.self)
                self.currentUserReference = try await userDocument(documentID: currentUser.id!)
            }
            catch {
                print(error)
                completion(.failure(error))
            }
        } else {
            try await userDocument(documentID: (users.first?.id)!).setData(from: user, mergeFields: ["image", "email", "SpotifyID"])
            self.currentUser = try await userDocument(documentID: (users.first?.id)!).getDocument(as: User.self)
            self.currentUserReference = try await userDocument(documentID: currentUser.id!)
//            print("CURRENT USER FROM FIREBASE: \(self.currentUser.display_name)")
        }
        completion(.success(false))
    }

    func getUser(SpotifyID: String) async throws -> User {
        
        let users = try await usersCollection.whereField("SpotifyID", isEqualTo: SpotifyID).getDocuments(as: User.self)
//        print (users)
        
        return users.first!
    }
    
    func getUserHighscores() async throws -> [String : Int]  {
        let currentUserReference = try await userDocument(documentID: currentUser.id!)
        let highscores = try await currentUserReference.getDocument(as: User.self).highscores ?? [String : Int]()

//        print("current user highscores: \(highscores) ")
        return highscores
        
    }
    
    func setUserHighscore(mode: String, newHighscore: Int) async throws {
        
        let userHighscores = try await getUserHighscores()
        
        try await currentUserReference!.setData(["highscores" : [mode : newHighscore]], merge: true)
        self.currentUser = try await userDocument(documentID: currentUser.id!).getDocument(as: User.self)
    }
    
    
    func addFriend(newFriendSpotifyID: String) async throws {
        
        let newFriend = try await getUser(SpotifyID: newFriendSpotifyID)
        let newFriendReference = try await userDocument(documentID: newFriend.id!)
        
        try await currentUserReference!.updateData(["friends" : FieldValue.arrayUnion([newFriendReference])]) { error in
            if let error = error {
                print("Error updating Friends array: \(error.localizedDescription)")
            } else {
                print("New friend added successfully.")
            }
        }
        self.currentUser = try await userDocument(documentID: currentUser.id!).getDocument(as: User.self)
//        print("CURRENT USER FRIENDS: \(currentUser.friends)")
    }
    
    func getUserFriends() async throws -> [User] {
        
        var friends : [User] = []

        for documentID in currentUser.friends {
            friends.append(try await documentID.getDocument().data(as: User.self))
        }
        
        print(friends)
        return friends
    }
    
    //Increments the score of an author for a user
    func setUserAuthorScore(author: String) async throws {
        
        let userAuthors = try await getUserAuthorsScore()
        let authorScore = userAuthors[author] ?? 0
        let newScore = authorScore + 1
        
        try await currentUserReference!.setData(["authors" : [author : newScore]], merge: true)

        self.currentUser = try await userDocument(documentID: currentUser.id!).getDocument(as: User.self)
    }
    
    //Get for each author the score of the user for that author
    func getUserAuthorsScore() async throws -> [String : Int] {
        let currentUserReference = try await userDocument(documentID: currentUser.id!)
        
        let authors = try await currentUserReference.getDocument(as: User.self).authors ?? [String : Int]()
        return authors
    }
    
    //Each time an user faces a question with an author, store the author's name and their SpotifyID for future retrieve
    func addAuthor(artist: String, artistId: String ) async throws {
        let authorToAdd: [String: Any] = [
            "name": artist,
            "id": artistId
        ]

        let authors = try await authorsCollection.whereField("id", isEqualTo: artistId).getDocuments()
        
        if (authors.isEmpty) {
                let newDocReference = try await authorsCollection.addDocument(data: authorToAdd)
                print("New artist stored with new document reference: \(newDocReference)")
            
        }
    }
    
    //Gets the SpotifyID of the 5 authors the user knows bettere based on their score
    func getTopAuthorsId() async throws -> [String]  {
        let dictionary = try await getUserAuthorsScore()
        let sortedDictionary = dictionary.sorted { $0.value > $1.value }
        let topArtistsNames = sortedDictionary.prefix(5).map { $0.key }
        var authorsID = [String]()

        for artist in topArtistsNames {
            let artistFromDB = try await authorsCollection.whereField("name", isEqualTo: artist).getDocuments(as: Artist.self).first!
            authorsID.append(artistFromDB.id)
        }
        return authorsID
    }
    
}

extension Query {
    func getDocuments<T>(as tvpe: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
    }
}
