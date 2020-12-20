//
//  URLSessionManager.swift
//  QuantumSitTask
//
//  Created by Yousef on 12/9/20.
//

import Foundation

class URLSessionManager {
    
    private init() {
        session = URLSession(configuration: .default)
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let myDict = NSDictionary(contentsOfFile: path),
              let baseUrl = myDict.object(forKey: "BaseURL") as? String,
              let apiKey = myDict.object(forKey: "APIAccessKey") as? String else {
                assert(false, "BaseURL or APIAccessKey not found in Config.plist")
        }
        self.baseURL = baseUrl
        self.apiKey = apiKey
    }
    
    private let session: URLSession
    let baseURL: String!
    let apiKey: String!
    public static let shared = URLSessionManager()
    
    func request(endpoint: Endpoint, headers: [String: String]? = nil,
                 queryParams: [String: String]? = nil,
                 bodyParams: [String: Any]? = nil,
                 completion: @escaping (Data?, URLResponse?, Error?)-> Void) {
        
        let fullURL = baseURL + endpoint.rawValue
        var urlComponents = URLComponents(string: fullURL)
        
        var queryParams = queryParams == nil ? ["access_key": apiKey] : queryParams!
        queryParams["access_key"] = apiKey
        urlComponents?.query = queryString(fromDict: queryParams)
        
        guard let url = urlComponents?.url else {fatalError("Invalid URL: \(fullURL)")}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        headers?.forEach{ (key, val) in urlRequest.addValue(val, forHTTPHeaderField: key) }
        
        if let bodyParams = bodyParams {
            urlRequest.httpBody = setupBodyParams(params: bodyParams)
        }
        
        session.dataTask(with: urlRequest) { data, res, err in
            completion(data, res, err)
        }.resume()
        
    }
    
    private func queryString(fromDict dict: [String: Any])-> String? {
        return dict.map { key, val in "\(key)=\(val)" }.joined(separator: "&")
    }
    
    private func setupBodyParams(params: [String: Any])-> Data {
        do {
            return try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            fatalError("Error Encoding Parameters")
        }
    }
    
}
