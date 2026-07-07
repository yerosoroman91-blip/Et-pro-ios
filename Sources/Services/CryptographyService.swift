import Foundation
import CryptoKit

class CryptographyService {
    
    func createDigitalSignature(
        for data: Data,
        using privateKey: P256.Signing.PrivateKey
    ) throws -> Data {
        let signature = try privateKey.signature(for: data)
        return signature.rawRepresentation
    }
    
    func verifyDigitalSignature(
        _ signature: Data,
        for data: Data,
        using publicKey: P256.Signing.PublicKey
    ) -> Bool {
        guard let sig = try? P256.Signing.ECDSASignature(rawRepresentation: signature) else {
            return false
        }
        return publicKey.isValidSignature(sig, for: data)
    }
    
    func generateKeyPair() -> (privateKey: P256.Signing.PrivateKey, publicKey: P256.Signing.PublicKey) {
        let privateKey = P256.Signing.PrivateKey()
        let publicKey = privateKey.publicKey
        return (privateKey, publicKey)
    }
    
    func hashString(_ string: String) -> String {
        let data = Data(string.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
