import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    Text("ET-PRO")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.blue)
                    
                    Text("National Digital Identity Gateway")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 40)
                
                Picker("Login Method", selection: $selectedTab) {
                    Text("Fayda ID").tag(0)
                    if authViewModel.isBiometricAvailable() {
                        Text("Biometric").tag(1)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == 0 {
                    FaydaLoginView()
                        .environmentObject(authViewModel)
                } else {
                    BiometricLoginView()
                        .environmentObject(authViewModel)
                }
                
                Spacer()
            }
            
            if authViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
            }
            
            if let error = authViewModel.errorMessage {
                VStack {
                    Text("Error")
                        .font(.headline)
                    Text(error)
                        .font(.body)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                .padding()
            }
        }
    }
}

struct FaydaLoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Fayda ID")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("Enter your 16-digit Fayda ID", text: $authViewModel.faydaID)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("PIN")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                SecureField("Enter your PIN", text: $authViewModel.pin)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            
            Button(action: {
                authViewModel.loginWithFayda()
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(authViewModel.canSubmitFaydaLogin ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!authViewModel.canSubmitFaydaLogin)
            .padding(.horizontal)
            
            if authViewModel.showTwoFactorInput {
                TwoFactorView()
                    .environmentObject(authViewModel)
                    .padding()
            }
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

struct BiometricLoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: authViewModel.getBiometricType() == .faceID ? "faceid" : "touchid")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Biometric Authentication")
                    .font(.headline)
                
                Text("Use your fingerprint or face to securely authenticate")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding()
            
            Button(action: {
                authViewModel.loginWithBiometric()
            }) {
                Text("Authenticate")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

struct TwoFactorView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Two-Factor Authentication")
                .font(.headline)
            
            Text("Enter the 6-digit code sent to your phone")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("000000", text: $authViewModel.twoFactorCode)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .tracking(2)
                .font(.system(size: 20))
            
            Button(action: {
                authViewModel.verify2FA()
            }) {
                Text("Verify")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(authViewModel.canSubmit2FA ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!authViewModel.canSubmit2FA)
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthViewModel())
}
