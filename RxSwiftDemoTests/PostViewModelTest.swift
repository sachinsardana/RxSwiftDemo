//
//  PostViewModelTest.swift
//  RxSwiftDemoTests
//
//  Created by Sachin Sardana on 02/09/24.
//
@testable import RxSwiftDemo
import XCTest
import RxSwift
import RxCocoa

final class PostViewModelTest: XCTestCase {
    private var viewModel: PostsViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
        viewModel = PostsViewModel(networkService: mockNetworkService,
                                   persistentService: PostPersistentDataService())
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkService = nil
    }
    //Testing Post API Method by using mock data
    func testFetchPostsApi() {
        let expectation = XCTestExpectation(description: "Posts fetched successfully")
        let posts = [PostModel(id: 1, body: "ABC", title: "Post 1")]
        mockNetworkService.fetchPostsResult = .success(posts)
        viewModel.fetchPosts()
        viewModel.posts.asObservable()
            .subscribe(onNext: { fetchedPosts in
                XCTAssertNotNil(fetchedPosts)
                XCTAssertTrue(fetchedPosts.count > 0)
                expectation.fulfill()
            })
            .disposed(by: viewModel.disposeBag)
    }
    //Testing Adding Post To Favorite
    func testAddsPostToFavorites() {
        let post = PostModel(id: 1, body: "ABC", title: "Post 1", isfavorite: false)
        viewModel.posts.accept([post])
        viewModel.favorites.accept([])
        viewModel.toggleFavorite(post: post)
        XCTAssertTrue(viewModel.favorites.value.contains { $0.id == post.id })
        if let updatedPost = viewModel.posts.value.first(where: { $0.id == post.id }) {
            XCTAssertTrue(updatedPost.isfavorite == true)
        }
    }
    //Testing Removing Post From Favorite
    func testRemovePostToFavorites() {
        let post = PostModel(id: 1, body: "ABC", title: "Post 1", isfavorite: true)
        viewModel.posts.accept([post])
        viewModel.favorites.accept([])
        viewModel.toggleFavorite(post: post)
        XCTAssertTrue(viewModel.favorites.value.contains { $0.id == post.id })
        if let updatedPost = viewModel.posts.value.first(where: { $0.id == post.id }) {
            XCTAssertTrue(updatedPost.isfavorite == false)
        }
    }
}

//Mock Data Class
class MockNetworkService: NetworkServiceProtocol {
    var fetchPostsResult: Result<[PostModel], Error>?
    
    func fetchPosts() -> Observable<[PostModel]> {
        return Observable.create { observer in
            if let result = self.fetchPostsResult {
                switch result {
                case .success(let posts):
                    observer.onNext(posts)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
