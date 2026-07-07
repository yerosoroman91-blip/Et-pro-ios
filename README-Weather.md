# Weather Dashboard iOS App

A beautiful and comprehensive weather dashboard application for iOS that fetches real-time weather data from the OpenWeatherMap API.

## Features

### 🌤️ Current Weather Display
- Real-time temperature, weather condition, and description
- Feels-like temperature
- Dynamic gradient backgrounds based on weather condition
- Beautiful weather icons
- Location-based weather

### 📊 Detailed Weather Information
- Humidity percentage
- Wind speed
- Visibility distance
- Atmospheric pressure
- Cloud coverage
- Temperature range (min/max)
- Sunrise and sunset times

### 📈 Forecast Data
- 7-day weather forecast
- Hourly forecast for next 5 hours
- Precipitation probability
- Weather icons for each forecast period
- Detailed condition descriptions

### 🔍 Search & Locations
- Search weather by city name
- Auto-complete search suggestions
- Save favorite locations
- Quick access to favorites
- 10+ pre-loaded popular cities

### ⚙️ Settings & Customization
- Temperature unit selection (Celsius, Fahrenheit, Kelvin)
- Theme switching (Light/Dark/System)
- Persistent user preferences
- Settings management

### 💾 Local Storage
- Save favorite locations
- Store user preferences
- Cache weather data
- Offline support for recent data

## Technical Stack

- **Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Combine + @Published
- **Networking**: URLSession
- **Storage**: UserDefaults
- **Minimum iOS**: 14.0
- **Swift**: 5.5+

## Project Structure

```
Sources/Weather/
├── App/
│   └── WeatherApp.swift
├── Models/
│   └── WeatherModels.swift
├── ViewModels/
│   └── WeatherViewModel.swift
├── Views/
│   ├── WeatherDashboardView.swift
│   ├── CurrentWeatherCard.swift
│   ├── ForecastCardsView.swift
│   └── WeatherSearchView.swift
└── Services/
    └── WeatherService.swift
```

## API Integration

### OpenWeatherMap API
- **Base URL**: `https://api.openweathermap.org/data/2.5`
- **Endpoints**:
  - `/weather` - Current weather data
  - `/forecast` - 5-day forecast data
- **Authentication**: API key required

### Getting an API Key
1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Generate an API key
4. Replace `YOUR_OPENWEATHERMAP_API_KEY` in `WeatherService.swift`

## Data Models

### WeatherResponse
Current weather information from API
- Coordinates (latitude, longitude)
- Weather conditions
- Temperature data
- Wind information
- Cloud coverage
- System data (sunrise/sunset)

### ForecastResponse
Weather forecast data
- List of forecast items (5-day, every 3 hours)
- City information
- Weather conditions for each period

### WeatherData
Processed weather information for display
- Location details
- Current weather
- Forecast data
- Last updated timestamp
- Temperature formatting

### LocationModel
City/location information
- City name and country
- Coordinates (lat/lon)
- Favorite status
- Unique identification

## Usage

### Setup
1. Clone the repository
2. Open `Et-pro-ios.xcodeproj` in Xcode
3. Update API key in `WeatherService.swift`
4. Build and run

### Features

#### View Current Weather
- App loads weather for London by default
- Displays comprehensive weather information
- Dynamic background matches weather condition

#### Search for a City
1. Tap search icon (magnifying glass)
2. Type city name
3. Select from results
4. Weather updates automatically

#### Add to Favorites
1. View weather for desired city
2. Tap star icon
3. Access favorites from star button in header
4. Quickly switch between favorite locations

#### Change Temperature Unit
1. Tap settings icon (gear)
2. Select desired unit (°C, °F, K)
3. All temperatures update automatically

#### View Forecast
- Scroll down to see forecast cards
- View 7-day summary in horizontal scroll
- Check hourly forecast below
- Tap any card for details

## API Response Handling

### Success (200)
Weather data decoded and displayed

### Error Codes
- **404**: City not found
- **401**: Invalid API key
- **5xx**: Server errors
- **Network**: Connection errors

## Performance Optimizations

- Efficient network requests with URLSession
- View caching and reuse
- Minimal memory footprint
- Smooth animations with Core Animation
- Background fetching support

## Known Limitations

- Requires internet connection (except cached data)
- Free API has rate limits
- Forecast limited to 5 days in free tier
- Geolocation not yet implemented
- No offline maps

## Future Enhancements

- [ ] Geolocation-based weather
- [ ] Weather alerts and notifications
- [ ] Extended forecast (16 days)
- [ ] Air quality index
- [ ] UV index display
- [ ] Weather maps
- [ ] Multi-language support
- [ ] Widget support
- [ ] iCloud sync
- [ ] Dark mode optimization

## Troubleshooting

### API Key Error
- Verify API key is correct
- Check API key has sufficient quota
- Ensure free tier is activated

### City Not Found
- Try exact city name spelling
- Include country code if needed
- Check internet connection

### No Temperature Display
- Verify API response received
- Check JSON decoding
- Review console for errors

## License

MIT License - Feel free to use and modify

## Credits

- Weather data from [OpenWeatherMap](https://openweathermap.org)
- Icons from SF Symbols
- Built with SwiftUI

---

**Version**: 1.0.0
**Last Updated**: July 2026
**Status**: Production Ready
