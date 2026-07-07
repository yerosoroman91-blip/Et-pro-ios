import Foundation

struct Company: Codable, Identifiable {
    let id: String
    let registrationNumber: String
    let companyName: String
    let companyType: CompanyType
    let registrationDate: Date
    let taxID: String
    let businessLicense: String
    let headquartersAddress: String
    let city: String
    let region: String
    let phone: String
    let email: String
    let website: URL?
    let directors: [Director]
    let shareholders: [Shareholder]
    let bankAccounts: [BankAccount]
    let tradePermits: [TradePermit]
    let complianceStatus: ComplianceStatus
    let createdAt: Date
    let updatedAt: Date
}

enum CompanyType: String, Codable {
    case plc = "PLC"
    case proprietorship = "Proprietorship"
    case partnership = "Partnership"
    case cooperative = "Cooperative"
}

struct Director: Codable, Identifiable {
    let id: String
    let name: String
    let role: String
    let faydaID: String
    let signatureAuthority: Bool
}

struct Shareholder: Codable, Identifiable {
    let id: String
    let name: String
    let shareholderType: ShareholderType
    let percentage: Double
}

enum ShareholderType: String, Codable {
    case individual
    case corporate
}

struct BankAccount: Codable, Identifiable {
    let id: String
    let bankName: String
    let accountNumber: String
    let accountType: String
    let currency: String
    let balance: Double
}

struct TradePermit: Codable, Identifiable {
    let id: String
    let permitType: String
    let issuedDate: Date
    let expiryDate: Date
    let status: PermitStatus
}

enum PermitStatus: String, Codable {
    case active
    case expired
    case pending
    case suspended
}

struct ComplianceStatus: Codable {
    let taxCompliant: Bool
    let lastAuditDate: Date?
    let auditStatus: String
    let regulatoryStatus: String
    let certifications: [String]
}
