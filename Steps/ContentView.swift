//
//  ContentView.swift
//  Steps
//
//  Created by Forough on 9/15/1403 AP.
//

import SwiftUI


enum DisplayType: Int, Identifiable, CaseIterable {
    case list
    case chart
    
    var id: Int {
        rawValue
    }
}

extension DisplayType {
    var icon: String {
        switch self {
        case .list:
            return "list.bullet"
        case .chart:
            return "chart.bar"
        }
    }
}


struct ContentView: View {
    
    @State private var healthStore = HealthStore()
    @State private var displayType: DisplayType = .list
    
    private var steps: [Step] {
        healthStore.steps.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var body: some View {
        VStack {
            if let step = steps.first {
                TodayStepView(step: step)
            }
            
            Picker("Selection", selection: $displayType) {
                ForEach(DisplayType.allCases) { displayType in
                    Image(systemName: displayType.icon).tag(displayType)
                }
            }.pickerStyle(.segmented)
            
            switch displayType {
                case .list:
                    StepListView(steps: Array(steps.dropFirst()))
                case .chart:
                if #available(iOS 16.0, *) {
                    StepsChartView(steps: steps)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .task {
            await healthStore.requestAuthorisation()
            do {
                try await healthStore.calculateSteps()
            } catch {
                print(error)
            }
        }
        .padding()
        .navigationTitle("Step By Step")
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            ContentView()
        }
    } else {
        // Fallback on earlier versions
    }
}
