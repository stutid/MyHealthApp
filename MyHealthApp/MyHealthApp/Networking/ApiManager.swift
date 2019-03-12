//
//  ApiManager.swift
//  MyHealthApp
//
//  Created by Stuti on 12/10/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import Foundation

class ApiManager {
    
    private let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        let session = URLSession(configuration: config)
        return session
    }()
    
    func fetchData(with urlString: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                completionHandler(data, error)
            }
            task.resume()
        }
        else {
            let error = NSError()
            completionHandler(nil,error)
        }
    }
    
    func postData(with urlString: String,and parameters: [String: String] = [:], completionHandler: @escaping (Data?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            }
            catch {
                print(error)
            }
            
            let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
                completionHandler(data, error)
            }
            task.resume()
        }
        else {
            let error = NSError()
            completionHandler(nil,error)
        }
    }
}
