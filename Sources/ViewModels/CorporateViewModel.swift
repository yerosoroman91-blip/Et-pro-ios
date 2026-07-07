import SwiftUI
import Combine

class CorporateViewModel: ObservableObject {
    @Published var company: Company?
    @Published var employees: [Director] = []
    @Published var tradePermits: [TradePermit] = []
    @Published var pendingApprovals: [Transaction] = []
    @Published var complianceStatus: ComplianceStatus?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkService = NetworkService()
    private let cryptographyService = CryptographyService()
    
    func fetchCompanyProfile(registrationNumber: String) {
        isLoading = true
        networkService.fetchCompanyProfile(registrationNumber: registrationNumber) { [weak self] company, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let company = company {
                    self?.company = company
                    self?.employees = company.directors
                    self?.tradePermits = company.tradePermits
                    self?.complianceStatus = company.complianceStatus
                } else {
                    self?.errorMessage = error?.localizedDescription ?? "Failed to fetch company"
                }
            }
        }
    }
}
