import SwiftUI

struct CurrentWeatherCard: View {
    let weather: WeatherData
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Location and Update Time
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(weather.location.name), \(weather.location.country)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Updated: \(weather.lastUpdated.formatted(date: .omitted, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.toggleFavorite(weather.location)
                }) {
                    Image(systemName: viewModel.isFavorite(weather.location) ? "star.fill" : "star")
                        .font(.system(size: 18))
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            
            // Current Temperature
            HStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text(weather.temperature)
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(weather.condition)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(weather.description.capitalized)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    WeatherIconView(iconCode: weather.weatherIcon)
                        .frame(width: 80, height: 80)
                    
                    Text("Feels like \(weather.feelsLike)°")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            
            // Weather Details Grid
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    WeatherDetailCard(
                        icon: "humidity",
                        label: "Humidity",
                        value: "\(weather.currentWeather.main.humidity)%"
                    )
                    
                    WeatherDetailCard(
                        icon: "wind",
                        label: "Wind Speed",
                        value: String(format: "%.1f m/s", weather.currentWeather.wind.speed)
                    )
                }
                
                HStack(spacing: 12) {
                    WeatherDetailCard(
                        icon: "eye",
                        label: "Visibility",
                        value: String(format: "%.1f km", Double(weather.currentWeather.visibility) / 1000)
                    )
                    
                    WeatherDetailCard(
                        icon: "gauge",
                        label: "Pressure",
                        value: "\(weather.currentWeather.main.pressure) hPa"
                    )
                }
                
                HStack(spacing: 12) {
                    WeatherDetailCard(
                        icon: "cloud",
                        label: "Cloudiness",
                        value: "\(weather.currentWeather.clouds.all)%"
                    )
                    
                    WeatherDetailCard(
                        icon: "thermometer",
                        label: "Temp Range",
                        value: "\(Int(weather.currentWeather.main.temp_min))° - \(Int(weather.currentWeather.main.temp_max))°"
                    )
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
            
            // Sunrise/Sunset
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "sunrise.fill")
                            .foregroundColor(.yellow)
                        Text("Sunrise")
                            .font(.caption)
                    }
                    
                    Text(Date(timeIntervalSince1970: weather.currentWeather.sys.sunrise).formatted(date: .omitted, time: .shortened))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "sunset.fill")
                            .foregroundColor(.orange)
                        Text("Sunset")
                            .font(.caption)
                    }
                    
                    Text(Date(timeIntervalSince1970: weather.currentWeather.sys.sunset).formatted(date: .omitted, time: .shortened))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        .foregroundColor(.white)
    }
}

struct WeatherDetailCard: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.cyan)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
    }
}

struct WeatherIconView: View {
    let iconCode: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.1))
            
            Image(systemName: weatherSystemImage(for: iconCode))
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
    
    private func weatherSystemImage(for code: String) -> String {
        switch code {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.stars.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.rain.fill"
        case "13d", "13n": return "cloud.snow.fill"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.fill"
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.3)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack {}
    }
}
