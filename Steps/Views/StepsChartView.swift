//
//  StepsChartView.swift
//  Steps
//
//  Created by Forough on 9/15/1403 AP.
//

import SwiftUI
import Charts

@available(iOS 16.0, *)
struct StepsChartView: View {
    
    let steps: [Step]
    
    @available(iOS 16.0, *)
    var body: some View {
        Chart {
            ForEach(steps) { step in
                if #available(iOS 16.0, *) {
                    BarMark(x: .value("Date", step.date), y: .value("Count", step.count))
                        .foregroundStyle(isunder(8000, count: step.count) ? .red : .green)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }
}
