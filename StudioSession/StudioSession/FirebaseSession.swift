

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

class FirebaseSession: ObservableObject {
    
    //MARK: Properties
    @Published var session: User?
    

    @Published var isLoggedIn: Bool = false
    var handle: AuthStateDidChangeListenerHandle?
    
    let db = Firestore.firestore()
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.isLoggedIn = true
                self.setUserData(id: user.uid) { res in
                    self.session = res
                }
            } else {
                self.isLoggedIn = false
                self.session = nil
            }
        }
    }
    func setUserData(id: String, completion: @escaping (_ sessions: User?) -> ()) {
        let docRef = db.collection("users").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                completion(User(displayName: data["username"] as? String, spotify: data["spotify"] as? String, apple_music: data["apple_music"] as? String, soundcloud: data["soundcloud"] as? String, youtube: data["youtube"] as? String, id: data["uid"] as? String, sessions: data["sessions"] as? [String], email: data["email"] as? String, friends: data["friends"] as? [String], pendingFriends: data["pendingFriends"] as? [String]))
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func logIn(email: String, password: String) {
        print(email)
//        var handler : AuthDataResultCallback?
        //Auth.auth().signIn(withEmail: email, password: password, completion: handler)
        
        Auth.auth().signIn(withEmail: email, password: password) { userInfo, error in
            if (error == nil && userInfo != nil) {
                //                session.id = userInfo?.user.uid
            }
        }
    }
    
    func logOut() {
        try! Auth.auth().signOut()
        self.isLoggedIn = false
        self.session = nil
        
    }
    
    func signUp(username: String, email: String, password: String, completion: @escaping (_ worked: Bool?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
        
    }
    func addUserToDB(username: String, id: String, email: String) {
        print("test")
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges { error in
            if let error = error {
                print("Error adding user: \(error)")
            } else {
                print("display changed")
            }
        }
        self.db.collection("users").document(id).setData([
            "uid": id,
            "username": username,
            "email": email,
            "spotify": "",
            "apple_music": "",
            "soundcloud": "",
            "youtube": "",
            "sessions": [],
            "friends": [],
            "pendingFriends": []
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    func chooseUsername(username: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges { error in
            if let error = error {
                print("Error making username: \(error)")
            } else {
                
            }
        }
        
    }
    
    func getSessions(completion: @escaping (_ sessions: [String]?) -> ()) {
        
    }
    func getSessionsByLoc(latitude: Double, longitude: Double, distance: Double, completion: @escaping (_ sessions: [Session]?) -> ()) {
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182
        
        let lowerLat = latitude - (lat * distance)
        let lowerLon = latitude - (lon * distance)
        
        let greaterLat = latitude + (lat * distance)
        let greaterLon = longitude + (lon * distance)
        
        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)
        let docRef = db.collection("sessions")
        docRef.whereField("location", isGreaterThan: lesserGeopoint)
            .whereField("location", isLessThan: greaterGeopoint)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                } else {
                    var sessions: [Session] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let date = (data["startDate"] as! Timestamp).dateValue()
                        let geo = (data["location"] as! GeoPoint)
                        let location = CLLocation(latitude: geo.latitude, longitude: geo.longitude)
                        let sesh = Session(id: data["id"] as? String, isPublic: data["isPublic"] as? Bool, name: data["name"] as? String, location: location, members: (data["members"] as? [String]), description: data["description"] as? String, startDate: date,course: data["course"] as? String, creator: data["creator"] as? String, pendingMembers: data["pendingMembers"] as? [String])
                        sessions.append(sesh)
                    }
                    completion(sessions)
                }
            }
    }
    func getSession(sessionId: String, completion: @escaping (_ sessions: Session?) -> ()) {
        let docRef = db.collection("sessions").document(sessionId)
        print(sessionId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                let date = (data["startDate"] as! Timestamp).dateValue()
                let geo = (data["location"] as! GeoPoint)
                let location = CLLocation(latitude: geo.latitude, longitude: geo.longitude)
                let sesh = Session(id: data["id"] as? String, isPublic: data["isPublic"] as? Bool, name: data["name"] as? String, location: location, members: data["members"] as? [String], description: data["description"] as? String, startDate: date, course: data["course"] as? String, creator: data["creator"] as? String, pendingMembers: data["pendingMembers"] as? [String])
                completion(sesh)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    func getUserSessions(user: String, completion: @escaping (_ sessions: [String]?) -> ()) {
        let docRef = db.collection("users").document(user)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let sessions = document.get("sessions") as! [String]
                completion(sessions)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    func getSessionMembers(sessionId: String, completion: @escaping (_ members: [String]?) -> ()) {
        let docRef = db.collection("sessions").document(sessionId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let members = document.get("members") as! [String]
                completion(members)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    func updateProfile(user: String, username: String, spotify: String, apple: String, youtube: String, soundcloud: String) {
        db.collection("users").document(user).updateData([
            "spotify": spotify,
            "apple_music": apple,
            "youtube": youtube,
            "soundcloud": soundcloud,
            "username": username
        ])
        self.setUserData(id: user) { res in
            self.session = res
        }
    }
    
    func isUniqueUsername(username: String, completion: @escaping (_ members: Bool?) -> ()) {
        db.collection("users").whereField("username", isEqualTo: username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                } else {
                    if ((querySnapshot?.documents.count)!>0) {
                        //TAKEN
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
        }
    }
    
    func updateUsername(user: String, username: String) {
        db.collection("users").document(user).updateData([
            "username": username
        ])
        self.setUserData(id: user) { res in
            self.session = res
        }
    }
    
    func getUserById(id: String, completion: @escaping((User?) -> ())){
        let docRef = db.collection("users").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                let user = User(displayName: data["username"] as? String, spotify: data["spotify"] as? String, apple_music: data["apple_music"] as? String, soundcloud: data["soundcloud"] as? String, youtube: data["youtube"] as? String, id: data["uid"] as? String, sessions: data["sessions"] as! [String]?, email: data["email"] as? String, friends: data["friends"] as? [String], pendingFriends: data["pendingFriends"] as? [String])
                completion(user)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    func uploadSession(name: String, description: String, isPublic: Bool, password: String, latitude: Double, longitude: Double, startDate: Date, course: String) {
        var ref: DocumentReference? = nil
        let point = GeoPoint(latitude: latitude, longitude: longitude)
        ref = db.collection("sessions").addDocument(data: [
            "name": name,
            "description": description,
            "isPublic": isPublic,
            "password": password,
            "createdAt": FieldValue.serverTimestamp(),
            "creator": session!.displayName,
            "members": [session!.id],
            "location": point,
            "startDate": startDate,
            "pendingMembers": [],
            "course": course
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        db.collection("sessions").document(ref!.documentID).updateData([
            "id": ref!.documentID
        ])
        // Atomically add a new region to the "regions" array field.
        print("underneath this")
        print(session!.id)
        db.collection("users").document(session!.id).updateData([
            "sessions": FieldValue.arrayUnion([ref!.documentID])
        ])
    }
    
    func joinSession(user: String, session: String) {
        db.collection("users").document(user).updateData([
            "sessions": FieldValue.arrayUnion([session])
        ])
        db.collection("sessions").document(session).updateData([
            "members": FieldValue.arrayUnion([user])
        ])
    }
    func checkSessionPassword(user: String, password: String, session: String, completion: @escaping((Bool?) -> ())){
        let docRef = db.collection("sessions").document(session)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let realPassword = document.get("password") as? String
                completion(realPassword==password)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    func unjoinSession(user: String, session: String) {
        db.collection("users").document(user).updateData([
            "sessions": FieldValue.arrayRemove([session])
        ])
        db.collection("sessions").document(session).updateData([
            "members": FieldValue.arrayRemove([user])
        ])
    }
    
    func requestFriend(fromId: String, toId: String) {
        db.collection("users").document(toId).updateData([
            "pendingFriends": FieldValue.arrayUnion([fromId])
        ])
        
    }
    
    func addFriend(fromId: String, toId: String) {
        db.collection("users").document(toId).updateData([
            "pendingFriends": FieldValue.arrayRemove([fromId]),
            "friends": FieldValue.arrayUnion([fromId]),
        ])
        db.collection("users").document(fromId).updateData([
            "friends": FieldValue.arrayUnion([toId]),
        ])
    }
    func denyFriend(fromId: String, toId: String) {
        db.collection("users").document(toId).updateData([
            "pendingFriends": FieldValue.arrayRemove([fromId]),
        ])
    }
    
    func requestAccess(userId: String, sessionId: String) {
        db.collection("sessions").document(sessionId).updateData([
            "pendingMembers": FieldValue.arrayUnion([userId])
        ])
    }
    
    func grantAccess(userId: String, sessionId: String) {
        db.collection("sessions").document(sessionId).updateData([
            "pendingMembers": FieldValue.arrayRemove([userId]),
        ])
        self.joinSession(user: userId, session: sessionId)
    }
    
    func denyAccess(userId: String, sessionId: String) {
        db.collection("sessions").document(sessionId).updateData([
            "pendingMembers": FieldValue.arrayRemove([userId]),
        ])
    }
    
    
}
