

import SwiftUI

import Firebase
import FirebaseAuth
import FirebaseFirestore



struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var session: FirebaseSession
    
    @State private var loginState: Int? = 0
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack(alignment: .center) {
                Spacer()
                Text("Sign In Study Buddy!").font(.largeTitle).foregroundColor(.white)
                Spacer()
                Group {
                    TextField("Email", text: self.$email)
                        .textCase(.lowercase)
                    SecureField("Password", text: self.$password)
                }.frame(width: 200, height: nil)
                .padding(.all, 5)
                .background(Colors.formBackground)
                .cornerRadius(5)
                .multilineTextAlignment(.center)
                Spacer()
                HStack() {
                    Group {
                        Button(action: {loginCheck(email: email, password : password)}) {
                            HStack(alignment: .center) {
                                Spacer()
                                Text("Login").bold()
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
                
            
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        
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
        
    func loginCheck(email: String, password : String) {
        
        session.logIn(email : email, password : password)
        
        if (session.isLoggedIn) {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: FeedView().environmentObject(session))
                window.makeKeyAndVisible()
            }
        }
        
    }
   
}

