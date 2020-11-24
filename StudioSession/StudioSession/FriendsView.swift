

import SwiftUI

struct FriendsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: FirebaseSession
    @State var friends: [User] = []
    var user: User
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack(alignment: .center) {
                Text("\(user.displayName) Friends")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom,10)
                ScrollView(.vertical) {
                    VStack(spacing: 5) {
                        ForEach(friends) {friend in
                            NavigationLink(destination:  {
                                VStack {
                                    if(friend.id==session.session!.id) {
                                        ProfileView().environmentObject(session)
                                    } else {
                                        UserView(user: friend).environmentObject(session)
                                    }
                                }
                                            }()
                            ) {
                            Text("\(friend.displayName) - \(friend.email)")
                                .foregroundColor(Colors.buttonText)
                                .frame(width: 200)
                            }
                        }.padding(.top,10)
                    }
                }.padding(.leading,5)
                .frame(height: 300)
                .background(Colors.buttonBackground)

            Spacer()
                
            }.onAppear {
                friends = []
                for friendID in user.friends {
                    session.getUserById(id: friendID) { res in
                        friends.append(res!)
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
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
}

