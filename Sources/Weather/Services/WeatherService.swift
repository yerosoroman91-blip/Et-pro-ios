import Foundation

class WeatherService {
    private let apiKey = "YOUR_OPENWEATHERMAP_API_KEY"
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }
    
    func fetchCurrentWeather(
        city: String,
        unit: TemperatureUnit = .celsius,
        completion: @escaping (Result<WeatherResponse, WeatherError>) -> Void
    ) {
        let endpoint = "\(baseURL)/weather"
        var components = URLComponents(string: endpoint)!
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: unit.rawValue)
        ]
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url, completion: completion)
    }
    
    func fetchCurrentWeatherByCoordinates(
        lat: Double,
        lon: Double,
        unit: TemperatureUnit = .celsius,
        completion: @escaping (Result<WeatherResponse, WeatherError>) -> Void
    ) {
        let endpoint = "\(baseURL)/weather"
        var components = URLComponents(string: endpoint)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: unit.rawValue)
        ]
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url, completion: completion)
    }
    
    func fetchForecast(
        city: String,
        unit: TemperatureUnit = .celsius,
        completion: @escaping (Result<ForecastResponse, WeatherError>) -> Void
    ) {
        let endpoint = "\(baseURL)/forecast"
        var components = URLComponents(string: endpoint)!
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: unit.rawValue)
        ]
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url, completion: completion)
    }
    
    func fetchForecastByCoordinates(
        lat: Double,
        lon: Double,
        unit: TemperatureUnit = .celsius,
        completion: @escaping (Result<ForecastResponse, WeatherError>) -> Void
    ) {
        let endpoint = "\(baseURL)/forecast"
        var components = URLComponents(string: endpoint)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: unit.rawValue)
        ]
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetchData(from: url, completion: completion)
    }
    
    private func fetchData<T: Decodable>(
        from url: URL,
        completion: @escaping (Result<T, WeatherError>) -> Void
    ) {
        session.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    guard let data = data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let decoded = try self?.decoder.decode(T.self, from: data)
                        if let decoded = decoded {
                            completion(.success(decoded))
                        }
                    } catch {
                        completion(.failure(.decodingError(error.localizedDescription)))
                    }
                    
                case 404:
                    completion(.failure(.cityNotFound))
                case 401:
                    completion(.failure(.invalidAPIKey))
                default:
                    completion(.failure(.httpError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
}

enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(String)
    case networkError(String)
    case cityNotFound
    case invalidAPIKey
    case httpError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to parse data: \(error)"
        case .networkError(let error):
            return "Network error: \(error)"
        case .cityNotFound:
            return "City not found"
        case .invalidAPIKey:
            return "Invalid API key"
        case .httpError(let code):
            return "HTTP error: \(code)"
        }
    }
}
