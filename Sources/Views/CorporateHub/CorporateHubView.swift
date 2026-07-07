import SwiftUI

struct CorporateHubView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = CorporateViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Enterprise Dashboard")
                                .font(.headline)
                            
                            if let company = viewModel.company {
                                Text(company.companyName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button("Settings") {}
                            Button("Reports") {}
                            Button("Help") {}
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    
                    Picker("View", selection: $selectedTab) {
                        Text("Overview").tag(0)
                        Text("Approvals").tag(1)
                        Text("Compliance").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    TabView(selection: $selectedTab) {
                        OverviewTabView(viewModel: viewModel)
                            .tag(0)
                        
                        ApprovalsTabView(viewModel: viewModel)
                            .tag(1)
                        
                        ComplianceTabView(viewModel: viewModel)
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
            .navigationTitle("Corporate Hub")
            .onAppear {
                if let company = appState.currentCompany {
                    viewModel.fetchCompanyProfile(registrationNumber: company.registrationNumber)
                }
            }
        }
    }
}

struct OverviewTabView: View {
    @ObservedObject var viewModel: CorporateViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let company = viewModel.company {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(company.companyName)
                                    .font(.headline)
                                Text(company.registrationNumber)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "building.2.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.blue)
                        }
                        
                        Divider()
                        
                        HStack {
                            CompanyStatCard(title: "Directors", value: "\(company.directors.count)")
                            CompanyStatCard(title: "Shareholders", value: "\(company.shareholders.count)")
                            CompanyStatCard(title: "Bank Accounts", value: "\(company.bankAccounts.count)")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trade Permits")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        ForEach(viewModel.tradePermits) { permit in
                            TradePermitCell(permit: permit)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct ApprovalsTabView: View {
    @ObservedObject var viewModel: CorporateViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if viewModel.pendingApprovals.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.green)
                        
                        Text("No Pending Approvals")
                            .font(.headline)
                        
                        Text("All transactions are up to date")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
                } else {
                    ForEach(viewModel.pendingApprovals) { transaction in
                        TransactionApprovalCell(transaction: transaction)
                    }
                }
            }
            .padding()
        }
    }
}

struct ComplianceTabView: View {
    @ObservedObject var viewModel: CorporateViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let status = viewModel.complianceStatus {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Compliance Status")
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: status.taxCompliant ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(status.taxCompliant ? .green : .red)
                                    Text("Tax Compliant")
                                }
                                .font(.subheadline)
                                
                                HStack {
                                    Image(systemName: "doc.checkmark")
                                        .foregroundColor(.blue)
                                    Text("Audit: \(status.auditStatus)")
                                }
                                .font(.caption)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Certifications")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        ForEach(status.certifications, id: \.self) { cert in
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                Text(cert)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct CompanyStatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TradePermitCell: View {
    let permit: TradePermit
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.badge.checkmark")
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(permit.permitType)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                HStack {
                    Text("Expires: \(permit.expiryDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text(permit.status.rawValue.capitalized)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(permit.status == .active ? .green : .orange)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct TransactionApprovalCell: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 24))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.transactionType.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                HStack {
                    Text(transaction.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(transaction.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Review")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(4)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    CorporateHubView()
        .environmentObject(AuthViewModel())
        .environmentObject(AppState())
}
