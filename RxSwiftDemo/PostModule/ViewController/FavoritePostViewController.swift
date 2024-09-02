//
//  FavoritePostViewController.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 30/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritePostViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: PostsViewModelProtocol!
    
    func setup(with viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableViewDataBinding()
    }

    func setupTableView() {
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
    }
    
    func setupTableViewDataBinding() {
        self.viewModel.favorites
            .bind(to: tableView.rx.items(cellIdentifier: "PostCell", cellType: PostTableViewCell.self)) { index, post, cell in
                cell.configuePostCell(post: post)
                cell.updateFavoriteState(isFavorite: self.viewModel.favorites.value.contains(where: { $0.id == post.id }))
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PostModel.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.toggleFavorite(post: post)    
            })
            .disposed(by: disposeBag)
    }
}
