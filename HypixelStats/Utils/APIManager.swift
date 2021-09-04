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
    
    static func getJSON(url: String, completion:@escaping (JSON) -> ()) {
        
        print(url)
        
        AF.request(url).responseJSON { response in
            switch response.result {
                case .success(let value):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            let json = JSON(value)
                            DispatchQueue.main.async {
                                completion(json)
                            }
                        case 400:
                            completion(JSON(["failure": "Error: Invalid query, please contact app support"]))
                        case 403:
                            completion(JSON(["failure": "Error: Invalid API key, please contact app support"]))
                        case 429:
                            completion(JSON(["failure": "Error: Too many requests, please contact app support"]))
                        default:
                            completion(JSON(""))
                        }
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
