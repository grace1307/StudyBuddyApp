

import Foundation
import UIKit

class User: Identifiable, ObservableObject, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id==rhs.id
    }
    
    var id : String = ""
    var displayName: String = ""
    var email: String = ""
    var spotify: String =  ""
    var apple_music: String = ""
    var soundcloud: String = ""
    var youtube: String = ""
    var sessions: [String] = []
    var friends: [String] = []
    var pendingFriends: [String] = []
    
    init(displayName: String?, spotify: String?, apple_music: String?, soundcloud: String?,
         youtube: String?, id : String?, sessions: [String]?, email: String?, friends: [String]?, pendingFriends: [String]?) {
        self.email = email!
        self.displayName = displayName!
        self.spotify = spotify!
        self.apple_music = apple_music!
        self.soundcloud = soundcloud!
        self.youtube = youtube!
        self.id = id!
        self.sessions = sessions!
        self.friends = friends!
        self.pendingFriends = pendingFriends!
    }
    init(displayName: String?,id : String?) {
//        self.email = email!
        self.displayName = displayName!
        self.id = id!
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
