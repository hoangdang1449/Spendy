//
//  SettingsViewController.swift
//  Spendy
//
//  Created by Harley Trung on 9/17/15.
//  Copyright (c) 2015 Cheetah. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var saveEmailButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    let defaultPassword = "defaultPassword"

    // temporary
    @IBOutlet weak var accountStatusLabel: UILabel!

    @IBOutlet weak var resetDataButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveEmailButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        saveEmailButton.layer.borderWidth = 0.1
        saveEmailButton.layer.cornerRadius = 10
        saveEmailButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)

        refreshViewsForUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func login() {
        PFUser.logInWithUsernameInBackground(
            emailTextField.text, password: defaultPassword, block: { (user: PFUser?, error: NSError?) -> Void in
                if error != nil {
                    println("Error logging in: \(error)")
                } else {
                    println("Logged in successfully")
                    self.refreshViewsForUser()
                }
        })
    }

    @IBAction func onResetData(sender: AnyObject) {
        resetDataButton.enabled = false
        DataManager.setupDefaultData(removeLocalData: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSaveEmail(sender: AnyObject) {
        if !emailTextField.text.isEmpty {
            if let user = PFUser.currentUser() {
                if userIsAnonymous() {
                    user.email = emailTextField.text
                    user.username = user.email
                    user.password = defaultPassword
                    // User is new
                    user.signUpInBackgroundWithBlock({ (succeeded, error: NSError?) -> Void in
                        if error != nil {
                            println("Error signing up: \(error). User: \(user)")
                            println("Try logging in:")
                            self.login() // temporary
                        } else {
                            println("Signed up successfully")
                            self.refreshViewsForUser()
                        }
                    })
                } else {
                    login()
                }
            }
        }
    }

    func disableSaveIfEmailIsEmpty() {
        if emailTextField.text.isEmpty {
            saveEmailButton.enabled = false
        } else {
            saveEmailButton.enabled = true
        }
    }

    func userIsAnonymous() -> Bool {
        let user = PFUser.currentUser()!
        let anonymous = PFAnonymousUtils.isLinkedWithUser(user)
        println("anonymous: \(anonymous)")
        return anonymous
    }

    func refreshViewsForUser() {
        // because we allow anonymous login, this should never be nil
        let user = PFUser.currentUser()!
        println("current user: \(user)")

        emailTextField.text = user.email

        if userIsAnonymous() {
            accountStatusLabel.text = "You are not logged in."
            logoutButton.hidden = true
        } else {
            accountStatusLabel.text = "Settings are saved to account \(user.email!)"
            logoutButton.hidden = false
        }
        disableSaveIfEmailIsEmpty()
    }

    // MARK: - button actions
    @IBAction func onEmailTextChanged(sender: AnyObject) {
        disableSaveIfEmailIsEmpty()
    }

    @IBAction func onLogout(sender: AnyObject) {
        PFUser.logOut()
        println("Logged out. User: \(PFUser.currentUser())")
        refreshViewsForUser()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = menuTableView.dequeueReusableCellWithIdentifier("SettingMenuItemCell") as! UITableViewCell

        return cell
    }

}
