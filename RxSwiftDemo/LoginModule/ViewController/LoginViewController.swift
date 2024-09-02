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
    
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        self.viewModel = LoginViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isButtonEnable(isEnable: false)
        setupLoginForm()
    }
    
    func setupUI() {
        emailTextField.addLeftPadding(padding: 10)
        passwordTextField.addLeftPadding(padding: 10)
    }
    
    func isButtonEnable(isEnable:Bool) {
        loginButton.alpha = isEnable ? 1 : 0.5
        loginButton.isEnabled = isEnable
    }
    
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
    
    private func navigateToPostScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else {
            print("Failed to instantiate UITabBarController")
            return
        }
        guard let viewControllers = tabBarController.viewControllers else {return}
        guard let firstTabViewController = viewControllers.first as? PostViewController else {return}
        let viewModel = PostsViewModel(networkService: NetworkService(),
                                       coreDataService: PostPersistentDataService())
        firstTabViewController.setup(with: viewModel)
        
        guard let secondTabViewController = viewControllers[1] as? FavoritePostViewController else {return}
        secondTabViewController.setup(with: viewModel)
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.rootViewController = tabBarController
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        } else {
            print("Failed to get the window from the current scene")
        }
    }
}

