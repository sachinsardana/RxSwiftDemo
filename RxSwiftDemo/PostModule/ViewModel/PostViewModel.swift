//
//  PostViewModel.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//
import RxSwift
import RxCocoa
protocol PostsViewModelProtocol: AnyObject {
    var posts: BehaviorRelay<[PostModel]> { get }
    var favorites: BehaviorRelay<[PostModel]> { get }
    func toggleFavorite(post: PostModel)
}

class PostsViewModel: PostsViewModelProtocol {
    let posts: BehaviorRelay<[PostModel]> = BehaviorRelay(value: [])
    let favorites: BehaviorRelay<[PostModel]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    private let coreDataService: PostPersistentDataService
    private let networkService: NetworkService
    
    init(networkService: NetworkService, coreDataService: PostPersistentDataService) {
        self.networkService = networkService
        self.coreDataService = coreDataService
        
        networkService.fetchPosts()
            .subscribe(onNext: { [weak self] posts in
                guard let self = self else { return }
                self.posts.accept(posts)
                self.coreDataService.savePosts(posts)
                self.updateFavorites()
            })
            .disposed(by: disposeBag)
        
        let savedPosts = coreDataService.loadPosts()
        posts.accept(savedPosts)
        
        let savedFavorites = coreDataService.loadFavorites()
        favorites.accept(savedFavorites)
    }
    
    func toggleFavorite(post: PostModel) {
        var currentFavorites = favorites.value
        if let index = currentFavorites.firstIndex(where: { $0.id == post.id }) {
            currentFavorites.remove(at: index)
            coreDataService.removeFavorite(post: post)
        } else {
            currentFavorites.append(post)
            coreDataService.addFavorite(post)
        }
        favorites.accept(currentFavorites)
        
        var updatedPosts = posts.value
        if let index = updatedPosts.firstIndex(where: { $0.id == post.id }) {
            updatedPosts[index].isfavorite = post.isfavorite
        }
        posts.accept(updatedPosts)
        coreDataService.savePosts(updatedPosts)
    }
    
    private func updateFavorites() {
        let savedFavorites = coreDataService.loadFavorites()
        favorites.accept(savedFavorites)
    }
}
