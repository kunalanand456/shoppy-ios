/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/

import UIKit
import Parse
import CleverTapSDK

class SignUp: UIViewController,
UITextFieldDelegate
{
    
    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    
    @IBOutlet weak var signUpOutlet: UIButton!
    @IBOutlet weak var touOutlet: UIButton!
    
    @IBOutlet var signpViews: [UIView]!

    
    
override func viewDidLoad() {
        super.viewDidLoad()
        
    // Setup layout views
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 650)
    
    
    // Change placeholder's color
    let color = UIColor.white
    usernameTxt.attributedPlaceholder = NSAttributedString(string: "choose a username", attributes: [NSAttributedString.Key.foregroundColor: color])
    passwordTxt.attributedPlaceholder = NSAttributedString(string: "type a password", attributes: [NSAttributedString.Key.foregroundColor: color])
    emailTxt.attributedPlaceholder = NSAttributedString(string: "type your email address", attributes: [NSAttributedString.Key.foregroundColor: color])
    
    
    
    /* UNCOMMENT THIS CODE IF YOU WANT TO ROUND VIEWS CORNERS
     // Round views corners
     for aView in signpViews {
     aView.layer.cornerRadius = 8
     aView.layer.borderColor = UIColor.whiteColor().CGColor
     aView.layer.borderWidth = 1
     }
     signUpOutlet.layer.cornerRadius = 5
     touOutlet.layer.cornerRadius = 5
     */
}
    
    
    
// MARK: - TAP TO DISMISS KEYBOARD
@IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
   dismissKeyboard()
}
func dismissKeyboard() {
    usernameTxt.resignFirstResponder()
    passwordTxt.resignFirstResponder()
    emailTxt.resignFirstResponder()
}
    
    
    
// MARK: - SIGNUP BUTTON
@IBAction func signupButt(_ sender: AnyObject) {
    dismissKeyboard()
    showHUD("Signing Up...")

    let userForSignUp = PFUser()
    userForSignUp.username = usernameTxt.text!.lowercased()
    userForSignUp.password = passwordTxt.text
    userForSignUp.email = emailTxt.text
    
    if usernameTxt.text == "" || passwordTxt.text == "" || emailTxt.text == "" {
        simpleAlert("You must fill all fields to sign up on \(APP_NAME)")
        self.hideHUD()
        
    } else {
        userForSignUp.signUpInBackground { (succeeded, error) -> Void in
            if error == nil {
                self.dismiss(animated: false, completion: nil)
                self.hideHUD()
                // kunal START
                let profile: Dictionary<String, AnyObject> = [
                    "Name" : self.usernameTxt.text! as AnyObject,
                    "Identity" : self.usernameTxt.text! as AnyObject,
                    "Email" : self.emailTxt.text! as AnyObject
                    
                ]
                
                CleverTap.sharedInstance()?.onUserLogin(profile)
                //kunal END
        
            // ERROR
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
        }}
    }
}
    
    
    
    
// MARK: -  TEXTFIELD DELEGATE
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTxt {  passwordTxt.becomeFirstResponder()  }
    if textField == passwordTxt {  emailTxt.becomeFirstResponder()     }
    if textField == emailTxt {
        emailTxt.resignFirstResponder()
        signupButt(self)
    }
return true
}
    
    
    
    
// MARK: - DISMISS BUTTON
@IBAction func dismissButt(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
}
    
    
    

// MARK: - TERMS OF USE BUTTON
@IBAction func touButt(_ sender: AnyObject) {
    let touVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsOfUse") as! TermsOfUse
    present(touVC, animated: true, completion: nil)
}
    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
