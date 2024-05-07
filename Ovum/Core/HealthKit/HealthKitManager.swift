import Foundation
import HealthKit
import WidgetKit
import SwiftUI

@MainActor
class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    var healthStore = HKHealthStore()
    
    @Published var haveAccess: Bool = false
    @Published var stepCountToday: String?
    @Published var HRV: String?
    @Published var heartRate: String?
    @Published var respiratoryRate: String?
    @Published var bodyTemperature: String?
    @Published var weight: String?
    @Published var BMI: String?
    @Published var sleep: String?
    @Published var menstrualFlow: String?
    
    init() {
        requestAuthorization()
    }
    
    func summariseCurrentData() -> String {
        var mainString = ""
        var metrics: [String] = []
        
        // Capture metrics
        if let metric = stepCountToday { metrics.append("- Steps: \(metric)") }
        if let metric = HRV { metrics.append("- Heart Rate Variability: \(metric)") }
        if let metric = heartRate { metrics.append("- Heart Rate: \(metric)") }
        if let metric = respiratoryRate { metrics.append("- Respiratory Rate: \(metric)") }
        if let metric = bodyTemperature { metrics.append("- Body Temperature: \(metric)") }
        if let metric = weight { metrics.append("- Weight: \(metric)") }
        if let metric = BMI { metrics.append("- BMI: \(metric)") }
        if let metric = sleep {
            if metric != "00:00" {
                metrics.append("- Sleep: \(metric)")
            }
        }
        if let metric = menstrualFlow { metrics.append("- Menstrual Flow: \(metric)") }
        
        if metrics.isEmpty { return "" } else {
            mainString += "\n\n**Apple Health Metrics:**\n"
            for metric in metrics {
                mainString += metric + "\n" // Append each string with a space
            }
            return mainString
        }
    }
    
    @MainActor
    func requestAuthorization() {
        // The type of data we will be reading from Health (e.g stepCount)
        let toReads = Set([
            HKQuantityType(.stepCount),
            HKQuantityType(.heartRateVariabilitySDNN),
            HKQuantityType(.heartRate),
            HKQuantityType(.respiratoryRate),
            HKQuantityType(.bodyTemperature),
            HKQuantityType(.bodyMass),
            HKQuantityType(.bodyMassIndex),
            HKCategoryType(.sleepAnalysis),
            HKCategoryType(.menstrualFlow)
        ])
        
        // Check that user's Heath Data is avaialble.
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data not available.")
            return
        }
        
        // Ask for permission to user's Health Data
        // toShare is set to nil as not updating any data
        healthStore.requestAuthorization(toShare: nil, read: toReads) {
            success, error in
            if success {
                Task {
                    self.haveAccess = true
                    self.fetchSleepData { totalSleepTime in
                        if let totalSleepTime = totalSleepTime {
                            print("User slept for \(totalSleepTime) seconds last night.")
                            let hours = Int(totalSleepTime / 3600)
                            let minutes = Int((totalSleepTime.truncatingRemainder(dividingBy: 3600)) / 60)
                            let formattedTime = String(format: "%02d:%02d", hours, minutes)
                            DispatchQueue.main.async {
                                self.sleep = formattedTime
                            }
                        } else {
                            print("No sleep data available for last night.")
                        }
                    }
                    self.heartRate = await self.readMetricAsLastRecorded(metric: .heartRate, unit: HKUnit(from: "count/min"))
                    self.stepCountToday = await self.readMetricAsTodaysCumulative(metric: .stepCount, unit: .count()) //
                    self.HRV = await self.readMetricAsLastRecorded(metric: .heartRateVariabilitySDNN, unit: .secondUnit(with: .milli))
                    self.respiratoryRate = await self.readMetricAsLastRecorded(metric: .respiratoryRate, unit: HKUnit(from: "count/min"))
                    self.bodyTemperature = await self.readMetricAsLastRecorded(metric: .bodyTemperature, unit: .degreeCelsius())
                    self.weight = await self.readMetricAsLastRecorded(metric: .bodyMass, unit: .gramUnit(with: .kilo))
                    self.BMI = await self.readMetricAsLastRecorded(metric: .bodyMassIndex, unit: .count())
                    self.menstrualFlow = await self.readMenstrualData()
//                    self.sleep = await self.readSleepData2()
                }
            } else {
                print("\(String(describing: error))")
            }
        }
    }
    
    // Obtain the user's steps for today.
    @MainActor
    func readMetricAsTodaysCumulative(metric: HKQuantityTypeIdentifier, unit: HKUnit) async -> String? {
        do {
            // Create a predicate for today's samples.
            let calendar = Calendar(identifier: .gregorian)
            let startDate = calendar.startOfDay(for: Date())
            let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
            let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            
            // Create the query descriptor.
            let metricType = HKQuantityType(metric)
            let metricToday = HKSamplePredicate.quantitySample(type: metricType, predicate: today)
            let sumOfQuery = HKStatisticsQueryDescriptor(predicate: metricToday, options: .cumulativeSum)
            
            // Run the query.
            let count = try await sumOfQuery.result(for: healthStore)?
                .sumQuantity()?
                .doubleValue(for: unit)
            
            if (count == nil) {
                return nil
            } else {
                // Use the count here.
                let metricString: String = String(describing: Int(count!))
                return metricString
            }
        } catch {
            print("Failed to read \(metric)")
        }
        return nil
    }
    
    @MainActor
    func readMetricAsLastRecorded(metric: HKQuantityTypeIdentifier, unit: HKUnit) async -> String? {
        do {
            // Define the type.
            let metricType = HKQuantityType(metric)
            
            // Create the descriptor.
            let descriptor = HKSampleQueryDescriptor(
                predicates: [.quantitySample(type: metricType), ],
                sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
                limit: 10
            )
            
            // Launch the query and wait for the results.
            let results = try await descriptor.result(for: healthStore)
            
            // Get the most recent data point
            guard let lastDataPoint: HKQuantitySample = results.first else {
                return nil
            }
            
            // We only proceed if we have a recording for today.
            let timestamp = lastDataPoint.endDate
            let _ = getDateAsString(date: timestamp)
            let isMetricRecordedToday: Bool = Calendar.current.isDateInToday(timestamp)
            if (!isMetricRecordedToday) {
                return nil
            }
            
            let value: Double = lastDataPoint.quantity.doubleValue(for: unit)
            
            let metricString: String
            if (unit == .count() || unit == HKUnit(from: "count/min")) {
                metricString = "\(Int(value)) \(makeUnitsPretty(metric: metric, unit: unit))"
            } else {
                let truncated = trunc(value * 10) / 10
                let string = String(format: "%.1f", truncated)
                metricString = "\(string) \(makeUnitsPretty(metric: metric, unit: unit))"
            }
            
            return metricString
//            let value = lastDataPoint.HKSample.
        } catch {
            print("Failed to read last recorded metric: \(metric)")
        }
        return nil
    }
    
    func makeUnitsPretty(metric: HKQuantityTypeIdentifier, unit: HKUnit) -> String {
        switch (metric) {
        case .heartRate:
            return "BPM"
        case .heartRateVariabilitySDNN:
            return "ms"
        case .respiratoryRate:
            return "breaths/minute"
        case .bodyTemperature:
            return "°C"
        case .heartRate:
            return "BPM"
        default:
            return "\(unit)"
        }
    }
    
    @MainActor
    func readSleepData() async -> String? {
        do {
            // Define the type.
            let metric = HKCategoryType(.sleepAnalysis)
            
            // Create the descriptor.
            let descriptor = HKSampleQueryDescriptor(
                predicates:[.categorySample(type: metric)],
                sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
                limit: 10
            )
            
            // Launch the query and wait for the results.
            let results = try await descriptor.result(for: healthStore)
            
            // Get the most recent data point
            guard let lastDataPoint: HKCategorySample = results.first else {
                return nil
            }
            
            // We only proceed if we have a recording for today.
            let timestamp2 = lastDataPoint.startDate
            let timestamp = lastDataPoint.endDate
            let _ = getDateAsString(date: timestamp2)
            let _ = getDateAsString(date: timestamp)
            let isMetricRecordedToday: Bool = Calendar.current.isDateInToday(timestamp)
            if (!isMetricRecordedToday) {
                return nil
            }
            
            let timeDifference = lastDataPoint.endDate.timeIntervalSince(lastDataPoint.startDate)
            let hours = Int(timeDifference / 3600)
            let minutes = Int((timeDifference.truncatingRemainder(dividingBy: 3600)) / 60)

            let formattedTime = String(format: "%02d:%02d", hours, minutes)

            return formattedTime
        } catch {
            print("Failed to read sleep data")
        }
        return nil
    }
    
    @MainActor
    func fetchSleepData(completion: @escaping (TimeInterval?) -> Void) {
        let calendar = Calendar.current

        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -1, to: endDate)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { _, results, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let results = results as? [HKCategorySample] else {
                print("No data to display")
                return
            }

//            print("Start Date: \(startDate), End Date: \(endDate)")
//            print("Fetched \(results.count) sleep analysis samples.")

            var totalSleepTime: TimeInterval = 0

            for result in results {
                if let type = HKCategoryValueSleepAnalysis(rawValue: result.value) {
                    if HKCategoryValueSleepAnalysis.allAsleepValues.contains(type) {
                        let sleepDuration = result.endDate.timeIntervalSince(result.startDate)
//                        print("""
//                        Sample start: (result.startDate), \
//                        end: (result.endDate), \
//                        value: (result.value), \
//                        duration: (sleepDuration) seconds
//                        """)
                        totalSleepTime += sleepDuration
                    }
                }
            }

            completion(totalSleepTime)
        }

        healthStore.execute(query)
    }
    
    @MainActor
    func readMenstrualData() async -> String? {
        do {
            // Define the type.
            let metric = HKCategoryType(.menstrualFlow)
//            let metric = HKQuantityType(metric)
            
            // Create the descriptor.
            let descriptor = HKSampleQueryDescriptor(
                predicates:[.categorySample(type: metric)],
                sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
                limit: 10
            )
            
            // Launch the query and wait for the results.
            let results = try await descriptor.result(for: healthStore)
            
            // Get the most recent data point
            guard let lastDataPoint = results.first else {
                return nil
            }
            
            // We only proceed if we have a recording for today.
            let timestamp = lastDataPoint.startDate
            let _ = getDateAsString(date: timestamp)
            let isMetricRecordedToday: Bool = Calendar.current.isDateInToday(timestamp)
            if (!isMetricRecordedToday) {
                return nil
            }
            
            let flow = HKCategoryValueMenstrualFlow.init(rawValue: lastDataPoint.value)
            
            switch (flow) {
                case .unspecified:
                    return "Unspecified Flow"
                case Optional<HKCategoryValueMenstrualFlow>.none:
                    return "No Flow"
                case .light:
                    return "Light Flow"
                case .medium:
                    return "Medium Flow"
                case .heavy:
                    return "Heavy Flow"
                case .some(.none):
                    return "Some"
                case .some(_):
                    return "Some"
            }
        } catch {
            print("Failed to read categorical metric")
        }
        return nil
    }
}

