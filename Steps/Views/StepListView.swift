//
//  StepListView.swift
//  Steps
//
//  Created by Forough on 9/15/1403 AP.
//

import SwiftUI

struct StepListView: View {
    
    let steps: [Step]
    
    
    var body: some View {
        List(steps) { step in
            HStack {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(isunder(8000, count: step.count) ? .red : .green)
                
                Text("\(step.count)")
                Spacer()
                Text(step.date.formatted(date: .abbreviated, time: .omitted))
            }
        }.listStyle(.plain)
    }
}

#Preview {
    StepListView(steps: [])
}
