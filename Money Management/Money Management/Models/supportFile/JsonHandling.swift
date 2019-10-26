//
//  JsonHandling.swift
//  Money Management
//
//  Created by CHEN Xuchu on 11/10/2019.
//  Copyright © 2019 CHEN Xuchu. All rights reserved.
//

import Foundation

struct JsonRead {
    static func readJSONFromFile(fileName: String) -> Any?
    {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json"){
            do{
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            }catch{
                
            }
        }
        return json
    }
}
