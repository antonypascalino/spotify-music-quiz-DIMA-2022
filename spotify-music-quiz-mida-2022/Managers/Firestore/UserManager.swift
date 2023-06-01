//
//  UserManager.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 29/03/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



class UserManager {
    
//    @Published var users = [User]()
    
    static let shared = UserManager()
    
    private(set) var currentUser = User(id: "", display_name: "", email: "", friends: [DocumentReference](), highscore: 0, SpotifyID: "", image: "")
    
    private let db = Firestore.firestore()
    private let usersCollection = Firestore.firestore().collection("users")
    
    private func userDocument(documentID: String) async throws -> DocumentReference {
        usersCollection.document(documentID)
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
    
    func setUser (user: User, completion: @escaping ((Result<Bool,Error>) ->Void)) async throws {
        
        let users = try await usersCollection.whereField("SpotifyID", isEqualTo: user.SpotifyID).getDocuments(as: User.self)
    
        if (users.isEmpty) {
            do {
                let newDocReference = try usersCollection.addDocument(from: user)
                print("New user stored with new document reference: \(newDocReference)")
                self.currentUser = try await newDocReference.getDocument(as: User.self)
            }
            catch {
                print(error)
                completion(.failure(error))
            }
        } else {
            try await userDocument(documentID: (users.first?.id)!).setData(from: user, mergeFields: ["image", "email", "SpotifyID"])
            self.currentUser = try await userDocument(documentID: (users.first?.id)!).getDocument(as: User.self)
            print("CURRENT USER FROM FIREBASE: \(self.currentUser.display_name)")
        }
        completion(.success(false))
    }

    
    func getUser(SpotifyID: String) async throws -> User {
        
        let users = try await usersCollection.whereField("SpotifyID", isEqualTo: SpotifyID).getDocuments(as: User.self)
        
        print (users)
        
        return users.first!
    }
    
    func getUserHighscore() async throws -> Int {
        
        let users = try await usersCollection.whereField("SpotifyID", isEqualTo: currentUser.SpotifyID).getDocuments(as: User.self)
        if (users.isEmpty) {
            return 0
        } else {
            return users.first!.highscore
        }
    }
    
    func setUserHighscore(newHighscore: Int) async throws {
        let currentUserReference = try await userDocument(documentID: currentUser.id!)
        
        currentUserReference.updateData(["highscore" : newHighscore]) { error in
            if let error = error {
                print("Error updating highscore field: \(error.localizedDescription)")
            } else {
                print("Highscore updated successfully.")
            }
        }
    }
    
//    func searchUsers(name: String) async throws -> [User] {
//
//        let nameLowerCase = name.lowercased()
//        let nameUpperCase = name.prefix(1).uppercased() + name.dropFirst()
//
//        var users = try await usersCollection.whereField("display_name", isGreaterThanOrEqualTo: nameLowerCase).getDocuments(as: User.self)
//        users.append(contentsOf: try await usersCollection.whereField("display_name", isGreaterThanOrEqualTo: nameUpperCase).getDocuments(as: User.self))
//
//        print(users)
//        return users
//    }
    
    
    func addFriend(newFriendSpotifyID: String) async throws {
        
        let newFriend = try await getUser(SpotifyID: newFriendSpotifyID)
        let currentUserReference = try await userDocument(documentID: currentUser.id!)
        let newFriendReference = try await userDocument(documentID: newFriend.id!)
        
        currentUserReference.updateData(["friends" : FieldValue.arrayUnion([newFriendReference])]) { error in
            if let error = error {
                print("Error updating Friends array: \(error.localizedDescription)")
            } else {
                print("New friend added successfully.")
            }
        }
    }
    
    func getUserFriends() async throws -> [User] {
        
        print("CURRENT USER FROM USERMANAGER: \(currentUser)")
        
        var friends : [User] = []

        for documentID in currentUser.friends {
            friends.append(try await documentID.getDocument().data(as: User.self))
        }
        
        print(friends)
        return friends
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
