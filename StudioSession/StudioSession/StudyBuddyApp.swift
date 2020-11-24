
import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct StudyBuddyApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        FirebaseApp.configure()

      }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(FirebaseSession())
        }
    }
}
