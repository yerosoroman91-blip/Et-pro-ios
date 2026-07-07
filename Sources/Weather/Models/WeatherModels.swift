import Foundation

struct WeatherResponse: Codable {
    let coord: Coordinate
    let weather: [Weather]
    let main: MainWeather
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: TimeInterval
    let sys: SystemData
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Int?
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct SystemData: Codable {
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct ForecastResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastItem]
    let city: City
}

struct ForecastItem: Codable, Identifiable {
    let dt: TimeInterval
    let main: MainWeather
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: ForecastSys?
    
    var id: TimeInterval { dt }
}

struct ForecastSys: Codable {
    let pod: String?
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinate
    let country: String
    let population: Int?
    let timezone: Int
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct LocationModel: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    var isFavorite: Bool = false
    
    init(name: String, country: String, lat: Double, lon: Double) {
        self.id = UUID().uuidString
        self.name = name
        self.country = country
        self.lat = lat
        self.lon = lon
    }
}

struct WeatherData: Identifiable {
    let id: String
    let location: LocationModel
    let currentWeather: WeatherResponse
    let forecast: ForecastResponse?
    let lastUpdated: Date
    
    var temperature: String {
        String(format: "%.0f", currentWeather.main.temp)
    }
    
    var feelsLike: String {
        String(format: "%.0f", currentWeather.main.feels_like)
    }
    
    var condition: String {
        currentWeather.weather.first?.main ?? "Unknown"
    }
    
    var description: String {
        currentWeather.weather.first?.description ?? ""
    }
    
    var weatherIcon: String {
        currentWeather.weather.first?.icon ?? "01d"
    }
}

enum TemperatureUnit: String, Codable {
    case celsius = "metric"
    case fahrenheit = "imperial"
    case kelvin = "standard"
    
    var symbol: String {
        switch self {
        case .celsius:
            return "°C"
        case .fahrenheit:
            return "°F"
        case .kelvin:
            return "K"
        }
    }
}
