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

    @IBAction func showSimple(_ sender: AnyObject) {
        BXProgressHUD.showHUDAddedTo(targetView).hide(afterDelay: 3)
    }
    @IBAction func showWithLabel(_ sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).text("Loading").show().hide(afterDelay: 3)
    }
    
    @IBAction func showWithDetailLabel(_ sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).text("Loading...").detailText("Updating data").mode(.text).show().hide(afterDelay: 3)
    }
    @IBAction func showWithLabelDeterminate(_ sender: AnyObject) {
        HUD =  BXProgressHUD.Builder(forView: targetView).mode(.determinate).text("Loading") .create()
        HUD?.showAnimated(true, whileExecutingBlock: myProgressTask())
    }
    @IBAction func showWithLabelAnnularDeterminate(_ sender: AnyObject) {
        HUD =  BXProgressHUD.Builder(forView: targetView).mode(.annularDeterminate).text("Loading") .create()
        HUD?.showAnimated(true, whileExecutingBlock: myProgressTask())
    }
    @IBAction func showWithLabelDeterminateHorizontalBar(_ sender: AnyObject) {
        HUD =  BXProgressHUD.Builder(forView: targetView).mode(.determinateHorizontalBar).text("Loading") .create()
        HUD?.showAnimated(true, whileExecutingBlock: myProgressTask())
    }
    
    @IBAction func showCheckmark(_ sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).mode(.checkmark).text("A Builtin Checkmark").show()
    }
    
    
    @IBAction func showWithCustomView(_ sender: AnyObject) {
        let checkmarkView = UIImageView(image: UIImage(named: "checkmark"))
        let hud = BXProgressHUD.Builder(forView: targetView).mode(.customView).customView(checkmarkView).text("Completed")
          hud.show() //.hide(afterDelay: 3)
    }
    
    
    @IBAction func showWithLabelMixed(_ sender: AnyObject) {
        HUD =  BXProgressHUD.Builder(forView: targetView).text("Connecting").create()
        HUD?.showAnimated(true, whileExecutingBlock: myMixedTask())
    }
    
    @IBAction func showWithUsingBlocks(_ sender: AnyObject) {
        let hud = BXProgressHUD.Builder(forView: targetView).text("With a Block").create()
        hud.showAnimated(true, whileExecutingBlock:{
             self.myTaskBlock()
            },completionBlock:{
               hud.removeFromSuperview()
        })
    }
    
    @IBAction func showOnWindow(_ sender: AnyObject) {
      let hud = BXHUD.showProgress("Loading")
      hud.hide(afterDelay: 3)
    }
   
    
    @IBAction func showURL(_ sender: AnyObject) {
        class SessionDelegate:NSObject,URLSessionDataDelegate {
            let hud:BXProgressHUD
            var expectedLength:Int64 = 0
            var currentLength:Int64 = 0
            init(hud:BXProgressHUD){
                self.hud = hud
            }
            
            @objc
            func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
                runInUiThread{
                    self.hud.mode = .determinate
                }
                expectedLength = max(1,response.expectedContentLength)
                currentLength = 0
                completionHandler(.allow)
            }
            
            @objc
            func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
                currentLength += data.count
                let progress = (CGFloat(currentLength) / CGFloat(expectedLength))
                runInUiThread{
                    self.hud.progress  = progress
                }
            }
            
            @objc
            func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
                runInUiThread{
                    self.hud.customView = UIImageView(image: UIImage(named: "checkmark"))
                    self.hud.mode = .customView
                    self.hud.hide(afterDelay: 2)
                }
            }
        }
        
        let URL = Foundation.URL(string: "https://httpbin.org/gzip")!
        let hud = BXProgressHUD.Builder(forView: targetView).text("Lading").detailText(URL.absoluteString) .show()
        let delegate = SessionDelegate(hud: hud)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: delegate, delegateQueue: nil)
        let loadTask = session.dataTask(with: URL)
        loadTask.resume()
    }
    

    
    

    
    @IBAction func showWithGradient(_ sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).dimBackground(true).show().hide(afterDelay: 3)
    }
    @IBAction func showTextOnly(_ sender: AnyObject) {
        BXProgressHUD.Builder(forView: targetView).text("Some message...").mode(.text).show()
    }
    @IBAction func showWithColor(_ sender: AnyObject) {
        let color = UIColor(red: 0.23, green: 0.50, blue: 0.82, alpha: 0.90)
        BXProgressHUD.Builder(forView: targetView).textColor(color).show().hide(afterDelay: 3)
    }
    
    func hudWasHidden(_ hud: BXProgressHUD) {
        hud.removeFromSuperview()
    }
    


    var myTaskBlock:()->() = {
        sleep(3)
    }
   
    var HUD:BXProgressHUD?
    func myProgressTask() -> ()->(){
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
    
    func myMixedTask() -> ()->(){
        return {
            guard let hud = self.HUD else{
                return
            }
            // Indeterminate
            sleep(2)
            runInUiThread{
                hud.mode = .determinate
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
                hud.mode = .indeterminate
                hud.label.text = "Cleaning up"
            }
            sleep(2)
            
            // UIImageView
            runInUiThread{
                let checkmarkView = UIImageView(image: UIImage(named: "checkmark"))
                hud.customView = checkmarkView
                hud.mode = .customView
                hud.label.text = "Completed"
            }
            sleep(2)
        }
    }

}

func runInUiThread(_ block:@escaping ()->()){
    DispatchQueue.main.async(execute: block)
}


