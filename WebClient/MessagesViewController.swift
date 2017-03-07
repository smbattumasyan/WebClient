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

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StreamDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var inputNameField: UITextField!
    
    var messages = NSMutableArray()
    
    var inputStream:InputStream!
    var outputStream:OutputStream!
    
    
    
    let disposeBag = DisposeBag()
    var items = Variable<[String]>([])
    
    // MARK: - Life Cyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessagesViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        
        items.value = ["Hi", "Hello"]
        
        items.asDriver()
            .drive(onNext: { [unowned self] (array) in

                self.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
        
        self.initNetworkCommunication()
    }
    
    deinit {
        self.outputStream.close()
        self.inputStream.close()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TableView DataSource Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        cell?.textLabel?.text = items.value[indexPath.row]
        
        return cell!
    }
    
    // MARK: - IBAction
    @IBAction func sendButtonAction(_ sender: UIButton) {
        
        if let data = "msg:\(self.messageTextField.text!)".data(using: .ascii) {
            let bytesWritten = data.withUnsafeBytes { outputStream?.write($0, maxLength: data.count) }
            print("\(bytesWritten)")
            
        }
        self.messageTextField.text = ""
    }
    
    // MARK: - Private Methods
    func initNetworkCommunication() {
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        CFStreamCreatePairWithSocketToHost(nil, "10.1.6.233" as CFString, 82, &readStream, &writeStream)
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        self.inputStream?.delegate = self
        self.outputStream?.delegate = self
        inputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        outputStream?.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        inputStream?.open()
        outputStream?.open()
        self.joinChat()
    }
    
    func joinChat() {
        let response = "iam:user1"
        if let data = response.data(using: .ascii) {
            let bytesWritten = data.withUnsafeBytes { outputStream?.write($0, maxLength: data.count) }
            print("\(bytesWritten)")
        }
    }
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("stream event \(eventCode)")
        
        switch eventCode {
        case Stream.Event.openCompleted:
            print("Stream opened")
            break;
        case Stream.Event.hasBytesAvailable:
            if aStream == inputStream {
                let bufferSize = 1024
                let pbuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
                var len:Int!
                
                while (inputStream.hasBytesAvailable) {
                    len = inputStream.read(pbuffer, maxLength: bufferSize)
                    if len > 0 {
                        let output = NSString.init(bytes: pbuffer, length: len, encoding: String.Encoding.ascii.rawValue)
                        if output != nil {
                            print("server said: \(output!):::")
                            self.messageReceived(message: output!)
                        }
                    }
                }
            }
            break;
        case Stream.Event.errorOccurred:
            print("Can not connect to the host!")
            break;
        case Stream.Event.endEncountered:
            aStream.close()
            aStream.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            break;
        default:
                print("Unknown event");
        }
    }
    
    func messageReceived(message:NSString) {
        
        self.items.value.append((message as String))
        
        let oldLastCellIndexPath = NSIndexPath(row:items.value.count-1, section:0)
        
        self.tableView.scrollToRow(at: oldLastCellIndexPath as IndexPath, at: .bottom, animated: false)
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

