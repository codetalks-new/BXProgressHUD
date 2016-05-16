//
//  ViewController.swift
//  BXProgressHUD
//
//  Created by banxi1988 on 11/06/2015.
//  Copyright (c) 2015 banxi1988. All rights reserved.
//

import UIKit
import BXProgressHUD

class DemoViewController: UITableViewController,BXProgressHUDDelegate{

    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Demo List"
        tableView.backgroundColor = UIColor(red: 0xe2 / 255.0, green: 0xe7 / 255.0, blue: 0xe8 / 255.0, alpha: 1.0)
        buttons.forEach{ button in button.layer.cornerRadius = 5.0 }
        
    }
    
    var targetView: UIView{
        return self.view.superview!
    }

    @IBAction func showSimple(sender: AnyObject) {
        BXProgressHUD.showHUDAddedTo(targetView).hide(afterDelay: 3)
    }
    @IBAction func showWithLabel(sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).text("Loading").show().hide(afterDelay: 3)
    }
    
    @IBAction func showWithDetailLabel(sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).text("Loading").detailText("Updating data").show()//.hide(afterDelay: 3)
    }
    @IBAction func showWithLabelDeterminate(sender: AnyObject) {
        HUD =  BXProgressHUD.Builder(forView: targetView).mode(.Determinate).text("Loading") .create()
        HUD?.showAnimated(true, whileExecutingBlock: myProgressTask())
    }
    @IBAction func showWithLabelAnnularDeterminate(sender: AnyObject) {
        HUD =  BXProgressHUD.Builder(forView: targetView).mode(.AnnularDeterminate).text("Loading") .create()
        HUD?.showAnimated(true, whileExecutingBlock: myProgressTask())
    }
    @IBAction func showWithLabelDeterminateHorizontalBar(sender: AnyObject) {
        HUD =  BXProgressHUD.Builder(forView: targetView).mode(.DeterminateHorizontalBar).text("Loading") .create()
        HUD?.showAnimated(true, whileExecutingBlock: myProgressTask())
    }
    
    @IBAction func showCheckmark(sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).mode(.Checkmark).text("A Builtin Checkmark").show()
    }
    
    
    @IBAction func showWithCustomView(sender: AnyObject) {
        let checkmarkView = UIImageView(image: UIImage(named: "checkmark"))
        let hud = BXProgressHUD.Builder(forView: targetView).mode(.CustomView).customView(checkmarkView).text("Completed")
          hud.show() //.hide(afterDelay: 3)
    }
    
    
    @IBAction func showWithLabelMixed(sender: AnyObject) {
        HUD =  BXProgressHUD.Builder(forView: targetView).text("Connecting").create()
        HUD?.showAnimated(true, whileExecutingBlock: myMixedTask())
    }
    
    @IBAction func showWithUsingBlocks(sender: AnyObject) {
        let hud = BXProgressHUD.Builder(forView: targetView).text("With a Block").create()
        hud.showAnimated(true, whileExecutingBlock:{
             self.myTaskBlock()
            },completionBlock:{
               hud.removeFromSuperview()
        })
    }
    
    @IBAction func showOnWindow(sender: AnyObject) {
      BXProgressHUD.Builder(forView: targetView.window!).text("Loading").mode(.Text).show().hide(afterDelay:3)
    }
   
    
    @IBAction func showURL(sender: AnyObject) {
        class SessionDelegate:NSObject,NSURLSessionDataDelegate {
            let hud:BXProgressHUD
            var expectedLength:Int64 = 0
            var currentLength:Int64 = 0
            init(hud:BXProgressHUD){
                self.hud = hud
            }
            
            @objc
            func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
                runInUiThread{
                    self.hud.mode = .Determinate
                }
                expectedLength = max(1,response.expectedContentLength)
                currentLength = 0
                completionHandler(.Allow)
            }
            
            @objc
            func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
                currentLength += data.length
                let progress = (CGFloat(currentLength) / CGFloat(expectedLength))
                runInUiThread{
                    self.hud.progress  = progress
                }
            }
            
            @objc
            func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
                runInUiThread{
                    self.hud.customView = UIImageView(image: UIImage(named: "checkmark"))
                    self.hud.mode = .CustomView
                    self.hud.hide(afterDelay: 2)
                }
            }
        }
        
        let URL = NSURL(string: "https://httpbin.org/gzip")!
        let hud = BXProgressHUD.Builder(forView: targetView).text("Lading").detailText(URL.absoluteString) .show()
        let delegate = SessionDelegate(hud: hud)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: delegate, delegateQueue: nil)
        let loadTask = session.dataTaskWithURL(URL)
        loadTask.resume()
    }
    

    
    

    
    @IBAction func showWithGradient(sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).dimBackground(true).show().hide(afterDelay: 3)
    }
    @IBAction func showTextOnly(sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).text("Some message...").mode(.Text).show()
    }
    @IBAction func showWithColor(sender: AnyObject) {
//        let color = UIColor(red: 0.23, green: 0.50, blue: 0.82, alpha: 0.90)
//        BXProgressHUD.Builder(forView: targetView).color(color).show().hide(afterDelay: 3)
    }
    
    func hudWasHidden(hud: BXProgressHUD) {
        hud.removeFromSuperview()
    }
    


    var myTaskBlock:dispatch_block_t = {
        sleep(3)
    }
   
    var HUD:BXProgressHUD?
    func myProgressTask() -> dispatch_block_t{
        return {
            var progress = 0.0
            while progress < 1.0 {
                progress += 0.01
               runInUiThread{
                    self.HUD?.progress = CGFloat(progress)
                }
                usleep(50000) // 0.05 seconds suspend execution for microsecond intervals
                // 1 microsecond -  1/1,000,000 seconds
                
            }
        }
    }
    
    func myMixedTask() -> dispatch_block_t{
        return {
            guard let hud = self.HUD else{
                return
            }
            // Indeterminate
            sleep(2)
            runInUiThread{
                hud.mode = .Determinate
                hud.label.text = "Progress"
            }
            var progress = 0.0
            while progress < 1.0 {
                progress += 0.01
                runInUiThread{
                    hud.progress = CGFloat(progress)
                }
                usleep(50000) // 0.05 seconds suspend execution for microsecond intervals
                // 1 microsecond -  1/1,000,000 seconds
            }
            // Back to indeterminate mode
            runInUiThread{
                hud.mode = .Indeterminate
                hud.label.text = "Cleaning up"
            }
            sleep(2)
            
            // UIImageView
            runInUiThread{
                let checkmarkView = UIImageView(image: UIImage(named: "checkmark"))
                hud.customView = checkmarkView
                hud.mode = .CustomView
                hud.label.text = "Completed"
            }
            sleep(2)
        }
    }

}

func runInUiThread(block:dispatch_block_t){
    dispatch_async(dispatch_get_main_queue(), block)
}


