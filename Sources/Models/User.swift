import Foundation

struct User: Codable, Identifiable {
    let id: String
    let faydaID: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let dateOfBirth: Date
    let nationality: String
    let address: String
    let city: String
    let region: String
    let zipCode: String
    let profilePhotoURL: URL?
    let passportNumber: String?
    let driverLicenseNumber: String?
    let createdAt: Date
    let updatedAt: Date
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

struct UserCredentials: Codable {
    let faydaID: String
    let pin: String
    let biometricEnabled: Bool
}

enum UserRole {
    case citizen
    case corporate
    case both
}
