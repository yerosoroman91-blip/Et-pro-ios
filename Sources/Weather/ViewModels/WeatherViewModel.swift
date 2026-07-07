import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weatherData: [WeatherData] = []
    @Published var favorites: [LocationModel] = []
    @Published var searchResults: [LocationModel] = []
    @Published var selectedWeather: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var temperatureUnit: TemperatureUnit = .celsius
    @Published var searchText: String = ""
    @Published var showSearch = false
    
    private let weatherService = WeatherService()
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init() {
        loadFavorites()
        loadSettings()
        loadDefaultCity()
    }
    
    // MARK: - Weather Fetching
    
    func fetchWeather(for location: LocationModel) {
        isLoading = true
        errorMessage = nil
        
        let group = DispatchGroup()
        var currentWeatherResult: WeatherResponse?
        var forecastResult: ForecastResponse?
        var error: WeatherError?
        
        // Fetch current weather
        group.enter()
        weatherService.fetchCurrentWeatherByCoordinates(
            lat: location.lat,
            lon: location.lon,
            unit: temperatureUnit
        ) { result in
            switch result {
            case .success(let weather):
                currentWeatherResult = weather
            case .failure(let err):
                error = err
            }
            group.leave()
        }
        
        // Fetch forecast
        group.enter()
        weatherService.fetchForecastByCoordinates(
            lat: location.lat,
            lon: location.lon,
            unit: temperatureUnit
        ) { result in
            switch result {
            case .success(let forecast):
                forecastResult = forecast
            case .failure(let err):
                error = err
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
            
            if let error = error {
                self.errorMessage = error.errorDescription
                return
            }
            
            guard let currentWeather = currentWeatherResult else {
                self.errorMessage = "Failed to fetch weather data"
                return
            }
            
            let weatherData = WeatherData(
                id: location.id,
                location: location,
                currentWeather: currentWeather,
                forecast: forecastResult,
                lastUpdated: Date()
            )
            
            if let index = self.weatherData.firstIndex(where: { $0.id == location.id }) {
                self.weatherData[index] = weatherData
            } else {
                self.weatherData.append(weatherData)
            }
            
            self.selectedWeather = weatherData
        }
    }
    
    func searchCity(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        // For demo purposes, using predefined cities
        // In production, you'd use a geocoding API
        let allCities: [LocationModel] = [
            LocationModel(name: "London", country: "GB", lat: 51.5074, lon: -0.1278),
            LocationModel(name: "New York", country: "US", lat: 40.7128, lon: -74.0060),
            LocationModel(name: "Tokyo", country: "JP", lat: 35.6762, lon: 139.6503),
            LocationModel(name: "Paris", country: "FR", lat: 48.8566, lon: 2.3522),
            LocationModel(name: "Sydney", country: "AU", lat: -33.8688, lon: 151.2093),
            LocationModel(name: "Dubai", country: "AE", lat: 25.2048, lon: 55.2708),
            LocationModel(name: "Singapore", country: "SG", lat: 1.3521, lon: 103.8198),
            LocationModel(name: "Berlin", country: "DE", lat: 52.5200, lon: 13.4050),
            LocationModel(name: "Rome", country: "IT", lat: 41.9028, lon: 12.4964),
            LocationModel(name: "Moscow", country: "RU", lat: 55.7558, lon: 37.6173),
        ]
        
        searchResults = allCities.filter { city in
            city.name.localizedCaseInsensitiveContains(query) ||
            city.country.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Favorites Management
    
    func toggleFavorite(_ location: LocationModel) {
        if favorites.contains(where: { $0.id == location.id }) {
            favorites.removeAll { $0.id == location.id }
        } else {
            var favorite = location
            favorite.isFavorite = true
            favorites.append(favorite)
        }
        saveFavorites()
    }
    
    func isFavorite(_ location: LocationModel) -> Bool {
        favorites.contains { $0.id == location.id }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: "favorites"),
           let decoded = try? decoder.decode([LocationModel].self, from: data) {
            favorites = decoded
        }
    }
    
    private func saveFavorites() {
        if let encoded = try? encoder.encode(favorites) {
            userDefaults.set(encoded, forKey: "favorites")
        }
    }
    
    // MARK: - Settings
    
    private func loadSettings() {
        if let unitRawValue = userDefaults.string(forKey: "temperatureUnit"),
           let unit = TemperatureUnit(rawValue: unitRawValue) {
            temperatureUnit = unit
        }
    }
    
    func updateTemperatureUnit(_ unit: TemperatureUnit) {
        temperatureUnit = unit
        userDefaults.set(unit.rawValue, forKey: "temperatureUnit")
        
        // Refresh all weather data
        for weather in weatherData {
            fetchWeather(for: weather.location)
        }
    }
    
    // MARK: - Default City
    
    private func loadDefaultCity() {
        let defaultCity = LocationModel(name: "London", country: "GB", lat: 51.5074, lon: -0.1278)
        fetchWeather(for: defaultCity)
    }
}
