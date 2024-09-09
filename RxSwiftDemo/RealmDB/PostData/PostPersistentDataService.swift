//
//  PostPersistentDataService.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 04/09/24.
//

import RealmSwift

class PostPersistentDataService: PostPersistentDataServiceProtocol {
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    func savePosts(_ posts: [PostModel]) {
        do {
            try realm.write {
                for post in posts {
                    if let existingPost = realm.object(ofType: PostRealmModel.self, forPrimaryKey: post.id) {
                        existingPost.title = post.title
                        existingPost.body = post.body
                    } else {
                        let postRealmModel = PostRealmModel()
                        postRealmModel.id = post.id
                        postRealmModel.title = post.title
                        postRealmModel.body = post.body
                        postRealmModel.isFavorite = false
                        realm.add(postRealmModel)
                    }
                }
            }
        }
        catch {
            print("Failed to save posts: \(error)")
        }
    }
    
    func loadPosts() -> [PostModel] {
        let postRealmModels = realm.objects(PostRealmModel.self)
        return postRealmModels.map { postRealmModel in
            PostModel(
                id: postRealmModel.id,
                body: postRealmModel.body,
                title: postRealmModel.title,
                isfavorite: postRealmModel.isFavorite
            )
        }.sorted(by: { $0.id < $1.id })
    }
    
    func addFavorite(post: PostModel) {
        do {
            try realm.write({
                if let postEntity = realm.object(ofType: PostRealmModel.self, forPrimaryKey: post.id) {
                    postEntity.isFavorite = true
                }
            })
        }
        catch {
            print("Failed to favorite posts: \(error)")
        }
    }
    
    func removeFavorite(post: PostModel) {
        do {
            try realm.write({
                if let postEntity = realm.object(ofType: PostRealmModel.self, forPrimaryKey: post.id) {
                    postEntity.isFavorite = false
                }
            })
        }
        catch {
            print("Failed to favorite posts: \(error)")
        }
    }
    
    func loadFavorites() -> [PostModel] {
        let favoritePosts = realm.objects(PostRealmModel.self).filter("isFavorite == true")
        return favoritePosts.map { favPost in
            PostModel(
                id: Int(favPost.id),
                body: favPost.body,
                title: favPost.title,
                isfavorite: favPost.isFavorite
            )
        }
    }
}
