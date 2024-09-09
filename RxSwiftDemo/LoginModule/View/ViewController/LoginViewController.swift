//
//  LoginViewController.swift
//  RxSwiftDemo
//
//  Created by Sachin Sardana on 27/08/24.
//

import UIKit
import RxSwift
import RxCocoa
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let viewModel = LoginViewModel(validations: LoginValidations())
    private let disposeBag = DisposeBag()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLoginForm()
    }
    
    func setupUI() {
        emailTextField.addLeftPadding(padding: 10)
        passwordTextField.addLeftPadding(padding: 10)
    }
    
    //Binding data using RxSwift
    private func setupLoginForm() {
        emailTextField.rx.text.orEmpty
            .subscribe(onNext: { [viewModel] email in
                viewModel.emailText.onNext(email)
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .subscribe(onNext: { [viewModel] pass in
                viewModel.passwordText.onNext(pass)
            })
            .disposed(by: disposeBag)
        
        viewModel.isFormValid
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isFormValid
            .map { $0 ? 1.0 : 0.5 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: {
                self.navigateToPostScreen()
            })
            .disposed(by: disposeBag)
    }
    
    //Navigating to Post's Screen
    private func navigateToPostScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {
            print("Failed to instantiate UITabBarController")
            return
        }
        
        guard let viewControllers = tabBarController.viewControllers else {return}
        //Post View Controller
        guard let postViewController = viewControllers.first as? PostViewController else {return}
        let viewModel = PostsViewModel(networkService: NetworkService(),persistentService: PostPersistentDataService())
        postViewController.setup(with: viewModel)
        //Favorite View Controller
        guard let favoriteTabViewController = viewControllers[1] as? FavoritePostViewController else {return}
        favoriteTabViewController.setup(with: viewModel)
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
}

