import SwiftUI
import FirebaseAuth
import HealthKit
import FirebaseFirestore

// Models
struct SleepLog: Identifiable {
    let id = UUID()
    let hours: Double
    let dateRange: String
    let sleepType: SleepType
}

enum SleepType: String, CaseIterable {
    case deep = "Deep Sleep"
    case light = "Light Sleep"
    case awake = "Awake"
    
    init(from sample: HKCategorySample) {
        switch sample.value {
        case HKCategoryValueSleepAnalysis.inBed.rawValue:
            self = .awake
        case HKCategoryValueSleepAnalysis.asleep.rawValue:
            self = .deep
        default:
            self = .light
        }
    }
}

// ViewModel
class SleepTrackerViewModel: ObservableObject {
    private var healthStore = HKHealthStore()
    @Published var sleepLogs: [SleepLog] = []
    @Published var sleepGoal: Double = 8.0
    @Published var sleepStartTime = Calendar.current.startOfDay(for: Date())
    @Published var sleepEndTime = Calendar.current.startOfDay(for: Date()).addingTimeInterval(8 * 3600)
    
    init() {
//        generateMockSleepData()
        requestAuthorization()
    }
    
//    func generateMockSleepData() {
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//
//        let mockData = [
//            SleepLog(hours: 6.5, dateRange: "\(formatter.string(from: Date().addingTimeInterval(-8.5 * 3600))) - \(formatter.string(from: Date()))", sleepType: .deep),
//            SleepLog(hours: 7.5, dateRange: "\(formatter.string(from: Date().addingTimeInterval(-24 * 3600 - 8.5 * 3600))) - \(formatter.string(from: Date().addingTimeInterval(-24 * 3600)))", sleepType: .light),
//            SleepLog(hours: 8, dateRange: "\(formatter.string(from: Date().addingTimeInterval(-48 * 3600 - 8 * 3600))) - \(formatter.string(from: Date().addingTimeInterval(-48 * 3600)))", sleepType: .deep),
//            SleepLog(hours: 7, dateRange: "\(formatter.string(from: Date().addingTimeInterval(-72 * 3600 - 7 * 3600))) - \(formatter.string(from: Date().addingTimeInterval(-72 * 3600)))", sleepType: .light)
//        ]
//        self.sleepLogs = mockData
//    }
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable(),
              let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return
        }
        
        let typesToRead: Set<HKObjectType> = [sleepAnalysis]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] success, _ in
            if success {
                self?.fetchSleepData()
            }
        }
    }
    
    func fetchSleepData() {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] (_, samples, error) in
            guard error == nil, let categorySamples = samples as? [HKCategorySample] else { return }

            DispatchQueue.main.async {
                let newLogs = categorySamples.map { sample -> SleepLog in
                    let hours = sample.endDate.timeIntervalSince(sample.startDate) / 3600
                    let dateRange = "\(sample.startDate.formatted(date: .abbreviated, time: .shortened)) - \(sample.endDate.formatted(date: .abbreviated, time: .shortened))"
                    let sleepType = SleepType(from: sample)
                    return SleepLog(hours: hours, dateRange: dateRange, sleepType: sleepType)
                }
                self?.sleepLogs = newLogs

                // After processing the logs, save them to Firestore
                newLogs.forEach { self?.saveSleepLogToFirestore(log: $0) }
            }
        }
        healthStore.execute(query)
    }

    
    func saveSleepLogToFirestore(log: SleepLog) {
        let db = Firestore.firestore()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone.current
        
        let dateComponents = log.dateRange.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespaces) }
        guard dateComponents.count == 2,
              let startDate = dateFormatter.date(from: dateComponents[0]),
              let endDate = dateFormatter.date(from: dateComponents[1]) else {
            print("Error parsing dateRange")
            return
        }
        
        db.collection("sleepLogs").addDocument(data: [
            "id": log.id.uuidString,
            "hours": log.hours,
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "sleepType": log.sleepType.rawValue,
            "userId": Auth.auth().currentUser?.uid ?? "unknown"  // Ensure you handle user authentication appropriately
        ]) { error in
            if let error = error {
                print("Error saving sleep log to Firestore: \(error.localizedDescription)")
            } else {
                print("Sleep log saved successfully to Firestore")
            }
        }
    }



}

// Views
struct SleepRingView: View {
    var sleepData: [(type: SleepType, hours: Double)]
    var sleepGoal: Double
    
    var body: some View {
        ZStack {
            // Placeholder or sleep data rings
            if sleepData.isEmpty {
                VStack {
                    Image(systemName: "moon.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color.gray.opacity(0.5))
                    Text("No Sleep Data")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("Wear your device to bed to track your sleep.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                .padding(20)
            } else {
                ForEach(Array(sleepData.enumerated()), id: \.element.type) { index, data in
                    Circle()
                        .trim(from: 0, to: CGFloat(data.hours / sleepGoal))
                        .stroke(color(for: data.type), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: data.hours)
                        .padding(CGFloat(index) * 24)
                }
                // Summary text showing total hours slept and goal
                VStack {
                    Text("\(sleepData.map { $0.hours }.reduce(0, +), specifier: "%.1f") hrs")
                        .font(.title)
                        .foregroundColor(.black) // Changed text color to black
                    Text("of \(sleepGoal, specifier: "%.1f") hrs goal")
                        .foregroundColor(.black.opacity(0.7)) // Changed text color to black with reduced opacity
                }
            }
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
    }
    
    private func color(for type: SleepType) -> Color {
        switch type {
        case .deep:
            return Color.blue.opacity(0.8)
        case .light:
            return Color.green.opacity(0.8)
        case .awake:
            return Color.red.opacity(0.8)
        }
    }
}


struct SleepTrackingView: View {
    @StateObject private var viewModel = SleepTrackerViewModel()
    @State private var showingSleepGoalModal = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Your Sleep Analysis")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    SleepRingView(sleepData: viewModel.sleepLogs.map { ($0.sleepType, $0.hours) }, sleepGoal: viewModel.sleepGoal)
                        .frame(height: 300)
                        .padding(.horizontal)

                    if viewModel.sleepLogs.isEmpty {
                        VStack {
                            Text("Getting Started with Sleep Tracking")
                                .font(.headline)
                                .padding()
                            Text("Here are some tips to improve your sleep quality:")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            List {
                                Text("Maintain a regular sleep schedule.")
                                Text("Create a restful sleeping environment.")
                                Text("Limit exposure to screens before bedtime.")
                            }
                            .listStyle(PlainListStyle())
                        }
                        .padding()
                    } else {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.sleepLogs) { log in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(log.sleepType.rawValue)
                                            .font(.headline)
                                        Text(log.dateRange)
                                            .font(.caption)
                                    }
                                    Spacer()
                                    Text("\(log.hours, specifier: "%.1f") hrs")
                                }
                                .padding(.horizontal)
                                .padding(.top)
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationBarTitle("Sleep Tracker", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showingSleepGoalModal = true
            }) {
                Image(systemName: "pencil.circle")
                    .imageScale(.large)
            })
            .sheet(isPresented: $showingSleepGoalModal) {
                SleepGoalSettingView(viewModel: viewModel)
            }
        }
    }
}

struct SleepGoalSettingView: View {
    @ObservedObject var viewModel: SleepTrackerViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Set Your Sleep Goal")
                    .font(.headline)
                    .padding(.top)
                
                DatePicker("Start Time", selection: $viewModel.sleepStartTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())

                DatePicker("End Time", selection: $viewModel.sleepEndTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
            }
            .padding()
            .navigationTitle("Sleep Goal")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Preview
struct SleepTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        SleepTrackingView()
    }
}

