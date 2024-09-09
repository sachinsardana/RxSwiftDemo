//
//  PostPersistentDataServiceProtocol.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//

import Foundation
protocol PostPersistentDataServiceProtocol {
    func savePosts(_ posts: [PostModel])
    func loadPosts() -> [PostModel]
    func addFavorite(post: PostModel)
    func removeFavorite(post: PostModel)
    func loadFavorites() -> [PostModel]
}
