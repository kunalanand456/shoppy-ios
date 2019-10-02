/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/

import UIKit
import Parse
import CleverTapSDK



// MARK: - CUSTOM PRODUCT CELL
class ProductCell: UICollectionViewCell {
    /* Views */
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var pNameLabel: UILabel!
    @IBOutlet weak var pCurrencyLabel: UILabel!
    @IBOutlet weak var pPriceLabel: UILabel!
    @IBOutlet weak var pBigPriceLabel: UILabel!
    @IBOutlet weak var pCurrency2Label: UILabel!
    @IBOutlet weak var pCategoryName: UILabel!
}









// MARK: - PRODUCTS CONTROLLER
class ProductsList: UIViewController,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
{

    /* Views */
    @IBOutlet weak var productsCollView: UICollectionView!
    
    
    
    /* Variables */
    var categoryName = ""
    var productsArray = [PFObject]()
    
    
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    // Layout
    self.title = "\(categoryName)".uppercased()
    
    // begin kunal
    let props = [
        "Category": categoryName
    ]
    
    CleverTap.sharedInstance()?.recordEvent("Category viewed", withProps: props)
    // end kunal

    // call query
    queryProducts()
}

    

// MARK: - QUERY PRODUCTS
func queryProducts() {
    showHUD("Loading Products...")
    let query = PFQuery(className: PRODUCTS_CLASS_NAME)
    query.whereKey(PRODUCTS_CATEGORY, equalTo: categoryName)
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.productsArray = objects!
            self.productsCollView.reloadData()
            self.hideHUD()
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
    
    
    
// MARK: - COLLECTION VIEW DELEGATES
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}
    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return productsArray.count
}
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
    
    var pClass = PFObject(className: PRODUCTS_CLASS_NAME)
    pClass = productsArray[indexPath.row]

    cell.pNameLabel.text = "\(pClass[PRODUCTS_NAME]!)"
    cell.pCurrencyLabel.text = "\(pClass[PRODUCTS_CURRENCY]!)"
    let fPrice = pClass[PRODUCTS_FINAL_PRICE] as! Double
    cell.pPriceLabel.text = "\(fPrice)"
    //cell.pCategoryName.text = categoryName

    if pClass[PRODUCTS_BIG_PRICE] != nil {
        let bigPrice = pClass[PRODUCTS_BIG_PRICE] as! Double
        if bigPrice != 0  {
            let attrString = NSAttributedString(string: "\(pClass[PRODUCTS_CURRENCY]!) \(bigPrice)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            cell.pBigPriceLabel.attributedText = attrString
        } else { cell.pBigPriceLabel.text = "" }
    } else { cell.pBigPriceLabel.text = "" }
    
    
    // Get image
    let imageFile = pClass[PRODUCTS_IMAGE1] as? PFFile
    imageFile?.getDataInBackground { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                cell.pImage.image = UIImage(data:imageData)
    }}}

    
return cell
}
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width/2 - 20, height: 160)
}
    
    
// MARK: - TAP ON A CELL -> SHOW PRODUCT DETAILS
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var pClass = PFObject(className: PRODUCTS_CLASS_NAME)
    pClass = productsArray[(indexPath as NSIndexPath).row]
    
    let pdVC = storyboard?.instantiateViewController(withIdentifier: "ProdDetails") as! ProdDetails
    pdVC.prodObj = pClass
    navigationController?.pushViewController(pdVC, animated: true)
        
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
