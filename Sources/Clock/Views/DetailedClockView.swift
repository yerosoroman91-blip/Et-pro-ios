import SwiftUI

struct DetailedClockView: View {
    let timeZone: TimeZoneModel
    @ObservedObject var viewModel: ClockViewModel
    @State private var showAnalogClock = true
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text(timeZone.displayName)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Text(timeZone.abbreviation)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue)
                        .cornerRadius(4)
                    
                    Text(timeZone.formattedOffset)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Digital Clock
            VStack(spacing: 16) {
                Text(viewModel.formatTime(timeZone.currentTime, for: timeZone))
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                
                Text(viewModel.formatFullDateTime(timeZone.currentTime, for: timeZone))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // Information
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("UTC Offset")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(timeZone.offsetString)
                        .fontWeight(.semibold)
                }
                
                Divider()
                
                HStack {
                    Text("Time Zone ID")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(timeZone.identifier)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Clock Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DetailedClockView(
            timeZone: TimeZoneModel(
                id: "Africa/Addis_Ababa",
                identifier: "Africa/Addis_Ababa",
                displayName: "Addis Ababa (Ethiopia)",
                abbreviation: "EAT",
                offsetSeconds: 10800
            ),
            viewModel: ClockViewModel()
        )
    }
}
