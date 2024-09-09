//
//  PostViewModel.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//
import RxSwift
import RxCocoa

class PostsViewModel {
    let posts: BehaviorRelay<[PostModel]> = BehaviorRelay(value: [])
    let favorites: BehaviorRelay<[PostModel]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()
    private let networkService: NetworkServiceProtocol
    private let persistentService: PostPersistentDataServiceProtocol
    
    init(networkService: NetworkServiceProtocol,persistentService: PostPersistentDataServiceProtocol) {
        self.networkService = networkService
        self.persistentService = persistentService
        fetchPosts()
    }
    //Fetching Posts From Network
    func fetchPosts() {
        if NetworkReachability.isNetworkReachable() {
            self.networkService.fetchPosts()
                .subscribe(onNext: { [weak self] posts in
                    guard let self = self else { return }
                    self.posts.accept(posts)
                    self.persistentService.savePosts(posts)
                    self.updateFavorites()
                })
                .disposed(by: disposeBag)
            let savedFavorites = persistentService.loadFavorites()
            favorites.accept(savedFavorites)
        } else {
            let savedPosts = persistentService.loadPosts()
            posts.accept(savedPosts)
        }
    }
    
    //Switching Post Status->Favorite/Unfavorite
    func toggleFavorite(post: PostModel) {
        var currentFavorites = favorites.value
        if let index = currentFavorites.firstIndex(where: { $0.id == post.id }) {
            currentFavorites.remove(at: index)
            persistentService.removeFavorite(post: post)
        } else {
            currentFavorites.append(post)
            persistentService.addFavorite(post: post)
        }
        favorites.accept(currentFavorites)
        
        var updatedPosts = posts.value
        if let index = updatedPosts.firstIndex(where: { $0.id == post.id }) {
            updatedPosts[index].isfavorite?.toggle()
        }
        posts.accept(updatedPosts)
        persistentService.savePosts(updatedPosts)
    }
    
    //Fetching updated favorite posts
    private func updateFavorites() {
        let savedFavorites = persistentService.loadFavorites()
        favorites.accept(savedFavorites)
    }
}
