

import SwiftUI

struct UserView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: FirebaseSession
    var user: User
    init(user: User) {
        self.user = user
    }
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack(alignment: .center) {
                Text(user.displayName)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text(user.email)
                    .font(.callout)
                    .italic()
                    .foregroundColor(.white)
                    .padding(.top, 5)

                Group {

                    NavigationLink(destination: SessionsView(user: user).environmentObject(session)) {
                        Text("Sessions")
                    }

                }.font(.title2)
                .frame(width: 150, height: 75)
                .background(Colors.buttonBackground)

                .padding(.vertical, 10)
                .foregroundColor(Colors.buttonText)
                
            Button(action: {
                session.requestFriend(fromId: session.session!.id, toId: user.id)
            }) {
                Text("Request Friend")
                    .frame(width: nil, height: 40)
                    .padding(3)
                    .background(Colors.buttonBackground)
            }

            }.foregroundColor(Colors.buttonText)

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

