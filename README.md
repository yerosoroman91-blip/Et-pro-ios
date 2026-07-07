# Digital Clock - World Time Zones

A sophisticated iOS application displaying current time across 50+ world time zones with advanced features.

## Features

### ⏰ Core Features
- **Real-time Clock Display**: Live updating clock for all time zones
- **50+ Time Zones**: Support for major cities worldwide
- **Multiple Formats**: 12/24 hour format with optional seconds
- **UTC Offsets**: Display of current UTC offset for each zone
- **Full Date/Time Info**: Complete date and time information

### ⭐ Favorites System
- Save frequently used time zones
- Quick access to favorite zones
- One-tap toggling
- Persistent storage

### 🔍 Search & Filter
- Real-time search by city name
- Filter by time zone abbreviation
- Filter by UTC offset
- Instant results

### ⚙️ Customization
- Toggle 12/24 hour format
- Show/hide seconds
- Theme selection (Light/Dark/System)
- Auto-saving preferences

### 💾 Local Storage
- Persistent favorites using UserDefaults
- Settings saved locally
- No cloud required
- Full offline capability

## Technical Stack

- **Framework**: SwiftUI
- **State Management**: Combine + MVVM
- **Storage**: UserDefaults
- **Minimum iOS**: 14.0
- **Architecture**: MVVM Pattern

## Project Structure

```
Sources/Clock/
├── App/
│   └── ClockApp.swift
├── Models/
│   ├── TimeZoneModel.swift
│   └── WorldTimeData.swift
├── ViewModels/
│   └── ClockViewModel.swift
└── Views/
    ├── ClockMainView.swift
    ├── TimeZoneClockCard.swift
    ├── SettingsView.swift
    └── DetailedClockView.swift
```

## Installation

1. Clone the repository
2. Open `Et-pro-ios.xcodeproj` in Xcode
3. Select the Clock target
4. Build and run on simulator or device

## Usage

### Viewing Time Zones
- Scroll through all available time zones
- Each card shows city name, current time, and UTC offset
- Tap any card to expand and see full details

### Adding Favorites
- Tap the star icon on any time zone card
- Or use context menu (long press)
- Favorites appear in dedicated view

### Searching
- Tap search icon in header
- Type city name or time zone abbreviation
- Results update in real-time

### Adjusting Settings
- Tap settings icon (gear)
- Toggle 24-hour format
- Toggle seconds display
- Select theme preference

## Supported Time Zones

### Africa
- Cairo, Johannesburg, Lagos, Nairobi, Addis Ababa, Casablanca, Dar es Salaam, Accra, Kigali

### Americas
- New York, Chicago, Denver, Los Angeles, Anchorage, Honolulu, Toronto, Mexico City, Buenos Aires, São Paulo, Lima

### Europe
- London, Paris, Berlin, Madrid, Rome, Amsterdam, Brussels, Vienna, Prague, Moscow, Istanbul, Athens

### Asia
- Dubai, Bangkok, Singapore, Hong Kong, Tokyo, Shanghai, Delhi, Seoul, Jakarta, Manila, Karachi, Yangon

### Oceania
- Sydney, Melbourne, Brisbane, Perth, Auckland, Fiji

## Data Storage

### UserDefaults Keys
- `favorites`: Encoded array of favorite time zones
- `clockSettings`: User settings (format, theme, etc.)

### Data Structure
```swift
struct TimeZoneModel {
    let id: String
    let identifier: String
    let displayName: String
    let abbreviation: String
    let offsetSeconds: Int
    var isFavorite: Bool
    var currentTime: Date
}
```

## Performance

- Lightweight timer updates every 0.5 seconds
- Efficient view rendering with SwiftUI
- Memory-optimized data structures
- Smooth animations

## Future Enhancements

- [ ] Analog clock face display
- [ ] Color-coded time zones by UTC offset
- [ ] Time difference calculator
- [ ] World map with time zone visualization
- [ ] Alarm clock functionality
- [ ] iCloud synchronization
- [ ] Widget support

## License

Confidential - Internal Project

## Support

For issues or feature requests, contact the development team.
