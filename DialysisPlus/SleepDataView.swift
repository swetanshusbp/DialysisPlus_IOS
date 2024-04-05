//
//  SleepDataView.swift
//  DialysisPlus
//
//  Created by Meghs on 23/03/24.
//


import SwiftUI
import HealthKit

struct SleepDataView: View {
    @StateObject var sleepViewModel = SleepViewModel()

    var body: some View {
        VStack {
            Text("Sleep Data")
                .font(.largeTitle)
                .padding()

            if sleepViewModel.sleepData.isEmpty {
                Text("No sleep data available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    ForEach(sleepViewModel.sleepData) { sleepSample in
                        SleepSampleView(sleepSample: sleepSample)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            sleepViewModel.requestAuthorization()
        }
    }
}

struct SleepSampleView: View {
    let sleepSample: SleepSample

    var body: some View {
        VStack(alignment: .leading) {
            Text("Start Date: \(sleepSample.startDate)")
                .font(.headline)
            Text("End Date: \(sleepSample.endDate)")
                .font(.subheadline)
            Text("Value: \(sleepSample.value)")
                .font(.subheadline)
        }
    }
}

class SleepViewModel: ObservableObject {
    let healthStore = HKHealthStore()
    @Published var sleepData: [SleepSample] = []

    func requestAuthorization() {
        let typesToRead: Set<HKObjectType> = [HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!]

        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                self.fetchSleepData()
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func fetchSleepData() {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            print("Sleep data not available")
            return
        }

        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let samples = samples else {
                print("Failed to fetch sleep data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var sleepSamples: [SleepSample] = []
            for sample in samples {
                if let sample = sample as? HKCategorySample {
                    let startDate = sample.startDate
                    let endDate = sample.endDate
                    let value = sample.value
                    let sleepSample = SleepSample(startDate: startDate, endDate: endDate, value: value)
                    sleepSamples.append(sleepSample)
                }
            }

            DispatchQueue.main.async {
                self.sleepData = sleepSamples
            }
        }

        healthStore.execute(query)
    }
}

struct SleepSample: Identifiable {
    let id = UUID()
    let startDate: Date
    let endDate: Date
    let value: Int
}

struct SleepDataView_Previews: PreviewProvider {
    static var previews: some View {
        SleepDataView()
    }
}
