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
    
    private let db = Firestore.firestore()
    private let usersCollection = Firestore.firestore().collection("users")
    
    private func userDocument(documentID: String) -> DocumentReference {
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
    
    func addUser (user: User) {
        
        do {
            let newDocReference = try usersCollection.addDocument(from: user)
            print("New user stored with new document reference: \(newDocReference)")
        }
        catch {
            print(error)
        }
    }

    
    func getUser(SpotifyID: String) async throws -> User {
        
        let users = try await usersCollection.whereField("SpotifyID", isEqualTo: SpotifyID).getDocuments(as: User.self)
        
        return users.first!
    }
    
    
//    func addFriend(currentUserSpotifyID: String, friendSpotifyID: String) {
//        let currentUser = try await getUser(SpotifyID: currentUserSpotifyID)
//        let friendRef = try await getUsergetUserFriends(currentUserSpotifyID: friendSpotifyID)
//
//        db.collection("users").document(currentUserRef).updateData(["friends" : FieldValue.arrayUnion([friendRef])])
//        { error in
//            if error == nil {
//                print("Document successfully updated")
//                self.getData()
//            } else {
//                print("Error updating document: \(String(describing: error))")
//            }
//        }
//    }
    
    func getUserFriends(currentUserSpotifyID: String) async throws -> [User] {
        let currentUser = try await getUser(SpotifyID: currentUserSpotifyID)
        var friends : [User] = []

        
        for documentID in currentUser.friends {
            friends.append(try await documentID.getDocument().data(as: User.self))
        }
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
