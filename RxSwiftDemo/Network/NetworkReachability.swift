//
//  NetworkReachability.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//

import Foundation
import Alamofire

enum NetworkReachability {
    static func isNetworkReachable() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
