import Foundation

class NetworkService {
    private let baseURL = "https://api.et-pro.gov.et/v1"
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    init() {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
    }
    
    func request2FACode(
        faydaID: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        let endpoint = "\(baseURL)/auth/request-2fa"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["fayda_id": faydaID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            }
        }.resume()
    }
    
    func verify2FACode(
        faydaID: String,
        code: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        let endpoint = "\(baseURL)/auth/verify-2fa"
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["fayda_id": faydaID, "code": code]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(true, nil)
                } else {
                    completion(false, error)
                }
            }
        }.resume()
    }
    
    func fetchUserProfile(
        faydaID: String,
        completion: @escaping (User?, Error?) -> Void
    ) {
        let endpoint = "\(baseURL)/fayda/profile/\(faydaID)"
        guard let url = URL(string: endpoint) else {
            completion(nil, NetworkError.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let user = try self.decoder.decode(User.self, from: data)
                        completion(user, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error ?? NetworkError.noData)
                }
            }
        }.resume()
    }
    
    func fetchCompanyProfile(
        registrationNumber: String,
        completion: @escaping (Company?, Error?) -> Void
    ) {
        let endpoint = "\(baseURL)/company/profile/\(registrationNumber)"
        guard let url = URL(string: endpoint) else {
            completion(nil, NetworkError.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let company = try self.decoder.decode(Company.self, from: data)
                        completion(company, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error ?? NetworkError.noData)
                }
            }
        }.resume()
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}
