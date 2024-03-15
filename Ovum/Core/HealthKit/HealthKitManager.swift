import Foundation
import HealthKit
import WidgetKit

@MainActor
class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    var healthStore = HKHealthStore()
    @Published var stepCountToday: Int = 0
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        // The type of data we will be reading from Health (e.g stepCount)
        let toReads = Set([ HKObjectType.quantityType(forIdentifier: .stepCount)! ])
        
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
                self.readStepCountToday() // Get steps if given access.
            } else {
                print("\(String(describing: error))")
            }
        }
    }
    
    // Obtain the user's steps for today.
    func readStepCountToday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepCountType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            self.stepCountToday = steps
        }
        healthStore.execute(query) // Takes a bit of time to execute, thus need to @Publish stepCount.
    }
}

