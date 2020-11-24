

import SwiftUI

struct SessionRowView: View {
    var sesh: Session
    @ObservedObject var lm = LocationManager()
    var latitude: Double  { return Double("\(lm.location?.latitude ?? 0.0)") ?? 0.0 }
    var longitude: Double { return Double("\(lm.location?.longitude ?? 0.0)") ?? 0.0 }
    init(sesh: Session) {
        self.sesh = sesh
    }
    var body: some View {
        NavigationLink(destination:  {
            VStack {
                    PublicSessionView(sesh: sesh)
            }
                        }()
        ) {
            HStack(alignment: .center ,spacing: 35) {
                Image(systemName: "books.vertical")
                    .font(.largeTitle)
                    .frame(width:60,height:60)
                    .background(Colors.buttonBackground)
                    .padding(.vertical, 10)
                    .foregroundColor(Colors.buttonText)
                VStack(alignment: .leading,spacing: 7) {
                    Text(sesh.name).frame(alignment: .leading)
                    if(sesh.isPublic) {
                        Text("Public").italic()
                    } else {
                        Text("Private").italic()
                    }
                    
                }
                VStack(alignment: .leading,spacing: 7) {
                    Text(sesh.shortdateDisplay()).frame(alignment: .leading)
                    
                    Text("Course: "+sesh.course)
                    
//                    Text("\(sesh.milesAway(lat: latitude, long: longitude), specifier: "%.2f") mi away")
                }
            }
            .foregroundColor(.white)
        }
    }
}


