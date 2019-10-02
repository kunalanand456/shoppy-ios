/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/


import UIKit
import Parse


// MARK: - CUSTOM ORDER CELL
class OrderCell: UITableViewCell {
    /* Views */
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var pNameLabel: UILabel!
    @IBOutlet weak var pDateLabel: UILabel!
    @IBOutlet weak var pQtyLabel: UILabel!
}






// MARK: - MY ORDERS CONTROLLER
class MyOrders: UIViewController,
UITableViewDelegate,
UITableViewDataSource
{

    /* Views */
    @IBOutlet weak var ordersTableView: UITableView!
    let refreshControl = UIRefreshControl()

    
    
    /* Variables */
    var myOrdersArray = [PFObject]()
   
    
    
    
    
override func viewDidLoad() {
        super.viewDidLoad()

    // Init a refresh Control
    refreshControl.tintColor = UIColor.black
    refreshControl.addTarget(self, action: #selector(refreshTB), for: .valueChanged)
    ordersTableView.addSubview(refreshControl)


    // Call query
    queryMyOrders()
}


    
    
// MARK: - QUERY MY ORDERS
func queryMyOrders() {
    showHUD("Loading Orders...")
    
    let query = PFQuery(className: ORDERS_CLASS_NAME)
    query.whereKey(ORDERS_USER_POINTER, equalTo: PFUser.current()!)
    query.order(byDescending: "createdAt")
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.myOrdersArray = objects!
            self.ordersTableView.reloadData()
            self.hideHUD()
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }}
}
   
  
// MARK: - TABLEVIEW DELEGATES
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return myOrdersArray.count
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
    
    var oClass = PFObject(className: ORDERS_CLASS_NAME)
    oClass = myOrdersArray[(indexPath as NSIndexPath).row]
   
    // Get productPointer
    let prodPointer = oClass[ORDERS_PRODUCT_POINTER] as! PFObject
    prodPointer.fetchIfNeededInBackground { (object, error) in
        
        // Product name
        cell.pNameLabel.text = "\(prodPointer[PRODUCTS_NAME]!)"
        
        // Qty
        cell.pQtyLabel.text = "Qty: \(oClass[ORDERS_PRODUCT_QTY]!)"
        
        // Date
        let date = oClass.createdAt
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM dd yyyy | hh:mm a"
        cell.pDateLabel.text = dateFormat.string(from: date!)
        
        // Image
        let imageFile = prodPointer[PRODUCTS_IMAGE1] as? PFFile
        imageFile?.getDataInBackground { (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.pImage.image = UIImage(data:imageData)
        }}}
    }
    

return cell
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
}
    
    

  
    
// MARK: - REFRESH DATA
@objc func refreshTB () {
    queryMyOrders()
    
    if refreshControl.isRefreshing {
        let formatter = DateFormatter()
        let date = Date()
        formatter.dateFormat = "MMM d, h:mm a"
        let title = "Last update: \(formatter.string(from: date))"
        let attrsDictionary = NSDictionary(object: UIColor.darkGray, forKey: NSAttributedString.Key.foregroundColor as NSCopying)
        let attributedTitle = NSAttributedString(string: title, attributes: attrsDictionary as? [NSAttributedString.Key : Any]);
        refreshControl.attributedTitle = attributedTitle
        refreshControl.endRefreshing()
    }
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
