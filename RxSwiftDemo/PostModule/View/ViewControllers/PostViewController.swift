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
    
    private let disposeBag = DisposeBag()
    private var viewModel: PostsViewModel!
    
//    //Dependency injection
    func setup(with viewModel: PostsViewModel) {
        self.viewModel = viewModel
    }
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableViewDataBinding()
    }
    
    //MARK: Table View Methods
    // Register table view cell
    func setupTableView() {
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    }
    // Binding data to tableview
    func setupTableViewDataBinding() {
        self.viewModel.posts
            .bind(to: tableView.rx.items(cellIdentifier: "PostCell", cellType: PostTableViewCell.self)) { index, post, cell in
                cell.configuePostCell(post: post)
                cell.updateFavoriteState(isFavorite: self.viewModel.favorites.value.contains(where: { $0.id == post.id }))
            }
            .disposed(by: disposeBag)
        // Tableview did select method
        tableView.rx.modelSelected(PostModel.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.toggleFavorite(post: post)
            })
            .disposed(by: disposeBag)
    }
}

