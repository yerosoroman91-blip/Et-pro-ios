# ET-PRO iOS Application

## National Digital Identity Gateway & Corporate Wallet for Ethiopia

### Project Overview

ET-PRO is a comprehensive iOS application implementing Ethiopia's national digital identity and electronic signature platform, modeled after the UAE PASS framework.

## Features

### 🔐 Authentication & Security
- Fayda ID-based login with PIN protection
- Two-Factor Authentication (2FA) via SMS
- Biometric authentication (Face ID/Touch ID)
- Secure Keychain storage
- ECDSA cryptographic signing
- SHA-256 hashing for data integrity

### 👤 Module A: Personal Profile (Citizen Wallet)
- User profile management
- Digital document locker
- Document verification
- Activity history
- QR code data sharing
- Financial onboarding

### 🏢 Module B: Corporate Hub (Enterprise)
- Business registration management
- Director and shareholder management
- Trade permit tracking
- Corporate signing matrix
- Multi-signature authorization
- Compliance dashboard
- Real-time business license monitoring

### 🔗 Partner Integrations
- Fayda ID (National ID registry)
- Ethio Telecom (SIM binding & 2FA)
- National Bank of Ethiopia (KYC)
- Ministry of Trade & Integration
- Ethiopian Vital Registration & Immigration
- NISS (Security compliance)

## Technical Architecture

### Technology Stack
- **Framework**: SwiftUI + Combine
- **Architecture**: MVVM (Model-View-ViewModel)
- **Storage**: Keychain + UserDefaults
- **Networking**: URLSession
- **Cryptography**: CryptoKit (ECDSA, SHA-256)
- **Biometrics**: LocalAuthentication
- **Minimum iOS**: 14.0

### Project Structure

```
Sources/
├── App/
│   └── EtProApp.swift
├── Models/
│   ├── User.swift
│   ├── Company.swift
│   ├── Document.swift
│   └── Transaction.swift
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── PersonalProfileViewModel.swift
│   └── CorporateViewModel.swift
├── Views/
│   ├── Authentication/
│   │   └── AuthenticationView.swift
│   ├── PersonalProfile/
│   │   └── PersonalProfileView.swift
│   └── CorporateHub/
│       └── CorporateHubView.swift
└── Services/
    ├── AuthenticationService.swift
    ├── BiometricService.swift
    ├── KeychainService.swift
    ├── NetworkService.swift
    └── CryptographyService.swift
```

## Security Features

### Authentication Hierarchy
1. **Local Device Layer**: Biometric + PIN via Secure Enclave
2. **Network Layer**: 2FA via Ethio Telecom
3. **Central Biometric Layer**: Fayda live facial recognition for high-value actions

### Non-Repudiation
Every transaction generates a cryptographically sealed token:
```
Token = ECDSA-Sign(
  TransactionID + Timestamp + FaydaID,
  PrivateKey
)
```

### Data Protection
- AES-256 encryption for sensitive data
- ECDSA P-256 for digital signatures
- SHA-256 for data hashing
- TLS 1.3 for network communication
- Certificate pinning enabled

## Installation & Setup

### Prerequisites
- Xcode 14.0+
- iOS 14.0+
- Swift 5.5+

### Build & Run

```bash
# Clone the repository
git clone https://github.com/yerosoroman91-blip/Et-pro-ios.git
cd Et-pro-ios

# Open in Xcode
open Et-pro-ios.xcodeproj

# Build
xcodebuild build -scheme Et-pro-ios

# Run on simulator
xcodebuild test -scheme Et-pro-ios -sdk iphonesimulator
```

## API Endpoints

### Base URL
```
https://api.et-pro.gov.et/v1
```

### Authentication
- `POST /auth/request-2fa` - Request 2FA code
- `POST /auth/verify-2fa` - Verify 2FA code

### User Profile
- `GET /fayda/profile/{faydaID}` - Fetch user profile
- `POST /fayda/verify/biometric` - Verify biometric

### Company
- `GET /company/profile/{registrationNumber}` - Fetch company details
- `POST /company/register` - Register new company

### Documents
- `POST /documents/verify` - Verify document
- `GET /documents/{documentID}` - Fetch document

## Usage Guide

### Authentication Flow
1. Select login method (Fayda ID or Biometric)
2. Enter 16-digit Fayda ID and PIN
3. Receive 2FA code via SMS
4. Enter 6-digit code to complete authentication

### Personal Profile
1. View profile information
2. Access digital documents
3. View activity history
4. Share documents via QR code

### Corporate Hub
1. View company overview
2. Manage directors and shareholders
3. Track trade permits
4. Review pending approvals
5. Check compliance status

## Development Guidelines

### Code Style
- Follow Swift style guidelines
- Use MVVM architecture
- Implement comprehensive error handling
- Add inline documentation

### Security Best Practices
- Never hardcode credentials
- Use Keychain for sensitive data
- Implement certificate pinning
- Validate all user inputs
- Log security events

## Testing

```bash
# Run unit tests
xcodebuild test -scheme Et-pro-ios

# Run with coverage
xcodebuild test -scheme Et-pro-ios -enableCodeCoverage YES
```

## Known Limitations

- Requires active internet connection (except for cached data)
- Biometric authentication only on supported devices
- Max 50 documents in local storage
- 2FA timeout: 10 minutes

## Future Enhancements

- [ ] Offline mode with QR-based verification
- [ ] Widget support
- [ ] iCloud synchronization
- [ ] Push notifications
- [ ] Document scanning with OCR
- [ ] Advanced compliance reporting
- [ ] Multi-language support

## Support & Troubleshooting

### Build Issues
- Clean build: `Cmd+Shift+K`
- Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
- Reset simulator: `xcrun simctl erase all`

### Runtime Issues
- Check internet connection
- Verify credentials
- Update to latest iOS version
- Check Xcode console for error logs

## License

Confidential - National Project

## Contact

For inquiries: contact@et-pro.gov.et

## Contributors

- Development Team
- Security Team
- Architecture Team

---

**Last Updated**: July 2026
**Status**: Production Ready
