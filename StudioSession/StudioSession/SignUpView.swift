

import SwiftUI

import Firebase
import FirebaseAuth
import FirebaseFirestore



struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let db = Firestore.firestore()
    @State var email: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var showingAlert = false
    @State var uniqueUsername = true
    var alertPhrase: String = "Username taken"
    @EnvironmentObject var session: FirebaseSession
    
    @State private var loginState: Int? = 0
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack(alignment: .center) {
                Spacer()
                Text("Study Buddy").font(.largeTitle).foregroundColor(.white)
                Spacer()
                Group {
                    TextField("Username", text: self.$username)
                    TextField("Email", text: self.$email)
                    SecureField("Password", text: self.$password)
                }.frame(width: 200, height: nil)
                .padding(.all, 5)
                .background(Colors.formBackground)
                .cornerRadius(5)
                .multilineTextAlignment(.center)
                Spacer()
                HStack() {
                    Group {
                        Button(action: {registerCheck(username: username, email: email, password : password)}) {
                            HStack(alignment: .center) {
                                Spacer()
                                Text("Register").bold()
                                Spacer()
                            }
                        }
                    }.frame(width: 100, height: 50)
                    .background(Colors.buttonBackground)
                    //.cornerRadius(5)
                    .padding(.horizontal, 50)
                    .foregroundColor(Colors.buttonText)
                }
                Spacer()
                
            }
            
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Unable to register"), message: Text(self.alertPhrase), dismissButton: .default(Text("Got it!")))
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
    func registerCheck(username: String, email: String, password : String) {
        
        // Create a query against the collection.
        session.isUniqueUsername(username: username) { res in
            if(res!) {
                session.signUp(username: username, email : email, password : password) { res in
                    if(res!) {
                        session.addUserToDB(username: username, id: Auth.auth().currentUser!.uid, email: email)
                    }
                }
            } else {
                showingAlert = true
            }
        }

        if (session.isLoggedIn) {
            do {
                sleep(2)
            }
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: FeedView().environmentObject(session))
                window.makeKeyAndVisible()
            }
        }
        
    }
        

    
}


//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
