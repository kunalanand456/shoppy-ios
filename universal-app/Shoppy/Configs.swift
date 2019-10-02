/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/


import Foundation
import UIKit




// IMPORTANT: Replace the red string below with the new name you'll give to this app
let APP_NAME = "Shoppy"


// IMPORTANT: Reaplce the red strings below with your own Application ID and Client Key of your app on back4app.com
let PARSE_APP_KEY = "bJNa7YyMBfCQt4u6tcRahzJrpyRRtYXW6yH522ME"
let PARSE_CLIENT_KEY = "36d3DWaQ6mxxhWwPU2JMWGPlwr6uRbDQnXyGCzMq"
//-----------------------------------------------------------------------------


// IMPORTANT: Replace the email address below with the one you'll use to receive Order emails from buyers
let ADMIN_EMAIL_ADDRESS = "oders@gmydomain.com"


// IMPORTANT: Replace the email address below with the one you'll use to receive contact requests from Users
let CONTACT_US_EMAIL_ADDRESS = "info@gmydomain.com"


// IMPORTANT: Change the red string below with the path where you've stored the orderDetails.php file (in this case we've stored it into a directory in our website called "shoppy")
let PATH_TO_PHP_FILE = "http://www.fvimagination.com/shoppy/"




// IMPORTANT: REPLACE THE KEYS BELOW WITH YOUR OWN ONES YOU'LL GET ON YOUR PAYPAL DEVELOPER DASHBOARD AT: https://developer.paypal.com/developer/applications/
let PAYPAL_ENVIRONMENT_LIVE_KEY =  "AVKj_dqHAwdJdf7auXv_r7cIErQIaBTvldSE07SVlQ3MEc5xOy_XaEwkDRuc3PKIdIZU1Fs4jT-m89Z5"
let PAYPAL_ENVIRONMENT_SANDBOX_KEY = "AcJS37_ZNSZHJbwPt16XTbiaucamy9_MI-BSBLJLyhVCiPo9zxhONd5XiOYbMdS4isw0oWV2Gj3KesyW"


// IF YOUR STORE IS NOT LOCATED IN THE U.S. AND YOU'LL USE ANOTHER CURRENCY, REPLACE "USD" WITH YOUR OWN CURRENCY
let MY_CURRENCY_CODE = "USD"

// REPLACE THE RED NAME BELOW WITH THE ONE OF YOUR STORE/COMPANY
let MERCHANT_NAME = "Shoppy Inc."

// REPLACE THE LINKS BELOW WITH YOUR OWN PRIVACY POLICY AND USER AGREEMENT URL'S
let PRIVACY_POLICY_URL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
let USER_AGREEMENT_URL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")





// YOU CAN EDIT THE RGB VALUES OF ALL THESE COLORS AS YOU WISH
let colorsArray = [
    UIColor(red: 237.0/255.0, green: 85.0/255.0, blue: 100.0/255.0, alpha: 1.0),    // HATS category
    UIColor(red: 250.0/255.0, green: 110.0/255.0, blue: 82.0/255.0, alpha: 1.0),    // BAGS category
    UIColor(red: 255.0/255.0, green: 207.0/255.0, blue: 85.0/255.0, alpha: 1.0),    // EYEWEAR category
    UIColor(red: 160.0/255.0, green: 212.0/255.0, blue: 104.0/255.0, alpha: 1.0),   // T-SHIRTS category
    UIColor(red: 72.0/255.0, green: 207.0/255.0, blue: 174.0/255.0, alpha: 1.0),    // SHOES category
    UIColor(red: 79.0/255.0, green: 192.0/255.0, blue: 232.0/255.0, alpha: 1.0),    // JEWELS category
    UIColor(red: 93.0/255.0, green: 155.0/255.0, blue: 236.0/255.0, alpha: 1.0),
    UIColor(red: 172.0/255.0, green: 146.0/255.0, blue: 237.0/255.0, alpha: 1.0),
    UIColor(red: 150.0/255.0, green: 123.0/255.0, blue: 220.0/255.0, alpha: 1.0),
    UIColor(red: 236.0/255.0, green: 136.0/255.0, blue: 192.0/255.0, alpha: 1.0),
    UIColor(red: 218.0/255.0, green: 69.0/255.0, blue: 83.0/255.0, alpha: 1.0),
    UIColor(red: 246.0/255.0, green: 247.0/255.0, blue: 251.0/255.0, alpha: 1.0),
    UIColor(red: 230.0/255.0, green: 233.0/255.0, blue: 238.0/255.0, alpha: 1.0),
    UIColor(red: 204.0/255.0, green: 208.0/255.0, blue: 217.0/255.0, alpha: 1.0),
    UIColor(red: 67.0/255.0, green: 74.0/255.0, blue: 84.0/255.0, alpha: 1.0),
    UIColor(red: 198.0/255.0, green: 156.0/255.0, blue: 109.0/255.0, alpha: 1.0),

]






// HUD View
let hudView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
var label = UILabel()
let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
extension UIViewController {
    func showHUD(_ message:String) {
        hudView.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        hudView.backgroundColor = UIColor.darkGray
        hudView.alpha = 1.0
        hudView.layer.cornerRadius = 10
        
        indicatorView.center = CGPoint(x: hudView.frame.size.width/2, y: hudView.frame.size.height/2)
        indicatorView.style = UIActivityIndicatorView.Style.white
        hudView.addSubview(indicatorView)
        indicatorView.startAnimating()
        view.addSubview(hudView)
        
        label.frame = CGRect(x: 5, y: 90, width: 115, height: 20)
        label.font = UIFont(name: "Titillium-Semibold", size: 16)
        label.text = message
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        hudView.addSubview(label)
    }
    
    func hideHUD() { hudView.removeFromSuperview() }
    
    func simpleAlert(_ mess:String) {
        let alert = UIAlertController(title: APP_NAME, message: mess, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}








/****** DO NOT EDIT THE CODE BELOW *****/
let USER_CLASS_NAME = "_User"
let USER_USERNAME = "username"
let USER_EMAIL = "email"
let USER_FULLNAME = "fullName"
let USER_SHIPPING_ADDRESS = "shippingAddress"

let CATEGORIES_CLASS_NAME = "Categories"
let CATEGORIES_CATEGORY = "category"
let CATEGORIES_IMAGE = "image"

let PRODUCTS_CLASS_NAME = "Products"
let PRODUCTS_CATEGORY = "category"
let PRODUCTS_NAME = "name"
let PRODUCTS_IMAGE1 = "image1"
let PRODUCTS_IMAGE2 = "image2"
let PRODUCTS_IMAGE3 = "image3"
let PRODUCTS_IMAGE4 = "image4"
let PRODUCTS_FINAL_PRICE = "finalPrice"
let PRODUCTS_BIG_PRICE = "bigPrice"
let PRODUCTS_CURRENCY = "currency"
let PRODUCTS_DESCRIPTION = "description"

let CART_CLASS_NAME = "Cart"
let CART_TOTAL_AMOUNT = "totalAmount"
let CART_PRODUCT_POINTER = "productPointer"
let CART_PRODUCT_QTY = "qty"
let CART_USER_POINTER = "userPointer"
let CART_NOTES = "notes"

let WISHLIST_CLASS_NAME = "Wishlist"
let WISHLIST_USER_POINTER = "userPointer"
let WISHLIST_PRODUCT_POINTER = "prodPointer"

let ORDERS_CLASS_NAME = "Orders"
let ORDERS_USER_EMAIL = "userEmail"
let ORDERS_USER_POINTER = "userPointer"
let ORDERS_USER_USERNAME = "userUsername"
let ORDERS_PAYMENT_PROOF = "paymentProof"
let ORDERS_PRODUCT_POINTER = "prodPointer"
let ORDERS_PRODUCT_QTY = "qty"





