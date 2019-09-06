//
//  LineChart.swift
//  Money Management
//
//  Created by CHEN Xuchu on 5/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation
import Charts

class LineChart{
    
    
    static func setupLineChart(pieView: LineChartView){
        
        var lineChartEntry = [ChartDataEntry]()
        for i in 0 ..< 10{
            let value = ChartDataEntry(x: Double(i), y: Double(i))
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number")
        line1.colors = [NSUIColor.blue]
        let data = LineChartData()
        data.addDataSet(line1)
        pieView.data = data
        pieView.chartDescription?.text = "Amazing chart"
    }
}
