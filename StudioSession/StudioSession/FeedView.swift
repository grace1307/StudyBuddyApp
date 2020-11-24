

import SwiftUI

struct FeedView: View {
    @ObservedObject var lm = LocationManager()
    var latitude: Double  { return Double("\(lm.location?.latitude ?? 0.0)") ?? 0.0 }
    var longitude: Double { return Double("\(lm.location?.longitude ?? 0.0)") ?? 0.0 }
    @State private var showFilter: Bool = false
    @State private var isShowingAlert = false
    
    @State private var showLogin: Bool = false
    @State var sessions: [Session] = []
    @State var pendingFriends: [User] = []
    @EnvironmentObject var session: FirebaseSession
    
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
                
                VStack(alignment: .center) {
                    HStack() {
                        NavigationLink(destination: ProfileView().environmentObject(session)) {
                            Image(systemName: "person")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(15)
                        }
                    }

                    Text("Nearby Study Rooms")
                        .underline()
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                        .padding(.bottom,10)
                    
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(sessions) { sesh in
                                SessionRowView(sesh: sesh)
                            }.padding(10)
                        }
                    }
                    Spacer()
                    HStack() {
                        Group {
                            Button(action: {
                                self.showFilter = true
                            }) {
                                Text("Create Study Room")
                            }
                        }.frame(width: 150, height: 40)
                        .background(Colors.buttonBackground)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 50)
                        .foregroundColor(Colors.buttonText)
                    }
                    
                }
            }.onAppear {
                session.getSessionsByLoc(latitude: latitude, longitude: longitude, distance: 10, completion: { nearbySessions in
                    sessions = nearbySessions ?? []
                })
                pendingFriends = []
                if((session.session) != nil) {
                    for friendID in session.session!.pendingFriends {
                        session.getUserById(id: friendID) { res in
                            pendingFriends.append(res!)
                        }
                    }
                }
                
            }
            .navigationBarHidden(true)
            .sheet(isPresented: self.$showFilter) {
                CreateSessionView(isPresented: self.$showFilter, latitude: latitude, longitude: longitude).environmentObject(session)
            }
        }
    }

    
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
