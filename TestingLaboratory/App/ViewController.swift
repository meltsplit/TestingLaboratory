//
//  ViewController.swift
//  TestingLaboratory
//
//  Created by 장석우 on 6/25/24.
//

import UIKit

class ViewController: UIViewController {
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uc: AuthUseCase = DIContainer.shared.makeAuthUseCase()
        Task {
            do {
                let response = try await uc.signUp(id: "seokwoo2000@naver.com", pw: "Hipp807060!")
                print(response)
            } catch {
                print(error)
            }
            
        }
        
    }


}

