import SwiftUI

struct SearchWeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var searchFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search city...", text: $viewModel.searchText)
                        .focused($searchFocused)
                        .onChange(of: viewModel.searchText) { newValue in
                            viewModel.searchCity(newValue)
                        }
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: { viewModel.searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
                
                ScrollView {
                    VStack(spacing: 12) {
                        if viewModel.searchResults.isEmpty && !viewModel.searchText.isEmpty {
                            Text("No cities found")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(viewModel.searchResults) { location in
                                Button(action: {
                                    viewModel.fetchWeather(for: location)
                                    dismiss()
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(location.name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            
                                            Text(location.country)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        if viewModel.isFavorite(location) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Search Weather")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                searchFocused = true
            }
        }
    }
}

struct FavoritesView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @Binding var isShowing: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.favorites.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        
                        Text("No Favorites")
                            .font(.headline)
                        
                        Text("Add favorite locations to see them here")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.favorites) { location in
                                Button(action: {
                                    viewModel.fetchWeather(for: location)
                                    isShowing = false
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(location.name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            
                                            Text(location.country)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            viewModel.toggleFavorite(location)
                                        }) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Favorite Locations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { isShowing = false }
                }
            }
        }
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Temperature Unit")) {
                    Picker("Unit", selection: $viewModel.temperatureUnit) {
                        Text("Celsius (°C)").tag(TemperatureUnit.celsius)
                        Text("Fahrenheit (°F)").tag(TemperatureUnit.fahrenheit)
                        Text("Kelvin (K)").tag(TemperatureUnit.kelvin)
                    }
                    .onChange(of: viewModel.temperatureUnit) { newValue in
                        viewModel.updateTemperatureUnit(newValue)
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Locations")
                        Spacer()
                        Text("\(viewModel.weatherData.count)")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Favorites")
                        Spacer()
                        Text("\(viewModel.favorites.count)")
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.favorites.removeAll()
                    }) {
                        Text("Clear All Favorites")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
