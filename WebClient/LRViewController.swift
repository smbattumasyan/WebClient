//
//  LRViewController.swift
//  WebClient
//
//  Created by Smbat Tumasyan on 12.01.17.
//  Copyright © 2017 EGS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LRViewController: UIViewController, UITextFieldDelegate {
    let disposeBag = DisposeBag()
    //-------------------------------------------------------------------------------------------
    //MARK: - IBOutlets
    //-------------------------------------------------------------------------------------------
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //-------------------------------------------------------------------------------------------
    //MARK: - Private Properties
    //-------------------------------------------------------------------------------------------

    let requestManager           = WCRequestManager()
    var loginData :NSDictionary? = nil
    let isNegative = Variable<Bool>(false)
    
    //-------------------------------------------------------------------------------------------
    //MARK: - Life Cyrcle
    //-------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        self.usernameTextField.rx.text
        .asObservable()
            .map { $0 }
        .bindTo(self.passwordTextField.rx.text)
        .addDisposableTo(self.disposeBag)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------------------------------------------------------------
    //MARK: - UITextField Delegate
    //-------------------------------------------------------------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.usernameTextField.isFirstResponder {
            self.passwordTextField.becomeFirstResponder()
        }
        return false
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        let keyboardInfo = notification.userInfo as NSDictionary!
        let keyboardFrameBegin = keyboardInfo?.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
//        let duration = (notification.userInfo as! NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey);
        
        let keyboardFrameBeginRect = keyboardFrameBegin.cgRectValue
        let keyboardHeight = keyboardFrameBeginRect.size.height
//        let keyboardWidth = keyboardFrameBeginRect.size.width
        
        print("keyboardHEight: \(keyboardHeight)")
    }
    
    
    //-------------------------------------------------------------------------------------------
    //MARK: - IBActions
    //-------------------------------------------------------------------------------------------
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        let usrpassDict = ["username": self.usernameTextField.text, "password": self.passwordTextField.text?.MD5()]
        self.requestManager .loginRequest(paramDict: usrpassDict as NSDictionary) { (data: Data?, response: URLResponse?, error: Error?) in
           
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    self.loginData = parsedData
                    if self.loginData != nil {
                        self.navigateLoginPage()
                    }
                    print("parsedData\(self.loginData)")
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }
    }
    
    @IBAction func registrationButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "RegistrationViewController", sender: self)
    }
    
    func navigateLoginPage() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "LoginPageViewController", sender: self)
            self.setLabels()
        }
    }
    
    func setLabels() {
        
     
        //self.usernameTextField.text = ""
       // self.usernameTextField.text = ""
    }

    //-------------------------------------------------------------------------------------------
    // MARK: - Navigation
    //-------------------------------------------------------------------------------------------
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginPageViewController" {
            let loginPageVC = segue.destination as! LoginPageViewController
            loginPageVC.loginPageData = self.loginData
        }
    }

}
