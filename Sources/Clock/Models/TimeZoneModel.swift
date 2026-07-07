import Foundation

struct TimeZoneModel: Identifiable, Codable, Hashable {
    let id: String
    let identifier: String
    let displayName: String
    let abbreviation: String
    let offsetSeconds: Int
    var isFavorite: Bool = false
    var currentTime: Date = Date()
    
    var offsetString: String {
        let hours = offsetSeconds / 3600
        let minutes = (offsetSeconds % 3600) / 60
        
        if minutes == 0 {
            return String(format: "UTC%+03d:00", hours)
        } else {
            return String(format: "UTC%+03d:%02d", hours, minutes)
        }
    }
    
    var formattedOffset: String {
        let hours = offsetSeconds / 3600
        let minutes = (offsetSeconds % 3600) / 60
        let sign = offsetSeconds >= 0 ? "+" : "-"
        return String(format: "%@%02d:%02d", sign, abs(hours), abs(minutes))
    }
    
    static func == (lhs: TimeZoneModel, rhs: TimeZoneModel) -> Bool {
        lhs.id == rhs.id && lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(identifier)
    }
}

struct ClockSettings: Codable {
    var use24HourFormat: Bool = false
    var showSeconds: Bool = true
    var autoUpdateInterval: TimeInterval = 1.0
    var selectedTheme: ClockTheme = .system
}

enum ClockTheme: String, Codable {
    case light
    case dark
    case system
}
