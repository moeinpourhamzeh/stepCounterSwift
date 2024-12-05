//
//  TodayStepView.swift
//  Steps
//
//  Created by Forough on 9/15/1403 AP.
//

import SwiftUI

struct TodayStepView: View {
    
    let step: Step
    
    var body: some View {
        VStack {
            Text("\(step.count)")
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        .overlay(alignment: .topLeading) {
            HStack {
                Image(systemName: "flame")
                    .foregroundStyle(.red)
                Text("Steps")
            }.padding()
        }
        .overlay(alignment: .bottomTrailing) {
            Text(step.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .padding()
        }
    }
}
