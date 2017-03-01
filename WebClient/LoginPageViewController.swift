//
//  LoginPageViewController.swift
//  WebClient
//
//  Created by Smbat Tumasyan on 12.01.17.
//  Copyright © 2017 EGS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginPageViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var fullName: String?
    let disposeBag = DisposeBag()
    
    
    var loginPageData:NSDictionary! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        self.setLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func friendsButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "FriendsListViewController", sender: self)
    }
    
    @IBAction func messagesButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MessagesViewController", sender: self)
    }
    
    
    func setLabel() {
        
        self.fullName = self.loginPageData.value(forKey: "name") as! String?
        
        self.nameLabel.text      = self.loginPageData.value(forKey: "name") as! String?
        self.emailLabel.text     = self.loginPageData.value(forKey: "email") as! String?
        self.userImageView.image = self.stringToUIImage(string: self.loginPageData.value(forKey: "userImage") as! String);
    }
    
    func stringToUIImage(string: String) -> UIImage {
        let imgString = string.replacingOccurrences(of: " ", with: "+")
        let data      = NSData.init(base64Encoded: imgString, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        
        return UIImage(data: data as! Data)!
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
    }
    

}
