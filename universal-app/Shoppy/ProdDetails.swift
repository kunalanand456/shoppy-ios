/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
-----------------------------------*/

import UIKit
import Parse
import CleverTapSDK


class ProdDetails: UIViewController,
UIScrollViewDelegate
{

    /* Views */
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    
    @IBOutlet weak var prodNameLabel: UILabel!
    @IBOutlet weak var prodPriceLabel: UILabel!
    @IBOutlet weak var addToCartOutlet: UIButton!
    
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var descriptionTxt: UITextView!
    
    
    
    
    /* Variables */
    var prodObj = PFObject(className: PRODUCTS_CLASS_NAME)
  
    
    
    
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    // Layouts
    imageView1.frame.origin.x = 0
    imageView2.frame.origin.x = imagesScrollView.frame.size.width
    imageView3.frame.origin.x = imagesScrollView.frame.size.width*2
    imageView4.frame.origin.x = imagesScrollView.frame.size.width*3
    imageView1.frame.origin.y = 0
    imageView2.frame.origin.y = 0
    imageView3.frame.origin.y = 0
    imageView4.frame.origin.y = 0
    self.automaticallyAdjustsScrollViewInsets = false
    
    
    // Check this product and show its details
    checkProduct()
    
    
    // Show product details
    showProdcutDetails()
}

    
    
    
// MARK: - CHECK PRODUCT
func checkProduct() {
    if PFUser.current() == nil {
        self.addToCartOutlet.setTitle("Add to cart".uppercased(), for: .normal)
        self.addToCartOutlet.isEnabled = true
        
    } else {
    
        // Check if this Product is already in your Cart
        let query = PFQuery(className: CART_CLASS_NAME)
        query.whereKey(CART_USER_POINTER, equalTo: PFUser.current()!)
        query.whereKey(CART_PRODUCT_POINTER, equalTo: prodObj)
        query.findObjectsInBackground { (objects, error)-> Void in
            if error == nil {
                if objects?.count != 0 {
                    self.addToCartOutlet.setTitle("This product is in your cart".uppercased(), for: .normal)
                    self.addToCartOutlet.isEnabled = false
                } else {
                    self.addToCartOutlet.setTitle("Add to cart".uppercased(), for: .normal)
                    self.addToCartOutlet.isEnabled = true
                }
        }}
        
    }
}
    
    
    
    
// MARK: - SHOW PRODUCT DETAILS
func showProdcutDetails() {
    
    // Get 1st Image
    let imageFile = prodObj[PRODUCTS_IMAGE1] as? PFFile
    imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.imageView1.image = UIImage(data:imageData)
                self.pageControl.numberOfPages = 1
                self.imagesScrollView.contentSize = CGSize(width: self.imagesScrollView.frame.size.width * CGFloat(self.pageControl.numberOfPages)+1, height: self.imagesScrollView.frame.size.height)
    }}})
    
    // Get 2nd Image
    let imageFile2 = prodObj[PRODUCTS_IMAGE2] as? PFFile
    imageFile2?.getDataInBackground(block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.imageView2.image = UIImage(data:imageData)
                self.pageControl.numberOfPages = 2
                self.imagesScrollView.contentSize = CGSize(width: self.imagesScrollView.frame.size.width * CGFloat(self.pageControl.numberOfPages)+1, height: self.imagesScrollView.frame.size.height)
    }}})
    
    // Get 3rd image
    let imageFile3 = prodObj[PRODUCTS_IMAGE3] as? PFFile
    imageFile3?.getDataInBackground(block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.imageView3.image = UIImage(data:imageData)
                self.pageControl.numberOfPages = 3
                self.imagesScrollView.contentSize = CGSize(width: self.imagesScrollView.frame.size.width * CGFloat(self.pageControl.numberOfPages)+1, height: self.imagesScrollView.frame.size.height)
    }}})
    
    // Get 4th image
    let imageFile4 = prodObj[PRODUCTS_IMAGE4] as? PFFile
    imageFile4?.getDataInBackground(block: { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                self.imageView4.image = UIImage(data:imageData)
                self.pageControl.numberOfPages = 4
                self.imagesScrollView.contentSize = CGSize(width: self.imagesScrollView.frame.size.width * CGFloat(self.pageControl.numberOfPages)+1, height: self.imagesScrollView.frame.size.height)
    }}})
    

    
    // Get price and name
    let fPrice = prodObj[PRODUCTS_FINAL_PRICE] as! Double
    prodPriceLabel.text = "$ \(fPrice)"
    prodNameLabel.text = "\(prodObj[PRODUCTS_NAME]!)"
    
    // Get description
    descriptionTxt.text = "\(prodObj[PRODUCTS_DESCRIPTION]!)"
  
    // kunal start
    let props = [
        "Amount": fPrice,
        "category": prodObj[PRODUCTS_CATEGORY],
        "product": prodObj[PRODUCTS_NAME]
    ]
    
    CleverTap.sharedInstance()?.recordEvent("Product viewed", withProps: props)
    //kunal end

}

  
    
    
    
    
// MARK: - SCROLLVIEW DELEGATE
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageWidth = imagesScrollView.frame.size.width
    let page = Int(floor((imagesScrollView.contentOffset.x * 2 + pageWidth) / (pageWidth * 2)))
    pageControl.currentPage = page
}

    

    

    
    
// MARK: - ADD TO CART BUTTON
@IBAction func addToCartButt(_ sender: AnyObject) {
    
    // USER IS LOGGED IN
    if PFUser.current() != nil {
        showHUD("Adding to Cart")

        let cartClass = PFObject(className: CART_CLASS_NAME)
        let currentUser = PFUser.current()
                    
        cartClass[CART_USER_POINTER] = currentUser
        cartClass[CART_PRODUCT_POINTER] = prodObj
        cartClass[CART_PRODUCT_QTY] = 1
        cartClass[CART_TOTAL_AMOUNT] = prodObj[PRODUCTS_FINAL_PRICE]
                    
        // Saving block
        cartClass.saveInBackground { (success, error) -> Void in
            if error == nil {
                self.simpleAlert("You've added a \(self.prodObj[PRODUCTS_NAME]!) to your Cart!")
                self.hideHUD()
                self.checkProduct()
                
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
        }
            // editing - Kunal
            let props = [
                "Product Name": self.prodObj[PRODUCTS_NAME],
                "Amount": self.prodObj[PRODUCTS_FINAL_PRICE],
                "Quantity": self.prodObj[CART_PRODUCT_QTY]
            ]
            
            CleverTap.sharedInstance()?.recordEvent("Added to Cart", withProps: props)
            //finish_Editing
        }
        
        
        
    // USER IS NOT LOGGED IN
    } else {
        let alert = UIAlertController(title: APP_NAME,
                                      message: "You must login into your Account to add products in your Cart!",
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
        
    }
}
    

    
    
    
    
// MARK: - ADD TO WISHLIST BUTTON
@IBAction func addToWishlistButt(_ sender: AnyObject) {
    
    // USER IS NOT LOGGED IN
    if PFUser.current() == nil {
        let alert = UIAlertController(title: APP_NAME,
                                      message: "You must login into your Account to add products in your Wishlist!",
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
        showHUD("Adding to Wishlist...")
        
        let query = PFQuery(className: WISHLIST_CLASS_NAME)
        query.whereKey(WISHLIST_USER_POINTER, equalTo: PFUser.current()!)
        query.whereKey(WISHLIST_PRODUCT_POINTER, equalTo: prodObj)
        query.findObjectsInBackground { (objects, error)-> Void in
            if error == nil {
            
                // ADD  PRODUCT TO WISHLIST
                if objects?.count == 0 {
                    let wishClass = PFObject(className: WISHLIST_CLASS_NAME)
                    let currentUser = PFUser.current()
                
                    wishClass[WISHLIST_USER_POINTER] = currentUser
                    wishClass[WISHLIST_PRODUCT_POINTER] = self.prodObj
                
                    // Saving block
                    wishClass.saveInBackground { (success, error) -> Void in
                        if error == nil {
                            self.simpleAlert("You've added \(self.prodObj[PRODUCTS_NAME]!) to your Wishlist!")
                            self.hideHUD()
                        } else {
                            self.simpleAlert("\(error!.localizedDescription)")
                            self.hideHUD()
                    }}

                
                // THIS PRODUCT IS ALREADY IN WISHLIST!
                } else {
                    self.simpleAlert("This product is already in your Wishlist!")
                    self.hideHUD()
                }
            
            
            // Error in query
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
        }}
    
    }
}
    
    
    
    
    
// MARK: - BACK BUTTON
@IBAction func backButt(_ sender: AnyObject) {
    _ = navigationController?.popViewController(animated: true)
}

    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
