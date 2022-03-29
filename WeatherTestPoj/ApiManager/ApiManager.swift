//
//  ApiManager.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import Foundation


class ApiManager:ApiManagerContract {
    
    func sendRequest<Output:Codable>(type:Output.Type ,method:Method,
                                     requestType:Requests, data:Data?,
                                     complition:
                                     @escaping((Output?,RequestsErrors?)->())) {
        
        guard let url = URL(string: requestType.urlString) else {
            complition(nil, .invalideURLString)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                complition(nil, .serverOutputError)
                return
            }
            do {
                let output = try JSONDecoder().decode(Output.self, from: data)
                complition(output, nil)
                
            } catch {
                complition(nil,.typecastError)
            }

        }
        task.resume()
    }
    
   
}

enum Requests {
case getItems
case getCategories
    var urlString:String {
        switch self {
        case .getItems:
            return "https://violadent.com/AndroidAPI/new/json/feed.json"
        case .getCategories:
            return "https://violadent.com/AndroidAPI/?"
        }
    }
}
