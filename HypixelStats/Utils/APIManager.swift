//
//  APIManager.swift
//  HypixelStats
//
//  Created by codeplus on 7/15/21.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIManager {
    
    static func getJSON(specific_url: String, completion:@escaping (JSON) -> ()) {
        
        print(specific_url)
        
        AF.request(specific_url).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    DispatchQueue.main.async {
                        completion(json)
                    }
                case .failure(let error):
                    print(error)
                    completion(JSON(""))
            }
        }
    }
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
}
