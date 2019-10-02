/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/

import UIKit
import Parse
import CleverTapSDK

class Account: UIViewController,
UITextFieldDelegate
{

    /* Views */
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var shippingTxt: UITextField!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    if PFUser.current() != nil {
        let currentUser = PFUser.current()!
        
        // Get user's details
        usernameLabel.text = "\(currentUser[USER_USERNAME]!)"
        emailTxt.text = "\(currentUser[USER_EMAIL]!)"
        if currentUser[USER_FULLNAME] != nil { fullNameTxt.text = "\(currentUser[USER_FULLNAME]!)" }
        if currentUser[USER_SHIPPING_ADDRESS] != nil { shippingTxt.text = "\(currentUser[USER_SHIPPING_ADDRESS]!)" }
        let profile: Dictionary<String, AnyObject> = [
            "Name" : self.fullNameTxt.text! as AnyObject,
            "Identity" : self.usernameLabel.text! as AnyObject,
            "Location" : self.shippingTxt.text! as AnyObject,
            "Email" : self.emailTxt.text! as AnyObject
            
        ]
        
        CleverTap.sharedInstance()?.onUserLogin(profile)
    }
    
    
    // Layouts
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 600)
}


    
    
    
    
// MARK: - UPDATE PROFILE BUTTON
@IBAction func updateProfileButt(_ sender: AnyObject) {
    showHUD("Updating...")
    dismisskeyboard()
    let currentUser = PFUser.current()!

    currentUser[USER_FULLNAME] = fullNameTxt.text!
    currentUser[USER_EMAIL] = emailTxt.text!
    currentUser[USER_SHIPPING_ADDRESS] = shippingTxt.text!
    
    // Saving block
    currentUser.saveInBackground { (success, error) -> Void in
        if error == nil {
            self.hideHUD()
            self.simpleAlert("Your Profile has been updated!")
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
    

// MARK: - TEST FIELD DELEGATE
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == fullNameTxt { emailTxt.becomeFirstResponder() }
    if textField == emailTxt { shippingTxt.becomeFirstResponder() }
    if textField == shippingTxt { shippingTxt.resignFirstResponder() }
    
return true
}
    
   
    
// MARK: - TAP TO DISMISS KEYBOARD
@IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
   dismisskeyboard()
}
    
func dismisskeyboard() {
    fullNameTxt.resignFirstResponder()
    emailTxt.resignFirstResponder()
    shippingTxt.resignFirstResponder()
}
    
    
    
    
// MARK: - MY ORDERS BUTTON
@IBAction func myOrdersButt(_ sender: AnyObject) {
    let aVC = storyboard?.instantiateViewController(withIdentifier: "MyOrders") as! MyOrders
    present(aVC, animated: true, completion: nil)
}
    
    
    
    
    
// LOGOUT BUTTON
@IBAction func logoutButt(_ sender: AnyObject) {
    let alert = UIAlertController(title: APP_NAME,
            message: "Are you sure you want to logout?",
            preferredStyle: .alert)
    
    let ok = UIAlertAction(title: "Logout", style: .default, handler: { (action) -> Void in
        self.showHUD("Logging Out...")
        
        PFUser.logOutInBackground(block: { (error) in
            if error == nil {
                // Go back to Home
                self.dismiss(animated: true, completion: nil)
            }
            self.hideHUD()
        })
    })
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
    
    alert.addAction(ok); alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
}
    
    
    
// MARK: -  DISMISS BUTTON
@IBAction func dismissButt(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
}
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
