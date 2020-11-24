
import SwiftUI

struct SessionsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var session: FirebaseSession
    @State var sessions: [Session] = []
    var user: User
    init(user: User) {
        self.user = user
    }

    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack(alignment: .leading) {
                Text("\(user.displayName)'s Study Rooms")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom,10)
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(sessions) { sesh in
                                SessionRowView(sesh: sesh)
                            }.padding(10)
                        }
                    }
                Spacer()
            }
        }.onAppear {
            sessions = []
            session.getUserSessions(user: user.id) { res in
                for sesh in res! {
                    session.getSession(sessionId: sesh) { data in
                        sessions.append(data!)
                    }
                }
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
}

