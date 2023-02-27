//
//  DatabaseManager.swift
//  Messenger
//
//  Created by JonathanTriC on 21/02/23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://messenger-ab83a-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    
}

//MARK: - Account Management
extension DatabaseManager {
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    /// Insert new user
    public func insertUser(with user: BincangAppUser, completion: @escaping(Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ]) { error, _ in
            guard error == nil else {
                print("Failed to write to database")
                completion(false)
                return
            }
            completion(true)
        }
    }
}

struct BincangAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        return safeEmail
    }
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
