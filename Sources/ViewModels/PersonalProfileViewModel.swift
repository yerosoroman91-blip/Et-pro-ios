import SwiftUI
import Combine

class PersonalProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var documents: [Document] = []
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedDocument: Document?
    @Published var showDocumentScanner = false
    @Published var showQRScanner = false
    
    private let networkService = NetworkService()
    private let cryptographyService = CryptographyService()
    
    func fetchUserDocuments(for faydaID: String) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
        }
    }
    
    func addDocument(_ document: Document) {
        documents.append(document)
    }
}
