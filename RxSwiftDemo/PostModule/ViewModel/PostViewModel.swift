//
//  PostViewModel.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//
import RxSwift
import RxCocoa
protocol PostsViewModelProtocol {
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
    }
    
    private func updateFavorites() {
        let savedFavorites = coreDataService.loadFavorites()
        let currentPosts = posts.value
        let updatedFavorites = savedFavorites.filter { favorite in
            currentPosts.contains(where: { $0.id == favorite.id })
        }
        favorites.accept(updatedFavorites)
    }
    
    func getPosts(for segmentIndex: Int) -> [PostModel] {
        return segmentIndex == 0 ? posts.value : favorites.value
    }
}
