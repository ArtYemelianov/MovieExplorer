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
    
    class func request<E>(url: String, parse: @escaping (Data) throws ->  E) -> Resource<E>{
        
        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url:URL(string: "\(url)")!)
        request.httpMethod = "GET"

        var resource : Resource<E>?
        Alamofire.request(request)
            .validate()
            .responseJSON{ response in
                guard response.result.isSuccess else{
                    let err = "Error \(response.response?.statusCode ?? -1 ) while request \(String(describing: response.result.error))"
                    resource = Resource<E>.error(msg: err)
                    return
                }
                do {
                    let result: E = try parse(response.data!)
                    resource = Resource<E>.success(data: result)
                } catch {
                    let err = "Error parsing for request \(error)"
                    resource = Resource<E>.error(msg: err)
                }
                semaphore.signal()
                
        }
        semaphore.wait(timeout: DispatchTime.distantFuture)
        return resource!
    }
}
