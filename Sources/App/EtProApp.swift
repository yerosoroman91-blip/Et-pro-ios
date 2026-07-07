import SwiftUI

@main
struct EtProApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                if authViewModel.userRole == .citizen {
                    PersonalProfileView()
                        .environmentObject(authViewModel)
                        .environmentObject(appState)
                } else {
                    CorporateHubView()
                        .environmentObject(authViewModel)
                        .environmentObject(appState)
                }
            } else {
                AuthenticationView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var currentCompany: Company?
    @Published var documents: [Document] = []
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
}
