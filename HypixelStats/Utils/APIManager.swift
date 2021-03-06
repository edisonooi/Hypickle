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
        
        AF.request(url).responseJSON { response in
            switch response.result {
                case .success(let value):
                    if let httpStatusCode = response.response?.statusCode {
                        switch httpStatusCode {
                        case 200:
                            let json = JSON(value)
                            completion(json)
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
    
    static func getSkinFromUUID(uuid: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let skinAPIURL = URL(string: "https://crafatar.com/renders/body/\(uuid)?default=MHF_Steve&overlay=true")!
        URLSession.shared.dataTask(with: skinAPIURL, completionHandler: completion).resume()
    }
    
    static func getHeadFromUUID(uuid: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let headAPIURL = URL(string: "https://crafatar.com/avatars/\(uuid)?default=MHF_Steve&overlay=true")!
        URLSession.shared.dataTask(with: headAPIURL, completionHandler: completion).resume()
    }
    
    
    
}
