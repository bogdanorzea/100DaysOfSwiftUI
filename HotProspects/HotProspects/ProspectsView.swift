//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Bogdan Orzea on 2023-02-06.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortType {
        case name, recent
    }
    
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    @State private var isShowingSortDialog = false
    @State private var sortType = SortType.name;
    
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        if filter == .none {
                            Image(
                                systemName: prospect.isContacted
                                ? "person.fill.checkmark"
                                : "person.fill.questionmark"
                            )
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .padding(.trailing)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.email)
                                .foregroundColor(.secondary)
                        }.swipeActions {
                            if prospect.isContacted {
                                Button {
                                    prospects.toggle(prospect: prospect)
                                } label: {
                                    Label("Mark uncontacted", systemImage: "person.crop.circle.badge.xmark")
                                }
                                .tint(.blue)
                            } else {
                                Button {
                                    prospects.toggle(prospect: prospect)
                                } label: {
                                    Label("Mark contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                                }
                                .tint(.green)
                                
                                Button {
                                    addNotification(for: prospect)
                                } label: {
                                    Label("Remind me", systemImage: "bell")
                                }
                                .tint(.orange)
                            }
                    }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
                
                Button {
                    isShowingSortDialog = true
                } label: {
                    Label("Sort", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Bogdan Orzea\nbogdan@orzea.ca", completion: handleScan)
            }
            .confirmationDialog("Sort Options", isPresented: $isShowingSortDialog) {
                Button("By Name") {
                    sortType = .name
                }
                
                Button("By most recent") {
                    sortType = .recent
                }
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        var result = [Prospect]()
        
        switch filter {
        case .none:
            result = prospects.people
        case .contacted:
            result = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            result = prospects.people.filter { !$0.isContacted }
        }
        
        switch sortType {
        case .name:
            return result.sorted { $0.name < $1.name}
        case .recent:
            return result.sorted {
                let first = $0.contactedAt ?? Date(timeIntervalSince1970: 0)
                let second = $1.contactedAt ?? Date(timeIntervalSince1970: 0)
                
                return first.compare(second) == .orderedDescending
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let success):
            let details = success.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.email = details[1]
            
            prospects.add(prospect: person)
        case .failure(let failure):
            print("Scanning failed: \(failure.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content .subtitle = prospect.email
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Cannot sent notifications")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
