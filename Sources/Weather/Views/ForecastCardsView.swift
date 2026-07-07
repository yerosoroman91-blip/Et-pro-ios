import SwiftUI

struct ForecastCardsView: View {
    let weather: WeatherData
    @State private var selectedForecast: ForecastItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("7-Day Forecast")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if let forecast = weather.forecast?.list {
                        ForEach(forecast.prefix(8)) { item in
                            ForecastItemCard(item: item)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Hourly Forecast
            VStack(alignment: .leading, spacing: 12) {
                Text("Hourly Forecast")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                if let forecast = weather.forecast?.list {
                    VStack(spacing: 8) {
                        ForEach(forecast.prefix(5)) { item in
                            HourlyForecastRow(item: item)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct ForecastItemCard: View {
    let item: ForecastItem
    
    var body: some View {
        VStack(spacing: 8) {
            Text(Date(timeIntervalSince1970: item.dt).formatted(date: .omitted, time: .shortened))
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
            
            Image(systemName: weatherIcon(for: item.weather.first?.icon ?? "01d"))
                .font(.system(size: 20))
                .foregroundColor(.cyan)
            
            Text("\(Int(item.main.temp))°")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(item.weather.first?.description.prefix(10) ?? "")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(width: 80)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func weatherIcon(for code: String) -> String {
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

struct HourlyForecastRow: View {
    let item: ForecastItem
    
    var body: some View {
        HStack(spacing: 16) {
            Text(Date(timeIntervalSince1970: item.dt).formatted(date: .omitted, time: .shortened))
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 45, alignment: .leading)
            
            Image(systemName: weatherIcon(for: item.weather.first?.icon ?? "01d"))
                .font(.system(size: 16))
                .foregroundColor(.cyan)
                .frame(width: 20)
            
            Text(item.weather.first?.main ?? "Unknown")
                .font(.caption)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(Int(item.main.temp))°")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 35, alignment: .trailing)
            
            HStack(spacing: 4) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 10))
                Text("\(Int(item.pop * 100))%")
                    .font(.caption2)
            }
            .foregroundColor(.cyan)
            .frame(width: 45, alignment: .trailing)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
    
    private func weatherIcon(for code: String) -> String {
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
