import SwiftUI

struct WeatherDashboardView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var showingSettings = false
    @State private var showingFavorites = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dynamic background based on weather
                if let weather = viewModel.selectedWeather {
                    backgroundGradient(for: weather.condition)
                        .ignoresSafeArea()
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.3)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                }
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Weather Dashboard")
                                .font(.system(size: 28, weight: .bold))
                            Text("Real-time weather updates")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button(action: { viewModel.showSearch = true }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            
                            Button(action: { showingFavorites = true }) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.yellow)
                            }
                            
                            Button(action: { showingSettings = true }) {
                                Image(systemName: "gear")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.2))
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 20) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            }
                            
                            if let errorMessage = viewModel.errorMessage {
                                VStack(spacing: 12) {
                                    Image(systemName: "exclamationmark.triangle")
                                        .font(.system(size: 32))
                                        .foregroundColor(.yellow)
                                    
                                    Text("Error")
                                        .font(.headline)
                                    
                                    Text(errorMessage)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                                .background(Color.red.opacity(0.2))
                                .cornerRadius(12)
                                .padding()
                            }
                            
                            if let weather = viewModel.selectedWeather {
                                CurrentWeatherCard(weather: weather, viewModel: viewModel)
                                ForecastCardsView(weather: weather)
                            }
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showSearch) {
                SearchWeatherView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingFavorites) {
                FavoritesView(viewModel: viewModel, isShowing: $showingFavorites)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
        }
    }
    
    private func backgroundGradient(for condition: String) -> LinearGradient {
        switch condition.lowercased() {
        case "clear", "sunny":
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.5, green: 0.8, blue: 1.0)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "clouds", "cloudy":
            return LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "rain", "rainy":
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.2, blue: 0.4), Color(red: 0.3, green: 0.3, blue: 0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "thunderstorm":
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.2, green: 0.2, blue: 0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "snow", "snowy":
            return LinearGradient(
                gradient: Gradient(colors: [Color.white.opacity(0.5), Color.blue.opacity(0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.cyan.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

#Preview {
    WeatherDashboardView()
}
