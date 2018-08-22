//
//  MovieDBAPI.swift
//  Movs
//
//  Created by Adolfho Athyla on 04/07/2018.
//  Copyright © 2018 a7hyla. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireJsonToObjects
import EVReflection

class MovieDBAPI: NSObject {

    static let baseURI = "https://api.themoviedb.org/3"
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "api-key") as? String
    
    static var alamofireManager: Alamofire.SessionManager?
    
    //MARK: - Alamofire
    static func configAlamofire() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 50
        configuration.allowsCellularAccess = true
        MovieDBAPI.alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    //MARK: - GENRE
    static func loadGenres(completion: @escaping ((_ genres: Genres?) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MovieDBAPI.configAlamofire()
        let uriRequest = baseURI + "/genre/movie/list"
        let parameters: Parameters = [
            "api_key": self.apiKey ?? ""
        ]
        
        MovieDBAPI.alamofireManager?.request(uriRequest, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<Genres>) in
            if let responseR = response.response {
                switch responseR.statusCode {
                case 200:
                    if let result = response.result.value {
                        completion(result)
                    } else {
                        completion(nil)
                    }
                    break
                default:
                    completion(nil)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    //MARK: - POPULAR
    static func loadPopularMovies(page: Int = 1, completion: @escaping ((_ popular: Popular?) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        MovieDBAPI.configAlamofire()
        let uriRequest = baseURI + "/movie/popular"
        let parameters: Parameters = [
            "api_key": self.apiKey ?? "",
            "page": page
        ]
        
        MovieDBAPI.alamofireManager?.request(uriRequest, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseObject(completionHandler: { (response: DataResponse<Popular>) in
            if let responseR = response.response {
                switch responseR.statusCode {
                case 200:
                    if let result = response.result.value {
                        print(result)
                        completion(result)
                    } else {
                        completion(nil)
                    }
                default:
                    completion(nil)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        })
    }
    
}
