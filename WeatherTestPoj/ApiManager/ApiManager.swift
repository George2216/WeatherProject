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
            DispatchQueue.main.async {
                
            
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
        }
        task.resume()
    }
    
   
}

enum Requests {
    private var firstApiKey:String {
        "676dcad6869d54f57a00be0eae45e464"
    }

    private var secondApiKey:String {
        "1751a0eba0566f490cd827d75e38dfb7"
    }
    case getMainWeatherData(lat:Double,lon:Double)
    case getCityes(name:String)
    var urlString:String {
        switch self {
        case .getMainWeatherData(lat: let lat, lon: let lon):
            return "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(firstApiKey)"
        case .getCityes(name: let name):
            return "http://api.positionstack.com/v1/forward?access_key=\(secondApiKey)&query=\(name)"
        }
    }
}
