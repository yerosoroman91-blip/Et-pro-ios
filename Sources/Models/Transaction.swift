import Foundation

struct Transaction: Codable, Identifiable {
    let id: String
    let transactionType: TransactionType
    let amount: Double
    let currency: String
    let status: TransactionStatus
    let description: String
    let fromEntity: Entity
    let toEntity: Entity
    let timestamp: Date
    let signature: DigitalSignature?
    let witnesses: [Witness]
    let metadata: [String: String]
}

enum TransactionType: String, Codable {
    case bankTransfer = "Bank Transfer"
    case contractSigning = "Contract Signing"
    case licenseRenewal = "License Renewal"
    case shareTransfer = "Share Transfer"
    case documentSigning = "Document Signing"
}

enum TransactionStatus: String, Codable {
    case pending
    case processing
    case completed
    case failed
    case rejected
}

struct Entity: Codable {
    let entityID: String
    let entityName: String
    let entityType: EntityType
    let accountNumber: String?
}

enum EntityType: String, Codable {
    case individual
    case company
    case bank
    case government
}

struct DigitalSignature: Codable {
    let signatureID: String
    let signerFaydaID: String
    let signatureTimestamp: Date
    let cryptographicHash: String
    let signatureAlgorithm: String
    let certificateChain: [String]
    let nonRepudiationProof: String
}

struct Witness: Codable, Identifiable {
    let id: String
    let witnessName: String
    let faydaID: String
    let witnessTimestamp: Date
    let approval: Bool
}
