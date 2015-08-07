//
//  ViewController.swift
//  Pu Login
//
//  Created by Simar Arora on 06/08/15.
//  Copyright (c) 2015 Simar Arora. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tfPassword.secureTextEntry = true
        
        self.tfPassword.delegate = self;
        self.tfUsername.delegate = self;
        let preferences = NSUserDefaults.standardUserDefaults()
        
        let userKey = "userKey"
        let passKey = "passKey"
        
        if (preferences.objectForKey(userKey) == nil || preferences.objectForKey(passKey) == nil){
            //  Doesn't exist
        } else {
            let user = preferences.stringForKey(userKey)!
            let pass = preferences.stringForKey(passKey)!
           
            
            tfUsername.text = user
            tfPassword.text = pass
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func bLogin(sender: UIButton) {
       
        
        var URL: NSURL = NSURL(string: "https://securelogin.arubanetworks.com/cgi-bin/login?cmd=login&mac=b8:e8:56:14:bc:9c&ip=172.16.225.172&essid=PU%40CAMPUS&apname=BH7_BL1_FF_3&apgroup=PU-AP-BH7&url=https%3A%2F%2Fwww%2Egoogle%2Eco%2Ein%2F")!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "POST"
        var bodyData = "username=\(tfUsername.text)&password=\(tfPassword.text)"
        println(bodyData);
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                {
                    (response, data, error) in
                    var response:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    if response.containsString("Authentication"){
                        self.showPopupMessage("Authentication Failed")
                    }else if response.containsString("External Welcome Page"){
                        self.showPopupMessage("Login Successful")
                    }
                    
        }

    }

    @IBAction func bLogout(sender: UIButton) {
        
        let url = NSURL(string: "http://172.16.4.201/cgi-bin/login?cmd=logout")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            var response: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
            if response.containsString("Logout Successful"){
                self.showPopupMessage("Logout Successful")
            }else if response.containsString("User not logged in"){
                self.showPopupMessage("User Not Logged In")
            }
        }
        
        task.resume()
    }
    
    @IBAction func bSave(sender: UIButton) {
        let preferences = NSUserDefaults.standardUserDefaults()
        
        let userKey = "userKey"
        let passKey = "passKey"
        
        let user = tfUsername.text!
        let pass = tfPassword.text!
        
        
        
        if(user.isEmpty || pass.isEmpty){
            //Show Prompt
            return
        }
        
        let currentUser: Void = preferences.setValue(user, forKey: userKey)
        
        let currentPass: Void = preferences.setValue(pass, forKey: passKey)
        
        let didSave = preferences.synchronize()

        
        
        if !didSave {
            //  Couldn't save (I've never seen this happen in real world testing)
        }else{
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func showPopupMessage(message:String){
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = message
        alert.addButtonWithTitle("Dismiss")
        alert.show()
    }
    
    
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
}

