//
//  PostPersistentDataService.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//

import CoreData

class PostPersistentDataService {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataSetup.shared.context) {
        self.context = context
    }
    
    func savePosts(_ posts: [PostModel]) {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        do {
            let existingPosts = try context.fetch(fetchRequest)
            var uniquePostsDict = [Int: PostEntity]()
                  for postEntity in existingPosts {
                      let id = Int(postEntity.id)
                      if uniquePostsDict[id] == nil {
                          uniquePostsDict[id] = postEntity
                      }
                  }
            
            for post in posts {
                if let existingPostEntity = uniquePostsDict[post.id] {
                    existingPostEntity.title = post.title
                    existingPostEntity.body = post.body
                } else {
                    let postEntity = PostEntity(context: context)
                    postEntity.id = Int64(post.id)
                    postEntity.title = post.title
                    postEntity.body = post.body
                    postEntity.isfavorite = false
                }
            }
            saveContext()
        } catch {
            print("Failed to save posts: \(error)")
        }
    }
        
    func loadPosts() -> [PostModel] {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        do {
            let postEntities = try context.fetch(fetchRequest)
            return postEntities.map { postEntity in
                PostModel(
                    id: Int(postEntity.id),
                    body: postEntity.body ?? "", 
                    title: postEntity.title ?? "",
                    isfavorite: postEntity.isfavorite
                )
            }
        } catch {
            print("Failed to fetch posts: \(error)")
            return []
        }
    }
    
    func addFavorite(_ post: PostModel) {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", post.id)
        do {
            let results = try context.fetch(fetchRequest)
            if let postEntity = results.first {
                postEntity.isfavorite = true
                saveContext()
            }
        } catch {
            print("Failed to remove favorite post: \(error)")
        }
    }
    
    func removeFavorite(post: PostModel) {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", post.id)
        do {
            let results = try context.fetch(fetchRequest)
            if let postEntity = results.first {
                postEntity.isfavorite = false
                saveContext()
            }
        } catch {
            print("Failed to remove favorite post: \(error)")
        }
    }
    
    func loadFavorites() -> [PostModel] {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isfavorite == YES")
        do {
            let postEntities = try context.fetch(fetchRequest)
            return postEntities.map { postEntity in
                PostModel(
                    id: Int(postEntity.id),
                    body: postEntity.body ?? "", 
                    title: postEntity.title ?? "",
                    isfavorite: postEntity.isfavorite
                )
            }
        } catch {
            print("Failed to fetch favorite posts: \(error)")
            return []
        }
    }
    
    private func saveContext() {
        CoreDataSetup.shared.saveContext()
    }
}

