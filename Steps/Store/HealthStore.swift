//
//  HealthStore.swift
//  Steps
//
//  Created by Forough on 9/15/1403 AP.
//

import Foundation
import HealthKit
import Observation

enum HealthError: Error {
    case healthDataNotAvailable
}


class HealthStore: ObservableObject {
    
    var steps: [Step] = []
    var healthStore: HKHealthStore?
    var lastError: Error?
    
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            lastError = HealthError.healthDataNotAvailable
        }
        
        let calendar = Calendar(identifier: .gregorian)
        steps = [
            Step(count: 6097, date: calendar.date(byAdding: .day, value: -6, to: Date()) ?? Date()),
            Step(count: 11850, date: calendar.date(byAdding: .day, value: -5, to: Date()) ?? Date()),
            Step(count: 7709, date: calendar.date(byAdding: .day, value: -4, to: Date()) ?? Date()),
            Step(count: 10200, date: calendar.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
            Step(count: 10030, date: calendar.date(byAdding: .day, value: -2, to: Date()) ?? Date()),
            Step(count: 12530, date: calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date())
        ]
        
    }
    
    func calculateSteps() async throws {
        guard let healthStore = self.healthStore else { return }

        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.date(byAdding: .day, value: -7, to: Date())
        let endDate = Date()
        
        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day: 1)
        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)
        
        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endDate, intervalComponents: everyDay)
        
         let stepsCount = try await sumOfStepsQuery.result(for: healthStore)
        
        guard let startDate = startDate else { return }
        
        stepsCount.enumerateStatistics(from: startDate, to: endDate) {statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            if step.count > 0 {
                // add the step in steps array
                self.steps.append(step)
            }
        }
    }
    
    func requestAuthorisation() async {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else { return }
        guard let healthStore = self.healthStore else { return }
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: [stepType])
        } catch {
            lastError = error
        }
    }
}
