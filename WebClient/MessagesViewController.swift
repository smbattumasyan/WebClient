//
//  MessagesViewController.swift
//  WebClient
//
//  Created by Smbat Tumasyan on 22.02.17.
//  Copyright © 2017 EGS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessagesViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    let disposeBag = DisposeBag()
    var items = Observable.just([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = Observable.just(["hello", "hi", "world"])
        
        items
            .bindTo(tableView.rx.items(cellIdentifier: "reuseIdentifier", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .addDisposableTo(disposeBag)
        
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext:  { value in
                print("Tapped `\(value)`")
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        
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
