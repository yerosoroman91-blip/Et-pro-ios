import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ClockViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Time Format")) {
                    Toggle("24-Hour Format", isOn: $viewModel.settings.use24HourFormat)
                        .onChange(of: viewModel.settings.use24HourFormat) { newValue in
                            var updated = viewModel.settings
                            updated.use24HourFormat = newValue
                            viewModel.updateSettings(updated)
                        }
                    
                    Toggle("Show Seconds", isOn: $viewModel.settings.showSeconds)
                        .onChange(of: viewModel.settings.showSeconds) { newValue in
                            var updated = viewModel.settings
                            updated.showSeconds = newValue
                            viewModel.updateSettings(updated)
                        }
                }
                
                Section(header: Text("Display")) {
                    Picker("Theme", selection: $viewModel.settings.selectedTheme) {
                        Text("Light").tag(ClockTheme.light)
                        Text("Dark").tag(ClockTheme.dark)
                        Text("System").tag(ClockTheme.system)
                    }
                    .onChange(of: viewModel.settings.selectedTheme) { newValue in
                        var updated = viewModel.settings
                        updated.selectedTheme = newValue
                        viewModel.updateSettings(updated)
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
                        Text("Time Zones Supported")
                        Spacer()
                        Text("\(viewModel.timeZones.count)")
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
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: ClockViewModel())
}
