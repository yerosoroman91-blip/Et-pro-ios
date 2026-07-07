import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var userRole: UserRole = .citizen
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var faydaID = ""
    @Published var pin = ""
    @Published var twoFactorCode = ""
    @Published var showTwoFactorInput = false
    @Published var biometricEnabled = false
    
    private let authService = AuthenticationService()
    private let biometricService = BiometricService()
    private let keychainService = KeychainService()
    
    var canSubmitFaydaLogin: Bool {
        !faydaID.isEmpty && !pin.isEmpty && faydaID.count == 16
    }
    
    var canSubmit2FA: Bool {
        twoFactorCode.count == 6
    }
    
    func loginWithFayda() {
        isLoading = true
        errorMessage = nil
        
        authService.authenticateWithFayda(faydaID: faydaID, pin: pin) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if success {
                    self?.showTwoFactorInput = true
                } else {
                    self?.errorMessage = error?.localizedDescription ?? "Authentication failed"
                }
            }
        }
    }
    
    func verify2FA() {
        isLoading = true
        errorMessage = nil
        
        authService.verifyWith2FA(faydaID: faydaID, code: twoFactorCode) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if success {
                    self?.currentUser = self?.authService.currentUser
                    self?.isAuthenticated = true
                    self?.showTwoFactorInput = false
                    self?.resetLoginForm()
                } else {
                    self?.errorMessage = error?.localizedDescription ?? "2FA verification failed"
                }
            }
        }
    }
    
    func loginWithBiometric() {
        isLoading = true
        errorMessage = nil
        
        biometricService.authenticate { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if success {
                    self?.authService.authenticateWithBiometric { success, error in
                        DispatchQueue.main.async {
                            if success {
                                self?.currentUser = self?.authService.currentUser
                                self?.isAuthenticated = true
                            } else {
                                self?.errorMessage = "Failed to load user profile"
                            }
                        }
                    }
                } else {
                    self?.errorMessage = error?.localizedDescription ?? "Biometric authentication failed"
                }
            }
        }
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
        authService.logout()
        resetLoginForm()
    }
    
    func isBiometricAvailable() -> Bool {
        biometricService.isBiometricAvailable()
    }
    
    func getBiometricType() -> BiometricType {
        biometricService.getBiometricType()
    }
    
    private func resetLoginForm() {
        faydaID = ""
        pin = ""
        twoFactorCode = ""
        showTwoFactorInput = false
    }
}
