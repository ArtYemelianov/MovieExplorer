//
//  NetworkService.swift
//  MovieExplorer
//
//  Created by artus on 31.08.2018.
//  Copyright © 2018 artus. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    
    class func request(url: String) -> Resource{
        
        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url:URL(string: "\(url)")!)
        request.httpMethod = "GET"

        var resource : Resource?
        Alamofire.request(request)
            .validate()
            .responseJSON{ response in
                guard response.result.isSuccess else{
                    let err = "Error \(response.response?.statusCode) while request \(String(describing: response.result.error))"
                    resource = Resource(status: false, list: nil, message: err)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(GenreResponse.self, from: response.data!)
                    //TODO init resource
                } catch {
                    let err = "Error parsing for request \(error)"
                    resource = Resource(status: false, list: nil, message: err)
                }
                semaphore.signal()
                
        }
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return resource!
    }
}
