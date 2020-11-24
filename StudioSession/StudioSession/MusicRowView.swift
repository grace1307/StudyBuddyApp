

import SwiftUI

struct MusicRowView: View {
    var body: some View {
        Link(destination: URL(string: "https://www.spotify.com/us/")!) {
            HStack(alignment: .center ,spacing: 35) {
                Image(systemName: "music.note")
                    .font(.largeTitle)
                    .frame(width:60,height:60)
                    .background(Colors.buttonBackground)
                    .padding(.vertical, 10)
                    .foregroundColor(Colors.buttonText)
                VStack(alignment: .leading, spacing: 7) {
                    Text("Album Title - Song Title")
                        .underline()
                        .font(.headline)
                        .fontWeight(.bold)
                    HStack(spacing: 15) {
                        Text("Artist Name")
                        Text("Posted on 10/15/20")
                    }
                }
                VStack(spacing: 7) {
                    
                }
            }
            .foregroundColor(.white)
        }
    }
}

struct MusicRowView_Previews: PreviewProvider {
    static var previews: some View {
        MusicRowView()
    }
}
