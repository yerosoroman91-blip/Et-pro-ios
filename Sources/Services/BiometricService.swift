import LocalAuthentication
import Foundation

class BiometricService {
    private let context = LAContext()
    
    func isBiometricAvailable() -> Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func getBiometricType() -> BiometricType {
        guard isBiometricAvailable() else { return .none }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .faceID:
                return .faceID
            case .touchID:
                return .touchID
            case .none:
                return .none
            @unknown default:
                return .none
            }
        }
        return .none
    }
    
    func authenticate(
        reason: String = "Authenticate to access ET-PRO",
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard isBiometricAvailable() else {
            completion(false, BiometricError.notAvailable)
            return
        }
        
        let context = LAContext()
        context.localizedFallbackTitle = "Use PIN"
        
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, error)
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    completion(false, error ?? BiometricError.authenticationFailed)
                }
            }
        }
    }
}

enum BiometricType {
    case faceID
    case touchID
    case none
}

enum BiometricError: LocalizedError {
    case notAvailable
    case authenticationFailed
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Biometric authentication is not available on this device"
        case .authenticationFailed:
            return "Biometric authentication failed"
        }
    }
}
