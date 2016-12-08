//
//  User.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 10/1/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import Foundation
import RealmSwift

final class User: Object {
    
    //MARK: Properties
    
    dynamic var pantherId = ""
    dynamic var email = ""
    dynamic var fullName = ""
    
    dynamic var favoriteStations = 0
    dynamic var pendingStations = 0
    dynamic var completedStations = 0
    
    let quizzesTaken = LinkingObjects(fromType: Quiz.self, property: "student")
    
    override static func indexedProperties() -> [String] {
        return ["pantherId", "email"]
        
    }
    
    override static func primaryKey() -> String? {
        return "email"
    }
    
    override var description: String {
        return debugDescription
    }

}

extension User {
    
    override var debugDescription: String {
        var output: [String] = []
        
        output.append("Panther id: \(pantherId)")
        output.append("Full name: \(fullName)")
        output.append("Email: \(email)")
        return output.joinWithSeparator("\n")
    }
    
    func markStationWith(status: StationReview) {
        
        switch status {
        case .Completed:
            do {
                try realm?.write({
                    completedStations += 1
                })
            } catch {
                print("could not update")
            }
            break
        case .Favorite:
            do {
                try realm?.write({
                    favoriteStations += 1
                })
            } catch {
                print("could not update")
            }
            break
        case .Pending:
            do {
                try realm?.write({
                    pendingStations += 1
                })
            } catch {
                print("could not update")
            }
            break
        }
        
    }
    
    func infoForStationWith(status: StationReview) -> ProgressTileInformationViewModelType {
        
        var info: ProgressInfoViewModel
        
        switch status {
        case .Completed:
            info = ProgressInfoViewModel(title: NSLocalizedString("Marked as Completed", comment: ""),
                                         count: completedStations)
            break
        case .Favorite:
            info = ProgressInfoViewModel(title: NSLocalizedString("Marked as Favorite", comment: ""),
                                         count: favoriteStations)
            break
        case .Pending:
            info = ProgressInfoViewModel(title: NSLocalizedString("Marked as Pending", comment: ""),
                                         count: pendingStations)
            break
        }
        
        return info
    }
    
}


extension User {
    
    static func createUser(forUser user: GIDGoogleUser, withPantherId id: String, completion: () -> ()) {
        
        let _user = User()
        _user.email = user.profile.email
        _user.fullName = user.profile.name
        _user.pantherId = id
        
        let realm = try! Realm()
        
        do {
            try realm.write{
                realm.add(_user)
            }
            completion()
        } catch let error as NSError {
            print("user save error: \(error.localizedDescription)")
        }
        
    }
    
    static func findUserWithPrimaryKey(email email: String) -> User? {
        
        let realm = try! Realm()
        
        return realm.objectForPrimaryKey(User.self, key: email)
    }
    
    static func currentUser() -> User? {
        
        let realm = try! Realm()
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        guard let currentUserEmail = standardDefaults.valueForKey("currentUserEmail") else {
            return nil
        }
        return realm.objectForPrimaryKey(User.self, key: currentUserEmail)
    }
    
    func fullname() -> String {
        return fullName ?? "No full name"
    }
}

private struct ProgressInfoViewModel: ProgressTileInformationViewModelType {
    
    var title = ""
    var count = 0
    
}