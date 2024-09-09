//
//  NetworkService.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//

import Foundation
import Alamofire
import RxSwift

class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://jsonplaceholder.typicode.com"
    // Fetching Posts from network
    func fetchPosts() -> Observable<[PostModel]> {
        let url = "\(baseURL)/posts"
        return Observable.create { observer in
            AF.request(url).responseDecodable(of: [PostModel].self) { response in
                switch response.result {
                case .success(let posts):
                    let sortedPost = posts.sorted(by: {$0.id < $1.id})
                    observer.onNext(sortedPost)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
