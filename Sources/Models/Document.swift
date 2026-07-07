import Foundation

struct Document: Codable, Identifiable {
    let id: String
    let documentType: DocumentType
    let documentNumber: String
    let issuedDate: Date
    let expiryDate: Date?
    let issuerName: String
    let documentURL: URL
    let thumbnailURL: URL?
    let isVerified: Bool
    let verificationDate: Date?
    let encryptionHash: String
    let createdAt: Date
}

enum DocumentType: String, Codable {
    case nationalID = "National ID"
    case passport = "Passport"
    case driverLicense = "Driver's License"
    case businessLicense = "Business License"
    case tradeLicense = "Trade License"
    case educationCertificate = "Education Certificate"
    case medicalCertificate = "Medical Certificate"
    case marriageCertificate = "Marriage Certificate"
    case birthCertificate = "Birth Certificate"
    case other = "Other"
}

struct DocumentVerificationResult: Codable {
    let isValid: Bool
    let verificationMethod: VerificationMethod
    let verificationDate: Date
    let expiryStatus: ExpiryStatus
}

enum VerificationMethod: String, Codable {
    case faydaBiometric = "Fayda Biometric Match"
    case documentCheck = "Document Check"
    case issuerVerification = "Issuer Verification"
}

enum ExpiryStatus: String, Codable {
    case valid
    case expiring
    case expired
}
