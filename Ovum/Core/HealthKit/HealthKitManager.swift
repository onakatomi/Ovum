import Foundation
import HealthKit
import WidgetKit
import SwiftUI

@MainActor
class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    var healthStore = HKHealthStore()
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
    
    func requestAuthorization() {
        // The type of data we will be reading from Health (e.g stepCount)
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
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
                    self.menstrualFlow = await self.readMenstrualData(metric: .menstrualFlow)
                    self.sleep = await self.readSleepData(metric: .sleepAnalysis)
                    self.stepCountToday = await self.readMetricAsTodaysCumulative(metric: .stepCount, unit: .count()) //
                    self.HRV = await self.readMetricAsLastRecorded(metric: .heartRateVariabilitySDNN, unit: .second())
                    self.heartRate = await self.readMetricAsLastRecorded(metric: .heartRate, unit: HKUnit(from: "BPM"))
                    self.respiratoryRate = await self.readMetricAsLastRecorded(metric: .respiratoryRate, unit: HKUnit(from: "breaths/min"))
                    self.bodyTemperature = await self.readMetricAsLastRecorded(metric: .bodyTemperature, unit: .degreeCelsius())
                    self.weight = await self.readMetricAsLastRecorded(metric: .bodyMass, unit: .gramUnit(with: .kilo))
                    self.BMI = await self.readMetricAsLastRecorded(metric: .bodyMassIndex, unit: .count())
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
            
            // Use the count here.
            let metricString: String = String(describing: count!)
            return metricString
        } catch {
            print("Failed to read metric")
        }
        return nil
    }
    
    @MainActor
    func readMetricAsLastRecorded(metric: HKQuantityTypeIdentifier, unit: HKUnit) async -> String? {
        do {
            // Define the type.
            let metric = HKQuantityType(metric)
            
            // Create the descriptor.
            let descriptor = HKSampleQueryDescriptor(
                predicates:[.quantitySample(type: metric)],
                sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
                limit: 10
            )
            
            // Launch the query and wait for the results.
            let results = try await descriptor.result(for: healthStore)
            
            // Get the most recent data point
            guard let lastDataPoint: HKQuantitySample = results.first else {
                return nil
            }
            
            let value: Double = lastDataPoint.quantity.doubleValue(for: unit)
            
            let metricString: String
            if (unit == .count()) {
                metricString = "\(value)"
            } else {
                metricString = "\(value) \(unit.unitString)"
            }
            
            return metricString
//            let value = lastDataPoint.HKSample.
        } catch {
            print("Failed to read last recorded metric")
        }
        return nil
    }
    
    @MainActor
    func readSleepData(metric: HKCategoryTypeIdentifier) async -> String? {
        do {
            // Define the type.
            let metric = HKCategoryType(metric)
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
            guard let lastDataPoint: HKCategorySample = results.first else {
                return nil
            }
            
            let timeDifference = lastDataPoint.endDate.timeIntervalSince(lastDataPoint.startDate)
            let hours = Int(timeDifference / 3600)
            let minutes = Int((timeDifference.truncatingRemainder(dividingBy: 3600)) / 60)

            let formattedTime = String(format: "%02d:%02d", hours, minutes)

            return formattedTime
        } catch {
            print("Failed to read categorical metric")
        }
        return nil
    }
    
    @MainActor
    func readMenstrualData(metric: HKCategoryTypeIdentifier) async -> String? {
        do {
            // Define the type.
            let metric = HKCategoryType(metric)
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

