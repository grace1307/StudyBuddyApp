
import SwiftUI

struct MusicView: View {
    @Environment(\.presentationMode) var musicMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack(alignment: .center) {
                Text("Username1 Music")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom,10)
                HStack(spacing: 40) {
                    Link(destination: URL(string: "https://www.spotify.com/us/")!,label: {
                        Image("Spotify_Icon_RGB_Green")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                    Link(destination: URL(string: "https://music.apple.com/us/browse")!,label: {
                        Image("Apple_Music_Icon_RGB_sm_073120")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                    Link(destination: URL(string: "https://music.youtube.com/")!,label: {
                        Image("yt_icon_rgb")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                    Link(destination: URL(string: "https://soundcloud.com/")!,label: {
                        Image("soundcloud_icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                        
                }
                Text("Featured")
                    .underline()
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .padding(.bottom,10)
                MusicRowView()
                MusicRowView()
                MusicRowView()
                MusicRowView()
                Spacer()
                HStack() {
                    Group {
                        Button(action: {
                        }) {
                            Text("Upload Music")
                        }
                    }.frame(width: 150, height: 40)
                    .background(Colors.buttonBackground)
                //.cornerRadius(5)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)
                    .foregroundColor(Colors.buttonText)
                }
                
            }
        }.navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    var backButton : some View { Button(action: {
            self.musicMode.wrappedValue.dismiss()
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

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
    }
}
