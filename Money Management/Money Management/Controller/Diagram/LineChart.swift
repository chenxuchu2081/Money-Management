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
    
    var day: Int?
    var price: Double = 0
    var ishaveData: Bool?
    
    init(day: Int, price: Double, ishaveData: Bool) {
        self.day = day
        self.price = price
        self.ishaveData = ishaveData
    }
    
    static func setupLineChart(lineChart: LineChartView, price: [LineChart]){
        
        lineChart.pinchZoomEnabled = true
        
        var lineChartEntry = [ChartDataEntry]()
        for index in 0..<price.count{
            
            let value = ChartDataEntry(x: Double(price[index].day!), y: Double(price[index].price))
            lineChartEntry.append(value)
        }
        
//        for i in 0...10{
//            let value = ChartDataEntry(x: Double(i), y: Double(i))
//            lineChartEntry.append(value)
//
//        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "每日價錢")
        line1.colors = [NSUIColor.blue]
        let data = LineChartData()
        data.addDataSet(line1)
        lineChart.data = data
        lineChart.chartDescription?.text = "月表"
    }
}
