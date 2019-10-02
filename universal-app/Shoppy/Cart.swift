/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/

import UIKit
import Parse
import CleverTapSDK

// MARK: - CUSTOM CART CELL
class CartCell: UITableViewCell {
    /* Views */
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var pNameLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var qtyStepper: UIStepper!
    @IBOutlet weak var addNoteOutlet: UIButton!
    @IBOutlet weak var pPriceLabel: UILabel!
    @IBOutlet weak var pCurrencyLabel: UILabel!
}








// MARK: - CART CONTROLLER
class Cart: UIViewController,
PayPalPaymentDelegate,
UITableViewDelegate,
UITableViewDataSource
{

    // IMPORTANT: BEFORE SUBMITTING THE APP TO THE APP STORE, UNCOMMENT PayPalEnvironmentProduction AND REMOVE PayPalEnvironmentNoNetwork BELOW:
    var environment:String = PayPalEnvironmentSandbox /* PayPalEnvironmentProduction */  {
        
    willSet(newEnvironment) {
        if (newEnvironment != environment) { PayPalMobile.preconnect(withEnvironment: newEnvironment) }
    }}
    var payPalConfig = PayPalConfiguration()

    
    
    /* Views */
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var checkoutOutlet: UIButton!
    
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var noteTxt: UITextView!
    
    
    
    
    /* Variables */
    var cartArray = [PFObject]()
    var totalAmountArray = [Double]()
    
    var dataURL = Data()
    var reqURL = URL(string: "")
    var request = NSMutableURLRequest()
    var itemsOrdered = [String]()
    var messStr = ""
    var totalAmountStr = ""
    
    
    
    
    
    
    
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Preconnect PayPal environment
    PayPalMobile.preconnect(withEnvironment: environment)
    
    // Hide notesView
    notesView.frame.origin.y = view.frame.size.height
}
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    // NOTE: IF YOU DON'T HAVE A VERIFIED US OR UK PAYPAL ACCOUNT, THEN LEAVE THIS VARIABLE AS IT IS (false), BECAUSE YOU WON'T BE ABLE TO USE CREDIT CARD PAYMENTS.
    payPalConfig.acceptCreditCards = false
    
    payPalConfig.merchantName = MERCHANT_NAME
    payPalConfig.merchantPrivacyPolicyURL = PRIVACY_POLICY_URL as URL?
    payPalConfig.merchantUserAgreementURL = USER_AGREEMENT_URL as URL?
    payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
    payPalConfig.payPalShippingAddressOption = .provided;
    
    print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")

    
    
    // Call query
    queryCart()
}


    
    
// MARK: - QUERY CART
func queryCart() {
    
    // USER IS NOT LOGGED IN
    if PFUser.current() == nil {
        let alert = UIAlertController(title: APP_NAME,
                                      message: "You must login into your Account to add/see products in your Cart!",
                                      preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Login", style: .default, handler: { (action) -> Void in
            let aVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
            self.present(aVC, animated: true, completion: nil)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
        
    // USER IS LOGGED IN
    } else {
        showHUD("Updating Cart...")
    
        totalAmountArray.removeAll()
    
        // query
        let query = PFQuery(className: CART_CLASS_NAME)
        if PFUser.current() != nil { query.whereKey(CART_USER_POINTER, equalTo: PFUser.current()!) }
        query.findObjectsInBackground { (objects, error)-> Void in
            if error == nil {
                self.cartArray = objects!
            
                if self.cartArray.count != 0 {
                    self.cartTableView.reloadData()
        
                    // Calculate total amount
                    self.calculateTotalAmount()
                    
                    // Reset Checkout button
                    self.checkoutOutlet.isEnabled = true
                    self.checkoutOutlet.setTitle("Checkout".uppercased(), for: .normal)
                
                    
                } else {
                    self.totalAmountLabel.text = "0"
                    self.checkoutOutlet.setTitle("No products in your cart".uppercased(), for: .normal)
                    self.checkoutOutlet.isEnabled = false
                }
        
                self.hideHUD()
            
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
            }}
    }
}

    
    
    
    
// MARK: - TABLEVIEW DELEGATES
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cartArray.count
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
    var cartClass = PFObject(className: CART_CLASS_NAME)
    cartClass = cartArray[indexPath.row]
    
    let prodPointer = cartClass[CART_PRODUCT_POINTER] as! PFObject
    prodPointer.fetchIfNeededInBackground { (object, error) in
        // Get data
        cell.pNameLabel.text = "\(prodPointer[PRODUCTS_NAME]!)"
        let fPrice = prodPointer[PRODUCTS_FINAL_PRICE] as! Double
        cell.pPriceLabel.text = "\(fPrice)"
        cell.pCurrencyLabel.text = "\(prodPointer[PRODUCTS_CURRENCY]!)"
        cell.qtyLabel.text = "\(cartClass[CART_PRODUCT_QTY]!)"
        cell.qtyStepper.value = cartClass[CART_PRODUCT_QTY] as! Double

        // Get image
        let imageFile = prodPointer[PRODUCTS_IMAGE1] as? PFFile
        imageFile?.getDataInBackground { (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.pImage.image = UIImage(data:imageData)
        }}}
        
        
        
        // Assign tags to views
        cell.qtyStepper.tag = indexPath.row
        cell.addNoteOutlet.tag = indexPath.row
        
        // Set currency label
        self.currencyLabel.text = "\(prodPointer[PRODUCTS_CURRENCY]!)"
        
    }
    
    
return cell
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
}
    
    
    
    
// MARK: - DELETE CELL BY SWIPING THE CELL LEFT
func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
}
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        
            self.showHUD("Updating Cart...")
            var cartClass = PFObject(className: CART_CLASS_NAME)
            cartClass = cartArray[(indexPath as NSIndexPath).row]
            cartClass.deleteInBackground {(success, error) -> Void in
                if error == nil {
                    self.cartArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    // Recall query to update the Cart and Total amount
                    self.queryCart()
                    self.hideHUD()
                // error
                } else {
                    self.simpleAlert("\(error!.localizedDescription)")
                    self.hideHUD()
                }}
    }
}

    
    
    
// MARK: - CALCULATE THE TOTAL AMOUNT
func calculateTotalAmount() {
    for i in 0..<cartArray.count {
        var cartClass = PFObject(className: CART_CLASS_NAME)
        cartClass = cartArray[i]
        
        let prodPointer = cartClass[CART_PRODUCT_POINTER] as! PFObject
        prodPointer.fetchIfNeededInBackground { (object, error) in
            
            // Set Total amount
            let totalSingleProdPrice = prodPointer[PRODUCTS_FINAL_PRICE] as! Double
            let qtyToMultiply = cartClass[CART_PRODUCT_QTY] as! Double
            let multiplyPrice = totalSingleProdPrice * qtyToMultiply
            // print("\(multiplyPrice)")
        
            self.totalAmountArray.append(multiplyPrice)
            let aTotalSum = self.totalAmountArray.reduce(0, +)
            self.totalAmountLabel.text = "\(aTotalSum)"
        }
        
    }//end FOR loop
    
}
    
    
    
    
    
    
// MARK: - ADD/EDIT NOTE BUTTON
    var noteIndex = Int()
@IBAction func addNoteButt(_ sender: UIButton) {
    noteIndex = sender.tag
    showNotesView()
}
    
    
    
// MARK: - SHOW/HUDE NOTE VIEW
func showNotesView() {
    noteTxt.text = ""
    noteTxt.becomeFirstResponder()
    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
        self.notesView.frame.origin.y = 64
    }, completion: { (finished: Bool) in })
}
func hideNotesView() {
    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
        self.notesView.frame.origin.y = self.view.frame.size.height
    }, completion: { (finished: Bool) in })
}
    

// MARK: - SAVE NOTE BUTTON
@IBAction func saveNoteButt(_ sender: AnyObject) {
    noteTxt.resignFirstResponder()
    
    var cartClass = PFObject(className: CART_CLASS_NAME)
    cartClass = cartArray[noteIndex]
    
    cartClass[CART_NOTES] = noteTxt.text
    cartClass.saveInBackground { (succ, error) in
        if error == nil {
            print("Note Saved for product at index: \(self.noteIndex)")
            self.hideNotesView()
    }}
}
    
    
    
    
    
    
// MARK: - STEPPER FOR PRODUCT QUANITY
@IBAction func stepperChanged(_ sender: UIStepper) {
    // Update qtyLabel value
    let indexP = IndexPath(row: sender.tag, section: 0)
    let cell = cartTableView.cellForRow(at: indexP) as! CartCell
    
    // Reset the Checkout button
    checkoutOutlet.isEnabled = false
    checkoutOutlet.setTitle("Hit refresh button to update Total".uppercased(), for: .normal)
    
    
    // Update product Qty in Parse
    var cartClass = PFObject(className: CART_CLASS_NAME)
    cartClass = cartArray[sender.tag]
    let prodPointer = cartClass[CART_PRODUCT_POINTER] as! PFObject
    prodPointer.fetchIfNeededInBackground { (object, error) in
        if error == nil {
            cell.qtyLabel.text = "\(Int(sender.value))"
            
            cartClass[CART_PRODUCT_QTY] = Int(sender.value)
            cartClass.saveInBackground(block: { (succ, error) in
                if error != nil {
                    self.simpleAlert("\(error!.localizedDescription)")
                }
            })
    }}
    
}
    
    
    
    

// MARK: - CHECKOUT BUTTON
@IBAction func checkoutButt(_ sender:AnyObject) {
    if PFUser.current()![USER_SHIPPING_ADDRESS] != nil {
        let totalToCheckout = NSDecimalNumber(string: totalAmountLabel.text!)
        totalAmountStr = "\(totalToCheckout)"
        // kunal - begin
        let props = [
            "Amount" : totalAmountStr,
            "Payment Mode" : "Paypal",
           // "Item Product Name": PRODUCTS_NAME
        ]
        CleverTap.sharedInstance()?.recordEvent("Charged", withProps: props)
        // kunal - end
        // PayPal initialization disabled by kunal
        //let payment = PayPalPayment(amount: totalToCheckout, currencyCode: MY_CURRENCY_CODE, shortDescription: "\(APP_NAME) Purchase", intent: .sale)
   
        //if (payment.processable) {
        //    let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
        //    present(paymentViewController!, animated: true, completion: nil)
        //} else {
        //    simpleAlert("Payment not processalbe: \(payment)")
        //}
        simpleAlert("You've successfully paid your order with PayPal!\nWe'll ship your order asap!")

        
    } else {
        simpleAlert("Please add a Shipping Address into your Account.\nGo back to the Home screen and tap the User icon on the top-right corner, then update your profile.")
    }
}
    
 
// MARK: -  PayPalPaymentDelegate
func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
    simpleAlert("PayPal Payment Cancelled!")
    paymentViewController.dismiss(animated: true, completion: nil)
}
    
    
 
    
func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
    simpleAlert("You've successfully paid your order with PayPal!\nWe'll ship your order asap!")
    
    paymentViewController.dismiss(animated: true, completion: { () -> Void in
        print("Proof of payment:\n\(completedPayment.confirmation)\n")
        
        self.itemsOrdered.removeAll()
        
        
        for i in 0..<self.cartArray.count {
            var cartClass = PFObject(className: CART_CLASS_NAME)
            cartClass = self.cartArray[i]
            
            let prodPointer = cartClass[CART_PRODUCT_POINTER] as! PFObject
            prodPointer.fetchIfNeededInBackground { (object, error) in
                if error == nil {
                    
                    // Save Order
                    let orderClass = PFObject(className: ORDERS_CLASS_NAME)
                    orderClass[ORDERS_USER_POINTER] = PFUser.current()!
                    orderClass[ORDERS_USER_EMAIL] = PFUser.current()!.email
                    orderClass[ORDERS_USER_USERNAME] = PFUser.current()!.username
                    orderClass[ORDERS_PAYMENT_PROOF] = "\(completedPayment.confirmation)"
                    orderClass[ORDERS_PRODUCT_POINTER] = prodPointer
                    orderClass[ORDERS_PRODUCT_QTY] = cartClass[CART_PRODUCT_QTY]! as! Int
                    orderClass.saveInBackground(block: { (succ, error) in
                        if error == nil {
                            print("Order saved!")
                            
                            
                            // Create array of items ordered (for the emails to Admin and Buyer
                            var anItem = ""
                            if cartClass[CART_NOTES] != nil {
                            anItem = "\(prodPointer[PRODUCTS_NAME]!)   |||   QTY: \(cartClass[CART_PRODUCT_QTY]!)  |||   NOTE: \(cartClass[CART_NOTES]!)"
                            } else {
                                anItem = "\(prodPointer[PRODUCTS_NAME]!)  |||  QTY: \(cartClass[CART_PRODUCT_QTY]!)"
                            }
                            self.itemsOrdered.append(anItem)
                            
                            
                            // Remove Products from the Cart
                            cartClass.deleteInBackground {(success, error) -> Void in
                                if error == nil {
                                    self.cartArray.removeAll()
                                    self.cartTableView.reloadData()
                                    print("Prouct removed from Cart!")

                                    // Reset Total Amount
                                    self.totalAmountLabel.text = "0"
                                    self.checkoutOutlet.setTitle("No products in your cart".uppercased(), for: .normal)
                                    self.checkoutOutlet.isEnabled = false
                                    
                                    
                                // error on deleting products from the cart
                                } else { self.simpleAlert("\(error!.localizedDescription)")
                            }}
                        
                        // error on saving Order
                        } else { self.simpleAlert("\(error!.localizedDescription)") }
                    })
                 
                // error on fetching ProdPointer
                } else { self.simpleAlert("\(error!.localizedDescription)")
            }}
            
        } // end for loop
      
        
        // Call methods to send an email to Buyer and Admin
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.sendEmailToAdmin), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.sendEmailToBuyer), userInfo: nil, repeats: false)
    
    })
}
    

  
// MARK: - SEND EMAILS TO ADMIN & BUYER
@objc func sendEmailToAdmin() {
    let messStr = "PRODUCTS ORDERED:\n" + itemsOrdered.joined(separator: "\n") + "\n\nTOTAL: \(self.currencyLabel.text!) \(self.totalAmountStr)"
    let receiverEmail = "\(PFUser.current()![USER_EMAIL]!)"

    let strURL = "\(PATH_TO_PHP_FILE)adminMessage.php?name=\(PFUser.current()!.username!)&fromEmail=\(receiverEmail)&messageBody=\(messStr)&receiverEmail=\(ADMIN_EMAIL_ADDRESS)&storeName=\(APP_NAME)&shippingAddress=\(PFUser.current()![USER_SHIPPING_ADDRESS]!)"
    self.reqURL = URL(string: strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)! )!
    self.request = NSMutableURLRequest()
    self.request.url = self.reqURL
    self.request.httpMethod = "GET"
    let connection = NSURLConnection(request: self.request as URLRequest, delegate: self, startImmediately: true)
    print("REQUEST URL: \(String(describing: self.reqURL))\nCONNECTION: \(String(describing: connection))")
    
}
    

@objc func sendEmailToBuyer() {
    let receiverEmail = "\(PFUser.current()![USER_EMAIL]!)"
    let messStr = "PRODUCTS ORDERED:\n" + itemsOrdered.joined(separator: "\n") + "\n\nTOTAL: \(self.currencyLabel.text!) \(self.totalAmountStr)"
    
    let strURL = "\(PATH_TO_PHP_FILE)buyerMessage.php?name=\(PFUser.current()!.username!)&fromEmail=\(ADMIN_EMAIL_ADDRESS)&messageBody=\(messStr)&receiverEmail=\(receiverEmail)&storeName=\(APP_NAME)&shippingAddress=\(PFUser.current()![USER_SHIPPING_ADDRESS]!)"
    self.reqURL = URL(string: strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)! )!
    self.request = NSMutableURLRequest()
    self.request.url = self.reqURL
    self.request.httpMethod = "GET"
    let connection = NSURLConnection(request: self.request as URLRequest, delegate: self, startImmediately: true)
    print("REQUEST URL: \(String(describing: self.reqURL))\nCONNECTION: \(String(describing: connection))")
}
    
    
    
    
    
    
    
// MARK: - REFRESH CART BUTTON
@IBAction func refreshButt(_ sender: AnyObject) {
    queryCart()
}
  
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
