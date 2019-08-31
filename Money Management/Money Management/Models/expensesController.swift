//
//  expensesController.swift
//  Money Management
//
//  Created by CHEN Xuchu on 20/8/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation

class expensesController: NSObject{
    
    private var expenseList = [expenses]()
    
    var numberOfExpense:Int{
        return expenseList.count
    }
    
    subscript(index: Int) -> expenses{
        get{
            return expenseList[index]
        }
        set{
            expenseList[index] = newValue
        }
        
    }
    
    func addExpense(data: expenses){
        expenseList.append(data)
    }
    
    func removeExpense(index: Int){
        if expenseList.count < 1{
            return 
        }
        expenseList.removeLast()
    }
    
    
    func printAll(){
        for all in expenseList{
            print(all)
        }
    }
    
    
    func printNumberOfExpense(){
        print("the number of Expenses is: \(expenseList.count)")
    }
    
    
    
}
