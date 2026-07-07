import SwiftUI
import Combine

class ClockViewModel: ObservableObject {
    @Published var timeZones: [TimeZoneModel] = []
    @Published var favorites: [TimeZoneModel] = []
    @Published var settings: ClockSettings = ClockSettings()
    @Published var searchText: String = ""
    @Published var selectedTimeZone: TimeZoneModel?
    @Published var currentTime: Date = Date()
    @Published var is24HourFormat: Bool = false
    @Published var showSeconds: Bool = true
    
    private var timer: Timer?
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSettings()
        loadTimeZones()
        loadFavorites()
        startTimer()
    }
    
    // MARK: - Time Management
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.currentTime = Date()
                self?.updateTimeZones()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimeZones() {
        for index in timeZones.indices {
            timeZones[index].currentTime = currentTime
        }
        
        for index in favorites.indices {
            favorites[index].currentTime = currentTime
        }
    }
    
    // MARK: - Time Zone Management
    
    private func loadTimeZones() {
        var zones = WorldTimeData.timeZones
        zones[0].currentTime = currentTime
        timeZones = zones
    }
    
    func getTimeZone(by identifier: String) -> TimeZoneModel? {
        return timeZones.first { $0.identifier == identifier }
    }
    
    func filteredTimeZones() -> [TimeZoneModel] {
        if searchText.isEmpty {
            return timeZones
        }
        
        return timeZones.filter { zone in
            zone.displayName.localizedCaseInsensitiveContains(searchText) ||
            zone.abbreviation.localizedCaseInsensitiveContains(searchText) ||
            zone.identifier.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Favorites Management
    
    func toggleFavorite(_ timeZone: TimeZoneModel) {
        if let index = timeZones.firstIndex(where: { $0.identifier == timeZone.identifier }) {
            timeZones[index].isFavorite.toggle()
            
            if timeZones[index].isFavorite {
                if !favorites.contains(where: { $0.identifier == timeZone.identifier }) {
                    favorites.append(timeZones[index])
                }
            } else {
                favorites.removeAll { $0.identifier == timeZone.identifier }
            }
            
            saveFavorites()
        }
    }
    
    func isFavorite(_ timeZone: TimeZoneModel) -> Bool {
        timeZones.contains { $0.identifier == timeZone.identifier && $0.isFavorite }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([TimeZoneModel].self, from: data) {
            favorites = decoded
            
            // Mark as favorite in timeZones
            for fav in favorites {
                if let index = timeZones.firstIndex(where: { $0.identifier == fav.identifier }) {
                    timeZones[index].isFavorite = true
                }
            }
        }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: "favorites")
        }
    }
    
    // MARK: - Settings Management
    
    private func loadSettings() {
        if let data = userDefaults.data(forKey: "clockSettings"),
           let decoded = try? JSONDecoder().decode(ClockSettings.self, from: data) {
            settings = decoded
            is24HourFormat = settings.use24HourFormat
            showSeconds = settings.showSeconds
        }
    }
    
    func updateSettings(_ newSettings: ClockSettings) {
        settings = newSettings
        is24HourFormat = settings.use24HourFormat
        showSeconds = settings.showSeconds
        
        if let encoded = try? JSONEncoder().encode(settings) {
            userDefaults.set(encoded, forKey: "clockSettings")
        }
    }
    
    func toggleTimeFormat() {
        var newSettings = settings
        newSettings.use24HourFormat.toggle()
        updateSettings(newSettings)
    }
    
    func toggleShowSeconds() {
        var newSettings = settings
        newSettings.showSeconds.toggle()
        updateSettings(newSettings)
    }
    
    // MARK: - Time Formatting
    
    func formatTime(_ date: Date, for timeZone: TimeZoneModel) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timeZone.identifier)
        
        if is24HourFormat {
            formatter.dateFormat = showSeconds ? "HH:mm:ss" : "HH:mm"
        } else {
            formatter.dateFormat = showSeconds ? "hh:mm:ss a" : "hh:mm a"
        }
        
        return formatter.string(from: date)
    }
    
    func formatFullDateTime(_ date: Date, for timeZone: TimeZoneModel) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timeZone.identifier)
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        return formatter.string(from: date)
    }
    
    deinit {
        stopTimer()
    }
}
