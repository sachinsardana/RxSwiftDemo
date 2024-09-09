//
//  NetworkServiceProtocol.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//

import RxSwift

protocol NetworkServiceProtocol {
    func fetchPosts() -> Observable<[PostModel]>
}
