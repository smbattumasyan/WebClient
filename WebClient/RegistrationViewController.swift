//
//  RegistrationViewController.swift
//  WebClient
//
//  Created by Smbat Tumasyan on 12.01.17.
//  Copyright © 2017 EGS. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //-------------------------------------------------------------------------------------------
    //MARK: - IBOutlets
    //-------------------------------------------------------------------------------------------
    
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //-------------------------------------------------------------------------------------------
    //MARK: - Private Properties
    //-------------------------------------------------------------------------------------------
    let requestManager               = WCRequestManager()
    var chosenImage: UIImage?        = nil
    var pageLoginData: NSDictionary? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessagesViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage?
        self.uploadImageButton.setBackgroundImage(chosenImage, for: UIControlState.normal)
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadImageButtonAction(_ sender: Any) {
        let picker           = UIImagePickerController()
        picker.delegate      = self
        picker.allowsEditing = true
        picker.sourceType    = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        
        let registrationParam = ["username": self.usernameTextField.text! as String,
                                 "password": (self.passwordTextField.text! as String).MD5(),
                                 "name": self.nameTextField.text! as String,
                                 "email": self.emailTextField.text! as String ,
                                 "userImage": self.imageToString(image: self.chosenImage!)];
        
        self.requestManager.registrationRequest(paramDict: registrationParam as NSDictionary) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                do {
                    let parsedData     = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    self.pageLoginData = parsedData
                    print("parsedData\(parsedData)")
                    
                    if self.pageLoginData != nil {
                        self.navigateLoginPage()
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
    
    func imageToString(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)
        
        return (imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters))!
    }
    
    func navigateLoginPage() {
        DispatchQueue.main.async {
            let loginPageVC           = self.storyboard?.instantiateViewController(withIdentifier: "LoginPageViewController") as! LoginPageViewController
            loginPageVC.loginPageData = self.pageLoginData
            self.navigationController?.pushViewController(loginPageVC, animated: true)
        }
    }
    
    func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
