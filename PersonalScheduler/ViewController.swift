//
//  ViewController.swift
//  PersonalScheduler
//
//  Created by bonf on 06/01/23.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class ViewController: UIViewController {
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오톡 앱으로 로그인", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
//        label.text = "12"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
//        image.image = UIImage(systemName: "square")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupLayout()
    }

    private func setupDefaults() {
        view.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(loginToKakaoTalk), for: .touchUpInside)

        view.addSubview(loginButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(profileImage)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func loginToKakaoTalk() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    // do something
                    _ = oauthToken
                    // 어세스토큰
                    let accessToken = oauthToken?.accessToken
                    
                    self.setUserInfo()
                }
            }
        }
    }
    
    func setUserInfo() {
            UserApi.shared.me() {(user, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("me() success.")
                    //do something
                    _ = user
                    self.nameLabel.text = user?.kakaoAccount?.profile?.nickname
                    
                    if let url = user?.kakaoAccount?.profile?.profileImageUrl {
                        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, res, err in
                            
                            guard let data = data else { return }
                            
                            DispatchQueue.main.async {
                                self.profileImage.image = UIImage(data: data)
                            }
                        }
                        
                        task.resume()
                    }
                }
            }
        }
}

