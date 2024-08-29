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
        isButtonEnable(isEnable: false)
        setupLoginForm()
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
        guard let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController else {return}
        postViewController.setup(with: PostsViewModel(networkService: NetworkService(),
                                                      coreDataService: PostPersistentDataService()))
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
}

