

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack() {
                Spacer()
                Text("Study Buddy").font(.largeTitle).foregroundColor(.white)
                Spacer()
                Group{
                HStack() {
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .bold()
                            .multilineTextAlignment(.center)
                            .frame(width: 150, height: 75).background(Colors.buttonBackground)
                    }
                    Spacer()
                    NavigationLink(destination: SignUpView()) {
                        Text("Create an Account")
                            .bold()
                            .multilineTextAlignment(.center)
                            .frame(width: 150, height: 75).background(Colors.buttonBackground)
                    }
                }
                    
                }
                
                .padding(.horizontal, 50)
                .foregroundColor(Colors.buttonText)
                Spacer()
            }
        }
        }
    }
}


