//
//  PostViewController.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 28/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    private let disposeBag = DisposeBag()
    private var viewModel: PostsViewModelProtocol!
    
    func setup(with viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentView()
        setupTableView()
        setupTableViewDataBinding()
    }
    
    func setupSegmentView() {
        self.segmentView.setTitle("All Posts", forSegmentAt: 0)
        self.segmentView.setTitle("Favorite's Post", forSegmentAt: 1)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    }
    
    func setupTableViewDataBinding() {
        let displayedPosts = BehaviorRelay<[PostModel]>(value: [])
        segmentView.rx.selectedSegmentIndex
            .map { index in
                return index == 0 ? self.viewModel.posts.value : self.viewModel.favorites.value
            }
            .bind(to: displayedPosts)
            .disposed(by: disposeBag)
        
        displayedPosts
            .bind(to: tableView.rx.items(cellIdentifier: "PostCell", cellType: PostTableViewCell.self)) { index, post, cell in
                cell.configuePostCell(post: post)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PostModel.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.toggleFavorite(post: post)
                if let index = self?.segmentView.selectedSegmentIndex, index == 1 {
                    let updatedFavorites = self?.viewModel.favorites.value ?? []
                    displayedPosts.accept(updatedFavorites)
                }
            })
            .disposed(by: disposeBag)
    }
}

