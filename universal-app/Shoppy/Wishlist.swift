/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/


import UIKit
import Parse


// MARK: - CUSTOM WISHLIST CELL
class WishCell: UITableViewCell {
    /* Views */
    @IBOutlet weak var wImage: UIImageView!
    @IBOutlet weak var wNameLabel: UILabel!
    @IBOutlet weak var wFinalPriceLabel: UILabel!
    @IBOutlet weak var wCurrencylabel: UILabel!
}







// MARK: - WISHLIST CONTROLLER
class Wishlist: UIViewController,
UITableViewDelegate,
UITableViewDataSource
{
    
    /* Views */
    @IBOutlet weak var wishTableView: UITableView!
    
    
    
    /* Variables */
    var wishArray = [PFObject]()
    
    
    
    
    
    
override func viewDidAppear(_ animated: Bool) {
  
}
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    // Call query
    queryWishlist()
}

    
    
    
// MARK: - QUERY YOUR WISHLIST
func queryWishlist() {
    // USER IS NOT LOGGED IN
    if PFUser.current() == nil {
        let alert = UIAlertController(title: APP_NAME,
                                      message: "You must login into your Account to add/SEE products in your Wishlist!",
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
        showHUD("Loading Wishlist...")
    
        let query = PFQuery(className: WISHLIST_CLASS_NAME)
        query.whereKey(WISHLIST_USER_POINTER, equalTo: PFUser.current()!)
        query.findObjectsInBackground { (objects, error)-> Void in
            if error == nil {
                self.wishArray = objects!
                self.wishTableView.reloadData()
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
    return wishArray.count
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WishCell", for: indexPath) as! WishCell
        
    var wishClass = PFObject(className: WISHLIST_CLASS_NAME)
    wishClass = wishArray[(indexPath as NSIndexPath).row]
    
    let prodPointer = wishClass[WISHLIST_PRODUCT_POINTER] as! PFObject
    prodPointer.fetchIfNeededInBackground { (object, error) in
        if error == nil {
            cell.wNameLabel.text = "\(prodPointer[PRODUCTS_NAME]!)"
            cell.wCurrencylabel.text = "\(prodPointer[PRODUCTS_CURRENCY]!)"
            let fPrice = prodPointer[PRODUCTS_FINAL_PRICE] as! Double
            cell.wFinalPriceLabel.text = "\(fPrice)"
            
            // Get image
            let imageFile = prodPointer[PRODUCTS_IMAGE1] as? PFFile
            imageFile?.getDataInBackground { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.wImage.image = UIImage(data:imageData)
            }}}
    }}
    
    
return cell
}
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
}
    
    
    
// MARK: - CELL HAS BEEN TAPPED -> SHOW PRODUCT DETAILS
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var wishClass = PFObject(className: WISHLIST_CLASS_NAME)
    wishClass = wishArray[(indexPath as NSIndexPath).row]
    var prodPointer = wishClass[WISHLIST_PRODUCT_POINTER] as! PFObject
    do { prodPointer = try prodPointer.fetchIfNeeded() } catch {}
    
    let pdVC = storyboard?.instantiateViewController(withIdentifier: "ProdDetails") as! ProdDetails
    pdVC.prodObj = prodPointer
    navigationController?.pushViewController(pdVC, animated: true)
}
    
    
    
// MARK: - DELETE CELL BY SWIPING THE CELL LEFT
func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
}
func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var wishClass = PFObject(className: WISHLIST_CLASS_NAME)
            wishClass = wishArray[(indexPath as NSIndexPath).row]
            
            wishClass.deleteInBackground {(success, error) -> Void in
                if error == nil {
                    self.wishArray.remove(at: (indexPath as NSIndexPath).row)
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                    
                } else {
                    self.simpleAlert("\(error!.localizedDescription)")
                }}
        
        }
}


    
    
    
// MARK: - REFRESH WISHLIST BUTTON
@IBAction func refreshButt(_ sender: AnyObject) {
    queryWishlist()
}
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
