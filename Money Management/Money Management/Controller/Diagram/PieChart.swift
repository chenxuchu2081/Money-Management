//
//  PieChart.swift
//  Money Management
//
//  Created by CHEN Xuchu on 4/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation
import Charts

class PieChart{
    
    static func setupPieChart(pieView: PieChartView, NameSet: Set<String>) {
        
        pieView.chartDescription?.enabled = false
        pieView.drawHoleEnabled = false
        pieView.rotationAngle = 0
        //pieView.rotationEnabled = false
        pieView.isUserInteractionEnabled = false
        pieView.legend.horizontalAlignment = .center
        //pieView.legend.enabled = false
        // entry label styling
        pieView.entryLabelColor = .black
        pieView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        var entries: [PieChartDataEntry] = Array()
        for name in NameSet.sorted(){
            entries.append(PieChartDataEntry(value: 50.0, label: name))
        }

        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
//        let c1 = NSUIColor(hex: 0x3A015C)
//        let c2 = NSUIColor(hex: 0x4F0147)
//        let c3 = NSUIColor(hex: 0x35012C)
//        let c4 = NSUIColor(hex: 0x290025)
//        let c5 = NSUIColor(hex: 0x11001C)
//
//        dataSet.colors = [c1, c2, c3, c4, c5]
        dataSet.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: dataSet)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        dataSet.drawValuesEnabled = false
        
        pieView.data = PieChartData(dataSet: dataSet)
    }
    
    static func updataPieChartData(pieView: PieChartView){
        pieView.data = nil
        //PieChart.setupPieChart(pieView: pieView, NameSet: chartName)
    }
    
    
}

extension NSUIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid red component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
}
