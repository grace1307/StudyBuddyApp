

import SwiftUI

struct FriendRowView: View {
    var body: some View {
        NavigationLink(destination: UserView(user: User(displayName: "temp", id: "temp"))) {
            HStack(alignment: .center ,spacing: 35) {
                Image(systemName: "person")
                    .font(.largeTitle)
                    .frame(width:60,height:60)
                    .background(Colors.buttonBackground)
                    .padding(.vertical, 10)
                    .foregroundColor(Colors.buttonText)
                VStack(spacing: 7) {
                    Text("username2")
                        .underline()
                        .bold()
                        .font(.headline)
                    Text("Producer")
                }
                VStack(spacing: 7) {
                    Text("2 Sessions Together")
                    Text("Friends since 09/24/20")
                }
            }
            .foregroundColor(.white)
        }
    }
}

struct FriendRowView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRowView()
    }
}
