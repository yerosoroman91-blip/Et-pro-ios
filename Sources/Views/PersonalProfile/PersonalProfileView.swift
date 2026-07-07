import SwiftUI

struct PersonalProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = PersonalProfileViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            if let user = authViewModel.currentUser {
                                Text(user.fullName)
                                    .font(.headline)
                            }
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button("Settings") {}
                            Button("Help") {}
                            Button("Logout", action: {
                                authViewModel.logout()
                            })
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    
                    Picker("View", selection: $selectedTab) {
                        Text("Profile").tag(0)
                        Text("Documents").tag(1)
                        Text("Activity").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    TabView(selection: $selectedTab) {
                        ProfileTabView()
                            .tag(0)
                        
                        DocumentsTabView()
                            .tag(1)
                        
                        ActivityTabView()
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                }
            }
            .navigationTitle("Personal Profile")
            .onAppear {
                if let user = authViewModel.currentUser {
                    viewModel.user = user
                    viewModel.fetchUserDocuments(for: user.id)
                }
            }
        }
    }
}

struct ProfileTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let user = authViewModel.currentUser {
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.headline)
                                Text(user.faydaID)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(user.email)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Contact Information")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        InfoRow(label: "Phone", value: user.phone)
                        InfoRow(label: "Email", value: user.email)
                        InfoRow(label: "Address", value: user.address)
                        InfoRow(label: "City", value: user.city)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct DocumentsTabView: View {
    @StateObject private var viewModel = PersonalProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if viewModel.documents.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        
                        Text("No Documents")
                            .font(.headline)
                        
                        Text("Your verified documents will appear here")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
                } else {
                    ForEach(viewModel.documents) { document in
                        DocumentCell(document: document)
                    }
                }
            }
            .padding()
        }
    }
}

struct ActivityTabView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Recent Activity")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(spacing: 8) {
                    ActivityCell(title: "Login", time: "Today at 10:30 AM", icon: "checkmark.circle")
                    ActivityCell(title: "Document Verified", time: "Yesterday at 2:15 PM", icon: "doc.badge.checkmark")
                    ActivityCell(title: "Profile Updated", time: "2 days ago", icon: "person.badge.plus")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct DocumentCell: View {
    let document: Document
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.fill")
                .font(.system(size: 24))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(document.documentType.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(document.documentNumber)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if document.isVerified {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct ActivityCell: View {
    let title: String
    let time: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
        }
        .font(.caption)
    }
}

#Preview {
    PersonalProfileView()
        .environmentObject(AuthViewModel())
        .environmentObject(AppState())
}
