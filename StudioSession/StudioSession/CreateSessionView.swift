

import SwiftUI

struct CreateSessionView: View {
    @EnvironmentObject var session: FirebaseSession
    
    @Binding var isPresented: Bool
    @State var description: String = ""
    @State var course: String = ""
    @State var name: String = ""
    @State private var isShowingAlert = false
    @State private var alertInput = ""
    @State var showingAlert = false
    @State var password: String = ""
    @State var startDate = Date()
    @State var endDate = Date()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Colors.backgroundGrey).ignoresSafeArea(edges: .all)
            VStack(alignment: .center, spacing: 25) {
                
                Text("Creating Study Room")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom,10)
                Group {
                    TextField("Name", text: self.$name)
                    TextField("Course", text: self.$course)
                    TextField("Description", text: self.$description)
                    
                    
                }.frame(width: 200, height: nil)
                .padding(.all, 5)
                .background(Colors.formBackground)
                .cornerRadius(5)
                .multilineTextAlignment(.center)
                HStack {
                    Text("Ends at:").foregroundColor(Color.white)
                    DatePicker("", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                        .frame(width: 200, height: nil)
                        .padding(.all, 5)
                        .background(Colors.formBackground)
                        .cornerRadius(5)
                }

                HStack() {
                    Group {
                        Button(action: {
                            if(name.isEmpty || course.isEmpty || description.isEmpty || course.isEmpty) {
                                showingAlert = true
                            } else {
                                session.uploadSession(name: self.name, description: self.description, isPublic: true, password: "", latitude: self.latitude, longitude: self.longitude, startDate: self.startDate, course: self.course)
                                self.isPresented.toggle()
                            }
                            
                        }) {
                            Text("Create Public")
                        }
                        Button(action: {
                            withAnimation {
                                self.isShowingAlert.toggle()
                            }
                            
                        }) {
                            Text("Create Private")
                        }
                    }.frame(width: 150, height: 40)
                    .background(Colors.buttonBackground)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 50)
                    .foregroundColor(Colors.buttonText)
                }
                if(isShowingAlert) {
                    ZStack {
                        VStack {
                            Text("Add a password")
                            TextField("", text: self.$password)
                            Divider()
                            HStack(spacing: 30) {
                                Button(action: {
                                    withAnimation {
                                        self.isShowingAlert.toggle()
                                    }
                                }) {
                                    Text("Cancel")
                                }
                                Button(action: {
                                    if(name.isEmpty || description.isEmpty || password.isEmpty || course.isEmpty) {
                                        showingAlert = true
                                    } else {
                                        session.uploadSession(name: self.name, description: self.description, isPublic: false, password: self.password,latitude: self.latitude, longitude: self.longitude, startDate: self.startDate, course: self.course)
                                        self.isPresented.toggle()
                                        withAnimation {
                                            self.isShowingAlert.toggle()
                                        }
                                    }
                                   
                                    
                                }) {
                                    Text("Create Study Room")
                                }
                            }
                        }
                        .padding()
                        .frame(width: 250, height: 125)
                        .background(Colors.buttonBackground)
                        .foregroundColor(Colors.buttonText)
                    }
                }
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Unable to Create Study Room"), message: Text("Please fill out all fields"), dismissButton: .default(Text("Got it!")))
    }
}

struct TextFieldAlert<Presenting>: View where Presenting: View {
    
    @Binding var isShowing: Bool
    @Binding var password: String
    @Binding var added: Bool
    let presenting: Presenting
    let title: String
    
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(self.title)
                    TextField("", text: self.$password)
                    Divider()
                    HStack(spacing: 30) {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Cancel")
                        }
                        Button(action: {
                            self.added = true
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Create Study Room")
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
    
}

}
