import SwiftUI

struct ClockMainView: View {
    @StateObject private var viewModel = ClockViewModel()
    @State private var showingFavorites = false
    @State private var showingSettings = false
    @State private var showingSearch = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("World Clock")
                                .font(.system(size: 32, weight: .bold))
                            Text(viewModel.currentTime.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button(action: { showingSearch.toggle() }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 18))
                                    .foregroundColor(.blue)
                            }
                            
                            Button(action: { showingFavorites.toggle() }) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.yellow)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.yellow, lineWidth: 1)
                                            .scaleEffect(1.3)
                                    )
                            }
                            
                            Button(action: { showingSettings.toggle() }) {
                                Image(systemName: "gear")
                                    .font(.system(size: 18))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    
                    // Content
                    if showingFavorites && !viewModel.favorites.isEmpty {
                        FavoritesView(viewModel: viewModel, isShowing: $showingFavorites)
                    } else if showingFavorites {
                        EmptyFavoritesView()
                    } else if showingSearch {
                        SearchTimeZonesView(viewModel: viewModel, isShowing: $showingSearch)
                    } else {
                        AllTimeZonesView(viewModel: viewModel)
                    }
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.startTimer()
            }
            .onDisappear {
                viewModel.stopTimer()
            }
        }
    }
}

struct AllTimeZonesView: View {
    @ObservedObject var viewModel: ClockViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.timeZones) { timeZone in
                    TimeZoneClockCard(timeZone: timeZone, viewModel: viewModel)
                        .contextMenu {
                            Button(action: {
                                viewModel.toggleFavorite(timeZone)
                            }) {
                                Label(
                                    viewModel.isFavorite(timeZone) ? "Remove from Favorites" : "Add to Favorites",
                                    systemImage: viewModel.isFavorite(timeZone) ? "star.fill" : "star"
                                )
                            }
                        }
                }
            }
            .padding()
        }
    }
}

struct FavoritesView: View {
    @ObservedObject var viewModel: ClockViewModel
    @Binding var isShowing: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Favorite Time Zones")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: { isShowing = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                VStack(spacing: 12) {
                    ForEach(viewModel.favorites) { timeZone in
                        TimeZoneClockCard(timeZone: timeZone, viewModel: viewModel)
                            .contextMenu {
                                Button(action: {
                                    viewModel.toggleFavorite(timeZone)
                                }) {
                                    Label("Remove from Favorites", systemImage: "star.fill")
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "star.slash")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No Favorites Yet")
                .font(.headline)
            
            Text("Add time zones to your favorites to see them here")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
}

struct SearchTimeZonesView: View {
    @ObservedObject var viewModel: ClockViewModel
    @Binding var isShowing: Bool
    @FocusState private var searchFocused: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search time zones...", text: $viewModel.searchText)
                    .focused($searchFocused)
                
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
                    if viewModel.filteredTimeZones().isEmpty {
                        Text("No time zones found")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(viewModel.filteredTimeZones()) { timeZone in
                            TimeZoneClockCard(timeZone: timeZone, viewModel: viewModel)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            searchFocused = true
        }
    }
}

#Preview {
    ClockMainView()
}
