

import SwiftUI

struct PublicSessionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: FirebaseSession
    @ObservedObject var lm = LocationManager()
    var latitude: Double  { return Double("\(lm.location?.latitude ?? 0.0)") ?? 0.0 }
    var longitude: Double { return Double("\(lm.location?.longitude ?? 0.0)") ?? 0.0 }
    var sesh: Session
    @State var users: [User] = []
    @State var pendingUsers: [User] = []
    @State private var isShowingAlert = false
    @State var password: String = ""
    @State var passwordPromptShowing: Bool = false
    @State var showingAlert = false
    @State var requestsShowing = false
    

    init(sesh: Session) {
        self.sesh = sesh
    }
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            
            VStack(alignment: .center) {
                if(requestsShowing) {
                    requestsView
                }
                Text(sesh.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Created by \(sesh.creator)")
                    .font(.callout)
                    .italic()
                    .foregroundColor(.white)
                    .padding(.top, 5)
                Text("\(sesh.milesAway(lat: latitude, long: longitude), specifier: "%.2f") mi away")
                    .font(.callout)
                    .italic()
                    .foregroundColor(.white)
                    .padding(.top, 5)
                Text(sesh.longdateDisplay())
                    .font(.callout)
                    .italic()
                    .foregroundColor(.white)
                    .padding(.top, 5)
//                Text("Genres: " + sesh.genre)
//                    .font(.callout)
//                    .italic()
//                    .foregroundColor(.white)
//                    .padding(.top, 5)
                Text(sesh.description)
                    .font(.callout)
                    .italic()
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .multilineTextAlignment(.center)
                
                    VStack {
                        HStack() {
                            Text("Current Members:")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,30)
                                .padding(.leading, 5)
                            Spacer()
                        }
                        ScrollView(.vertical) {
                            VStack(spacing: 5) {
                                ForEach(users) {user in
                                    NavigationLink(destination:  {
                                        VStack {
                                            if(user.id==session.session!.id) {
                                                ProfileView().environmentObject(session)
                                            } else {
                                                UserView(user: user).environmentObject(session)
                                            }
                                        }
                                                    }()
                                    ) {
                                    Text("\(user.displayName) - \(user.email)")
                                        .foregroundColor(Colors.buttonText)
                                        .frame(width: 200)
                                    }
                                }.padding(.top,10)
                            }
                        }.padding(.leading,5)
                        .frame(height: 150)
                        .background(Colors.buttonBackground)
                    }

                Spacer()
                if(sesh.isPublic) {
                    publicButtons()
                } else {
                    if(users.contains(where: { $0.displayName == session.session!.displayName })) {
                        Button(action:  {
                            session.unjoinSession(user: session.session!.id, session: sesh.id)
                            users.remove(at: users.firstIndex(of: session.session!)!)
                        }){
                            Text("Leave.").fontWeight(.bold)
                                .font(.title)
                                .frame(width: 100, height: 100)
                                .padding(3)
                                .background(Colors.buttonBackground)
                                .foregroundColor(Colors.buttonText)
                        }
                    } else {
                        privateButtons()
                        if(passwordPromptShowing) {
                            passwordPrompt()
                        }
                    }
                }
                
            }.onAppear {
                users = []
                for memberID in sesh.members {
                    session.getUserById(id: memberID) { res in
                        users.append(res!)
                    }
                }
                pendingUsers = []
                for memberID in sesh.pendingMembers {
                    session.getUserById(id: memberID) { res in
                        pendingUsers.append(res!)
                    }
                }
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Unable to join session"), message: Text("Incorrect Password"), dismissButton: .default(Text("Got it!")))
            }
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: isCreator() ? AnyView(requestsButton) : AnyView(EmptyView()))
    }
    
    func isCreator() -> Bool {
        return ((sesh.creator == session.session?.displayName) && !sesh.isPublic)
    }
    
    func passwordPrompt() -> some View {
        ZStack {
            VStack {
                Text("Password")
                TextField("", text: self.$password)
                Divider()
                HStack(spacing: 30) {
                    Button(action: {
                        withAnimation {
                            self.passwordPromptShowing.toggle()
                        }
                    }) {
                        Text("Cancel")
                    }
                    Button(action: {
                        session.checkSessionPassword(user: session.session!.id, password: self.password, session: sesh.id, completion: { res in
                            if(res!) {
                                session.joinSession(user: session.session!.id, session: sesh.id)
                                users.append(session.session!)
                                withAnimation {
                                    self.passwordPromptShowing.toggle()
                                }
                            } else {
                                self.showingAlert.toggle()
                            }
                        })
                            
                            
                       
                    }) {
                        Text("Join Session")
                    }
                }
            }
            .padding()
            .frame(width: 250, height: 125)
            .background(Colors.buttonBackground)
            //.cornerRadius(5)
            .foregroundColor(Colors.buttonText)
        }
    }
    func privateButtons() -> some View {
        HStack {
            Button(action: {
                if(!pendingUsers.contains(where: { $0.displayName == session.session!.displayName })) {
                    session.requestAccess(userId: session.session!.id, sessionId: sesh.id)
                    pendingUsers.append(session.session!)
                }
            }) {
                if(pendingUsers.contains(where: { $0.displayName == session.session!.displayName })) {
                    Text("Access Pending.").fontWeight(.bold)
                        .font(.headline)
                        .frame(width: 100, height: 100)
                        .padding(3)
                        .background(Colors.buttonBackground)
                        .foregroundColor(Colors.buttonText)
                } else {
                    Text("Request Access!").fontWeight(.bold)
                        .font(.headline)
                        .frame(width: 100, height: 100)
                        .padding(3)
                        .background(Colors.buttonBackground)
                        .foregroundColor(Colors.buttonText)
                }
            }
            Text("OR").font(.title).foregroundColor(Color.white)
            Button(action: {
                passwordPromptShowing.toggle()
            }) {
                Text("Join with Password").fontWeight(.bold)
                    .font(.headline)
                    .frame(width: 100, height: 100)
                    .padding(3)
                    .background(Colors.buttonBackground)
                    .foregroundColor(Colors.buttonText)
            }
            
            
        }
    }
    
    func publicButtons() -> some View {
        Button(action: {
            if(users.contains(where: { $0.displayName == session.session!.displayName })) {
                session.unjoinSession(user: session.session!.id, session: sesh.id)
                //self.presentationMode.wrappedValue.dismiss()
                users.remove(at: users.firstIndex(of: session.session!)!)
            } else {
                session.joinSession(user: session.session!.id, session: sesh.id)
                users.append(session.session!)

            }
        }) {
            if(users.contains(where: { $0.displayName == session.session!.displayName })) {
                Text("Leave.").fontWeight(.bold)
                    .font(.title)
                    .frame(width: 100, height: 100)
                    .padding(3)
                    .background(Colors.buttonBackground)
                    .foregroundColor(Colors.buttonText)
            } else {
                Text("Join!").fontWeight(.bold)
                        .font(.title)
                        .frame(width: 100, height: 100)
                        .padding(3)
                        .background(Colors.buttonBackground)
                        .foregroundColor(Colors.buttonText)
            }
            
                
        }
    }
    
    var backButton : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
                    Text("Back")
                }.font(.title3)
                .foregroundColor(.white)
            }
        }
    var requestsButton : some View {
        HStack {
            Button(action: {
            withAnimation {
                self.requestsShowing.toggle()
            }
            }) {
            Text("\(pendingUsers.count) Requests to Join")
            }
        }.font(.title3)
        .foregroundColor(.white)
        .padding(15)
    }
    var requestsView : some View {
        HStack {
            Spacer()
            ZStack {
                VStack {
                    ScrollView(.vertical) {
                        VStack(spacing: 5) {
                            ForEach(pendingUsers) {user in
                                HStack {
                                    Text("\(user.displayName)")
                                        .foregroundColor(Colors.buttonText)
                                        .frame(width: 200)
                                    Button(action: {
                                        session.grantAccess(userId: user.id, sessionId: sesh.id)
                                        pendingUsers.remove(at: pendingUsers.firstIndex(of: user)!)
                                        users.append(user)
                                    }) {
                                        Image(systemName: "checkmark").foregroundColor(Color.green)
                                    }
                                    Button(action: {
                                        session.denyAccess(userId: user.id, sessionId: sesh.id)
                                        pendingUsers.remove(at: pendingUsers.firstIndex(of: user)!)
                                    }) {
                                        Image(systemName: "xmark").foregroundColor(Color.red)
                                    }
                                }
                                
                            }.padding(.top,10)
                        }
                    }
                    Divider()
                    HStack(spacing: 30) {
                        Button(action: {
                            withAnimation {
                                self.requestsShowing.toggle()
                            }
                        }) {
                            Text("Hide")
                        }
                    }
                }
                .padding()
                .frame(width: 250, height: 150)
                .background(Colors.buttonBackground)
                .cornerRadius(10)
                .foregroundColor(Colors.buttonText)
            }
            
        }.padding(.trailing, 5)
    }
}


