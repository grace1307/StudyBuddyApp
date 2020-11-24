
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: FirebaseSession
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack(alignment: .center) {
                Text(session.session?.displayName ?? "")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text(session.session?.email ?? "")
                    .font(.callout)
                    .italic()
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                Group {
                    NavigationLink(destination: SessionsView(user: session.session ?? User(displayName: "", id: "")).environmentObject(session)) {
                        Text("Study Rooms")
                    }
                    
                    NavigationLink(destination: FriendsView(user: session.session ?? User(displayName: "", id: "")).environmentObject(session)) {
                        Text("Friends")
                    }
                }.font(.title2)
                .frame(width: 150, height: 75)
                .background(Colors.buttonBackground)
                
            .padding(.vertical, 10)
                .foregroundColor(Colors.buttonText)
                Spacer()
                HStack() {
                    Group {
                        Button(action: {goToLogin()}) {
                            HStack(alignment: .center) {
                                Spacer()
                                Text("Logout")
                                Spacer()
                            }
                        }
                    }.frame(width: 150, height: 40)
                    .background(Colors.buttonBackground)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                    .foregroundColor(Colors.buttonText)
                }
                Spacer()
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
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
    func goToLogin() {
        //go back to home
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: ContentView().environmentObject(FirebaseSession()))
            window.makeKeyAndVisible()
        }
        
        session.logOut()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
