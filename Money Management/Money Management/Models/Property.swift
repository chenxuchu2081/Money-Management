//
//  Property.swift
//  Money Management
//
//  Created by CHEN Xuchu on 1/9/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation

//protocol Calculator {
//    static func calculateTotalExpend(price: [Double]) -> Double
//    static func calculateTotalIncome(price: [Double]) -> Double
//}

class Property{
    
    public var totalProperty: Double?
    public var totalExpend: Double? = 0
    public var totalIncome: Double? = 0
    
//    init(totalExpends: Double, totalIncomes: Double) {
//        self.totalExpend = totalExpends
//        self.totalIncome = totalIncomes
//    }
    
    init() {
    }
    
    func calculateTotalExpend(price prices: [Double]){
        var sums: Double = 0
        for price in prices{
            sums += price
        }
        self.totalExpend = sums
    }
    
    func calculateTotalIncome(price prices: [Double]){
        var sums: Double = 0
        for price in prices{
            sums += price
        }
        self.totalIncome = sums
    }
    
    func calculateTotalProperty(){
        self.totalProperty = self.totalIncome! - self.totalExpend!
    }
    
    func calculateEachTypeTotalPrice(total: [Double]) -> Double{
        var totalPrice : Double = 0
        for eachPrices in total{
            totalPrice += eachPrices
        }
        return totalPrice
    }
    
}
