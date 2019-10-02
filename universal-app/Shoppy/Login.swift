/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/

import UIKit
import Parse
import ParseFacebookUtilsV4
import CleverTapSDK


class Login: UIViewController,
UITextFieldDelegate
{
    
    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    
    @IBOutlet var loginViews: [UIView]!
    @IBOutlet weak var loginOutlet: UIButton!
    
    @IBOutlet var loginButtons: [UIButton]!
   
    @IBOutlet weak var logoImage: UIImageView!
    
    
    
    
override func viewWillAppear(_ animated: Bool) {
    if PFUser.current() != nil {  dismiss(animated: false, completion: nil) }
}
override func viewDidLoad() {
        super.viewDidLoad()
        
    // Setup layouts
    containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: 600)

    
    // Change placeholder's color
    let color = UIColor.white
    usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: color])
    passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: color])
    
    // Round logo's corners
    logoImage.layer.cornerRadius = 20

    
    
    /* UNCOMMENT THIS CODE IF YOU WANT TO ROUND VIEWS CORNERS
    // Round views corners
    for aView in loginViews {
        aView.layer.cornerRadius = 8
        aView.layer.borderColor = UIColor.whiteColor().CGColor
        aView.layer.borderWidth = 1
    }
    loginOutlet.layer.cornerRadius = 5
    
    for butt in loginButtons {
        butt.layer.cornerRadius = 10
        butt.layer.borderColor = UIColor.whiteColor().CGColor
        butt.layer.borderWidth = 1
    }
     */
}
    
    
    
   
// MARK: - LOGIN BUTTON
@IBAction func loginButt(_ sender: AnyObject) {
    dismissKeyboard()
    showHUD("Logging in...")
        
    PFUser.logInWithUsername(inBackground: usernameTxt.text!, password:passwordTxt.text!) { (user, error) -> Void in
        if error == nil {
            self.dismiss(animated: true, completion: nil)
            self.hideHUD()
            //kunal Start
            let props = [
                "Username" : self.usernameTxt.text!
            ]
            CleverTap.sharedInstance()?.recordEvent("Login", withProps: props)
            

            //kunal End
        // Login failed
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
    

    
    
    

    
    
// MARK: - FACEBOOK LOGIN BUTTON
@IBAction func facebookButt(_ sender: Any) {
    // Set permissions required from the Facebook user account
    let permissions = ["public_profile", "email"];
    showHUD("Please wait...")
    
    // Login PFUser using Facebook
    PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
        if user == nil {
            self.simpleAlert("Facebook login cancelled")
            self.hideHUD()
            
        } else if (user!.isNew) {
            print("NEW USER signed up and logged in through Facebook!");
            self.getFBUserData()
            
        } else {
            print("User logged in through Facebook!");
            
            self.dismiss(animated: true, completion: nil)
            self.hideHUD()
    }}
}
    
    
func getFBUserData() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest) { (connection, result, error) in
            if error == nil {
                let userData:[String:AnyObject] = result as! [String : AnyObject]
                
                // Get data
                let name = userData["name"] as! String
                var email = ""
                if userData["email"] != nil { email = userData["email"] as! String
                } else { email = "noemail@facebook.com" }
                
                
                let currUser = PFUser.current()!

                // Update user data
                let nameArr = name.components(separatedBy: " ")
                var username = String()
                for word in nameArr {
                    username.append(word.lowercased())
                }
                currUser.username = username
                currUser.email = email
                currUser[USER_FULLNAME] = name
                currUser.saveInBackground(block: { (succ, error) in
                    if error == nil {
                        self.hideHUD()
                        print("USER'S DATA UPDATED...")
                        self.dismiss(animated: true, completion: nil)
                }})
                
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
        }}
        connection.start()
}

    
    
    
    
    
    
    
    
    
// MARK: - SIGNUP BUTTON
@IBAction func signupButt(_ sender: AnyObject) {
    let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUp
    present(signupVC, animated: true, completion: nil)
}
    
    
    
    
    
// MARK: - TEXTFIELD DELEGATES
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTxt  {  passwordTxt.becomeFirstResponder() }
    if textField == passwordTxt  {
        passwordTxt.resignFirstResponder()
        loginButt(self)
    }
return true
}
    
    
    
    
    
// MARK: - TAP TO DISMISS KEYBOARD
@IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
    dismissKeyboard()
}
func dismissKeyboard() {
    usernameTxt.resignFirstResponder()
    passwordTxt.resignFirstResponder()
}


    
    
    
    
    
// MARK: - FORGOT PASSWORD BUTTON
@IBAction func forgotPasswButt(_ sender: AnyObject) {
    let alert = UIAlertController(title: APP_NAME,
      message: "Type the email address you've used to sign up.",
      preferredStyle: .alert)
    
    let ok = UIAlertAction(title: "Reset Password", style: .default, handler: { (action) -> Void in
        // TextField
        let textField = alert.textFields!.first!
        let txtStr = textField.text!
        
        PFUser.requestPasswordResetForEmail(inBackground: txtStr, block: { (succ, error) in
            if error == nil {
                self.simpleAlert("You will receive an email shortly with a link to reset your password")
            }})
    })
    
    // Cancel button
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
    
    // Add textField
    alert.addTextField { (textField: UITextField) in
        textField.keyboardAppearance = .dark
        textField.keyboardType = .default
    }
    
    alert.addAction(ok)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
}


    
    
    
// MARK: - DISMISS BUTTON
@IBAction func dismissButt(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
}

    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
