//
//  ApiManagerContract.swift
//  WeatherTestPoj
//
//  Created by Heorhii Churikov on 29.03.2022.
//

import Foundation

enum Method:String {
case GET
case POST
}

enum RequestsErrors:Error {
case invalideURLString
case serverOutputError
case typecastError
}


protocol ApiManagerContract {
    func sendRequest<Output:Codable>(type:Output.Type ,method:Method,
                                     requestType:Requests, data:Data?,
                                     complition:
                                     @escaping((Output?,RequestsErrors?)->()))
}
