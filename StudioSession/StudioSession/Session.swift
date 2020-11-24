

import Foundation
import UIKit
import CoreLocation

class Session: Identifiable {
    static func == (lhs: Session, rhs: Session) -> Bool {
        return lhs.id==rhs.id
    }
    
    var id: String = ""
    var name: String = ""
    var open: Bool = false
    var isPublic: Bool
    var location = CLLocation()
    var userEmail: String = ""
    var members: [String] = []
//    var genre: String = ""
    var description: String = ""
    var startDate = Date()
    var creator: String = ""
    var pendingMembers: [String] = []
    var course: String = ""
    
    init(id : String?, isPublic : Bool?) {
        self.id = id!
        self.isPublic = isPublic!
    }
    init(id : String?, isPublic : Bool?, name: String?, location: CLLocation?, members: [String]?, description: String?, startDate: Date?, course: String?, creator: String?, pendingMembers: [String]?) {
        self.id = id!
        self.isPublic = isPublic!
        self.name = name!
        self.location = location!
        self.members = members!
//        self.genre = genre!
        self.description = description!
        self.startDate = startDate!
        self.course = course!
        self.creator = creator!
        self.pendingMembers = pendingMembers!
    }
    
    func shortdateDisplay()-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self.startDate)
    }
    func longdateDisplay()-> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self.startDate)
    }
    func milesAway(lat: Double, long: Double)-> Double {
        let userLoc = CLLocation(latitude: lat, longitude: long)

        let distanceInMiles = userLoc.distance(from: self.location)/1609.34 // result is in meters
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return distanceInMiles
    }
}
