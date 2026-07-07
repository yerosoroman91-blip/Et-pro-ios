import Foundation
import CryptoKit

class AuthenticationService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    private let keychainService = KeychainService()
    private let biometricService = BiometricService()
    private let networkService = NetworkService()
    private let cryptographyService = CryptographyService()
    
    func authenticateWithFayda(
        faydaID: String,
        pin: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard let storedPin = keychainService.retrieve(key: "user_pin_\(faydaID)") else {
            errorMessage = "PIN not found. Please register first."
            completion(false, AuthenticationError.pinNotFound)
            return
        }
        
        let hashedPin = hashPin(pin)
        guard hashedPin == storedPin else {
            errorMessage = "Invalid PIN."
            completion(false, AuthenticationError.invalidPin)
            return
        }
        
        request2FACode(faydaID: faydaID) { [weak self] success, error in
            if success {
                completion(true, nil)
            } else {
                self?.errorMessage = "Failed to send 2FA code"
                completion(false, error)
            }
        }
    }
    
    func verifyWith2FA(
        faydaID: String,
        code: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        networkService.verify2FACode(
            faydaID: faydaID,
            code: code
        ) { [weak self] success, error in
            if success {
                self?.fetchUserProfileFromFayda(faydaID: faydaID, completion: completion)
            } else {
                self?.errorMessage = "Invalid 2FA code"
                completion(false, error)
            }
        }
    }
    
    func authenticateWithBiometric(completion: @escaping (Bool, Error?) -> Void) {
        biometricService.authenticate { [weak self] success, error in
            if success {
                if let userJSON = self?.keychainService.retrieve(key: "current_user"),
                   let data = userJSON.data(using: .utf8),
                   let user = try? JSONDecoder().decode(User.self, from: data) {
                    self?.currentUser = user
                    self?.isAuthenticated = true
                    completion(true, nil)
                }
            } else {
                self?.errorMessage = "Biometric authentication failed"
                completion(false, error)
            }
        }
    }
    
    private func request2FACode(faydaID: String, completion: @escaping (Bool, Error?) -> Void) {
        networkService.request2FACode(faydaID: faydaID, completion: completion)
    }
    
    private func fetchUserProfileFromFayda(
        faydaID: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        networkService.fetchUserProfile(faydaID: faydaID) { [weak self] user, error in
            if let user = user {
                self?.currentUser = user
                self?.isAuthenticated = true
                
                if let encoded = try? JSONEncoder().encode(user),
                   let jsonString = String(data: encoded, encoding: .utf8) {
                    self?.keychainService.save(key: "current_user", value: jsonString)
                }
                
                completion(true, nil)
            } else {
                self?.errorMessage = "Failed to fetch user profile"
                completion(false, error)
            }
        }
    }
    
    private func hashPin(_ pin: String) -> String {
        let data = Data(pin.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
        keychainService.delete(key: "current_user")
    }
}

enum AuthenticationError: LocalizedError {
    case pinNotFound
    case invalidPin
    case invalidFaydaID
    case biometricFailed
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .pinNotFound:
            return "PIN not found in Keychain"
        case .invalidPin:
            return "The PIN you entered is incorrect"
        case .invalidFaydaID:
            return "Invalid Fayda ID"
        case .biometricFailed:
            return "Biometric authentication failed"
        case .networkError:
            return "Network error occurred"
        }
    }
}
