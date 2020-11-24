

import SwiftUI

struct EditMusic: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var session: FirebaseSession
    @State var spotify: String = ""
    @State var apple: String = ""
    @State var soundcloud: String = ""
    @State var youtube: String = ""
    @State var username: String = ""
    @State var showingAlert = false
    @State var alertMessage: String = ""

    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
//        _spotify = State(wrappedValue: session.session?.spotify ?? "")
//        _apple = State(wrappedValue: session.session?.apple_music ?? "")
//        _soundcloud = State(wrappedValue: session.session?.soundcloud ?? "")
//        _youtube = State(wrappedValue: session.session?.youtube ?? "")

    }
    var body: some View {
        NavigationView {
            
        
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack(alignment: .center) {
                Text("Editing Profile")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Group {
                    VStack(spacing: 20) {
                        VStack {
                        Text("Username:")
                            .foregroundColor(Color.white)
                        TextField("Username:", text: $username)
                            .padding(.all, 5)
                            .background(Colors.buttonBackground)
                            .cornerRadius(5)
                        }
                        VStack {
                        Text("Spotify:")
                            .foregroundColor(Color.white)
                        TextField("Spotify:", text: $spotify)
                            .padding(.all, 5)
                            .background(Colors.buttonBackground)
                            .cornerRadius(5)
                        }
                        VStack {
                        Text("Apple Music:")
                            .foregroundColor(Color.white)
                        TextField("Apple Music", text: $apple)
                            .padding(.all, 5)
                            .background(Colors.buttonBackground)
                            .cornerRadius(5)
                        }
                        VStack {
                        Text("Soundcloud:")
                            .foregroundColor(Color.white)
                        TextField("Soundcloud", text: $soundcloud)
                            .padding(.all, 5)
                            .background(Colors.buttonBackground)
                            .cornerRadius(5)
                        }
                        VStack {
                        Text("Youtube:")
                            .foregroundColor(Color.white)
                        TextField("Youtube", text: $youtube)
                            .padding(.all, 5)
                            .background(Colors.buttonBackground)
                            .cornerRadius(5)
                        }
                    }.padding(.top, 30)
                    Spacer()
                }.font(.headline).frame(width: 300, height: nil)
                
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Unable to edit profile"), message: Text(self.alertMessage), dismissButton: .default(Text("Got it!")))
        }
        .navigationBarItems(leading: cancel, trailing: done)
        }.onAppear {
            onAppear()
        }
    }
    var cancel: some View {
        Button(action: {
            self.isPresented = false
        }) {
            Text("Cancel")
                .font(.title3)
                .foregroundColor(.white)
        }
    }
    var done: some View {
        Button(action: {
            session.isUniqueUsername(username: username) { res in
                if(res! || username==session.session!.displayName) {
                    if(checkURLs()) {
                        session.updateProfile(user: session.session!.id, username: username, spotify: spotify, apple: apple, youtube: youtube, soundcloud: soundcloud)
                        self.isPresented = false
                    }
                    else {
                        self.alertMessage = "Make sure all links are valid"
                        self.showingAlert.toggle()
                    }
                } else {
                    self.alertMessage = "Username is taken"
                    self.showingAlert.toggle()
                }
            }
                
                
            
            
        }) {
            Text("Done")
                .font(.title3)
                .foregroundColor(.white)
        }}
    
    func onAppear() {
        self.username = session.session?.displayName ?? ""
        self.spotify = session.session?.spotify ?? ""
        self.apple = session.session?.apple_music ?? ""
        self.soundcloud = session.session?.soundcloud ?? ""
        self.youtube = session.session?.youtube ?? ""
    }
    func checkURLs () -> Bool {
        return ((verifyUrl(urlString: self.spotify)||self.spotify.isEmpty) &&
                    (verifyUrl(urlString: self.apple)||self.apple.isEmpty) &&
                (verifyUrl(urlString: self.soundcloud)||self.soundcloud.isEmpty) &&
                (verifyUrl(urlString: self.youtube)||self.youtube.isEmpty) )
    }
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}


