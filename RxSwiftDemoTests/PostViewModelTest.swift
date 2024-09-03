//
//  PostViewModelTest.swift
//  RxSwiftDemoTests
//
//  Created by Sachin Sardana on 02/09/24.
//

import XCTest
@testable import RxSwiftDemo

final class PostViewModelTest: XCTestCase {
    private var viewModel: PostsViewModel!
    private var networkService: NetworkService!
    private var coreDataService: PostPersistentDataService!
    
    override func setUpWithError() throws {
        networkService = NetworkService()
        coreDataService = PostPersistentDataService()
        viewModel = PostsViewModel(networkService: networkService, coreDataService: coreDataService)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        networkService = nil
        coreDataService = nil
    }
    
    func testFetchPostsApi() {
        let expectation = XCTestExpectation(description: "Posts fetched successfully")
        viewModel.posts.asObservable()
            .skip(1)
            .subscribe(onNext: { fetchedPosts in
                XCTAssertNotNil(fetchedPosts)
                XCTAssertTrue(fetchedPosts.count > 0)
                expectation.fulfill()
            })
            .disposed(by: viewModel.disposeBag)
        wait(for: [expectation], timeout: 10.0)
    }
    
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
