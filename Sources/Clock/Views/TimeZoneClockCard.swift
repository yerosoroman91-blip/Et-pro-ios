import SwiftUI

struct TimeZoneClockCard: View {
    let timeZone: TimeZoneModel
    @ObservedObject var viewModel: ClockViewModel
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
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
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(viewModel.formatTime(timeZone.currentTime, for: timeZone))
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                    
                    Button(action: {
                        viewModel.toggleFavorite(timeZone)
                    }) {
                        Image(systemName: viewModel.isFavorite(timeZone) ? "star.fill" : "star")
                            .font(.system(size: 16))
                            .foregroundColor(viewModel.isFavorite(timeZone) ? .yellow : .gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            
            if isExpanded {
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Date")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.formatFullDateTime(timeZone.currentTime, for: timeZone))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Time Zone ID")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(timeZone.identifier)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        Text("UTC Offset")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(timeZone.offsetString)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
        .cornerRadius(12)
        .shadow(radius: 2)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded.toggle()
            }
        }
    }
}

#Preview {
    TimeZoneClockCard(
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
