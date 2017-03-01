//
//  FriendsListViewController.swift
//  WebClient
//
//  Created by Smbat Tumasyan on 27.01.17.
//  Copyright © 2017 EGS. All rights reserved.
//

import Foundation
import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif


class FriendsListViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
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
    
    // MARK: - Tableview Delegate DataSource
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
