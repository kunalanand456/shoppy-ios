/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/

import UIKit
import MessageUI


class ContactUs: UIViewController,
MFMailComposeViewControllerDelegate
{

    /* Views */
    @IBOutlet weak var addressOutlet: UIButton!
    @IBOutlet weak var phoneOutlet: UIButton!
    
    
    

    
override func viewDidLoad() {
        super.viewDidLoad()


}


// MARK: - OPEN ADDRESS IN NATIVE iOS MAPS APP
@IBAction func openAddressInMapsButt(_ sender: AnyObject) {
    let baseUrl: String = "http://maps.apple.com/?q="
    let addressStr = addressOutlet.titleLabel!.text!
    let encodeName = addressStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!
    let finalUrl = baseUrl + encodeName
    if let url = URL(string: finalUrl) {
        UIApplication.shared.openURL(url)
    }
}
    
    
    
// MARK: - MAKE PHONE CALL BUTTON
@IBAction func phoneButt(_ sender: AnyObject) {
    let aURL = URL(string: "telprompt://\(phoneOutlet.titleLabel!.text!)")!
    if UIApplication.shared.canOpenURL(aURL) {
        UIApplication.shared.openURL(aURL)
    }
}
    

    
// MARK: - CONTACT BY EMAIL BUTTON
@IBAction func contactByEmailButt(_ sender: AnyObject) {
    // This string containes standard HTML tags, you can edit them as you wish
    
    let messageStr = "Hello,"
    
    let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    mailComposer.setSubject("Info request for \(APP_NAME)")
    mailComposer.setMessageBody(messageStr, isHTML: true)
    mailComposer.setToRecipients([CONTACT_US_EMAIL_ADDRESS])
    
    if MFMailComposeViewController.canSendMail() { present(mailComposer, animated: true, completion: nil)
    } else {
        simpleAlert("Your device cannot send emails. Please configure an email address into Settings -> Mail, Contacts, Calendars.")
    }
}
    
 
// Email delegate
func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var resultMess = ""
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            resultMess = "Mail cancelled"
        case MFMailComposeResult.saved.rawValue:
            resultMess = "Mail saved"
        case MFMailComposeResult.sent.rawValue:
            resultMess = "Thanks for contacting us!\nWe'll get back to you asap."
        case MFMailComposeResult.failed.rawValue:
            resultMess = "Something went wrong with sending Mail, try again later."
        default:break
        }
        
        // Show email result alert
        simpleAlert(resultMess)
        dismiss(animated: true, completion: nil)
}
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
