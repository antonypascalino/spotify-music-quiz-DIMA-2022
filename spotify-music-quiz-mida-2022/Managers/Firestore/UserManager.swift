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
    
    func addUser (user: User) async throws {
        
        let users = try await usersCollection.whereField("SpotifyID", isEqualTo: user.SpotifyID).getDocuments(as: User.self)
        
        if (users.isEmpty) {
            do {
                let newDocReference = try usersCollection.addDocument(from: user)
                print("New user stored with new document reference: \(newDocReference)")
            }
            catch {
                print(error)
            }
        } else {
            try usersCollection.document((users.first?.id)!).setData(from: user, mergeFields: ["image", "email", "SpotifyID"])
        }
        
        
    }

    
    func getUser(SpotifyID: String) async throws -> User {
        
        let users = try await usersCollection.whereField("SpotifyID", isEqualTo: SpotifyID).getDocuments(as: User.self)
        
        print (users)
        
        return users.first!
    }
    
    func getUserHighscore(SpotifyID: String) async throws -> Int {
        
        let users = try await usersCollection.whereField("SpotifyID", isEqualTo: SpotifyID).getDocuments(as: User.self)
        if (users.isEmpty) {
            return 0
        } else {
            return users.first!.highscore
        }
    }
    
    func setUserHighscore(SpotifyID: String, newHighscore: Int) async throws {
        let currentUser =  try await getUser(SpotifyID: SpotifyID)
        let currentUserReference = try await userDocument(documentID: currentUser.id!)
        
        currentUserReference.updateData(["highscore" : newHighscore]) { error in
            if let error = error {
                print("Error updating highscore field: \(error.localizedDescription)")
            } else {
                print("Highscore updated successfully.")
            }
        }
    }
    
    func searchUsers(name: String) async throws -> [User] {
        
        let nameLowerCase = name.lowercased()
        let nameUpperCase = name.prefix(1).uppercased() + name.dropFirst()
        
        var users = try await usersCollection.whereField("display_name", isGreaterThanOrEqualTo: nameLowerCase).getDocuments(as: User.self)
        users.append(contentsOf: try await usersCollection.whereField("display_name", isGreaterThanOrEqualTo: nameUpperCase).getDocuments(as: User.self))
        
        print(users)
        return users
    }
    
    
    func addFriend(currentUserSpotifyID: String, newFriendSpotifyID: String) async throws {
        
        let currentUser =  try await getUser(SpotifyID: currentUserSpotifyID)
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
    
    func getUserFriends(currentUserSpotifyID: String) async throws -> [User] {
        
        let currentUser = try await getUser(SpotifyID: currentUserSpotifyID)
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
