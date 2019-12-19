//
//  DataService.swift
//  iRis
//
//  Created by Sarvad shetty on 12/14/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation
import Firebase


struct Preferences: Codable {
    var DATABASE_URL:String
}

class DataService {
    static let dataService = DataService()
    
    var _BASE_REF:DatabaseReference {
        return Database.database().reference()
    }

    var USER_REF: DatabaseReference {
        return _BASE_REF.child("users")
    }

    var CURRENT_USER_REF: DatabaseReference {
        let userID = UserDefaults.standard.string(forKey: "uid") as! String
        let currUser = USER_REF.child(userID)
        return currUser
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, Any>) {
        
        // A User is born.
        USER_REF.child(uid).setValue(user)
    }
}
