/*-----------------------------------
 
 - Shoppy -
 
 Created by cubycode ©2016
 All Rights Reserved
 
 -----------------------------------*/


import UIKit
import Parse



class CatCell: UITableViewCell {
    /* Views */
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var catName: UILabel!
}







// MARK: - HOME CONTROLLER
class Home: UIViewController,
UITableViewDelegate,
UITableViewDataSource
{

    /* Views */
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var accountOutlet: UIBarButtonItem!
    
    
    
    /* Variables */
    var categoriesArray = [PFObject]()
   
    
    
    
    

    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    /*  
    IMPORTANT: RUN THE APP ON A REAL DEVICE OR SIMULATOR, 1 TIME ONLY, AND THEN STOP IT AFTER YOU'LL GET AN ALERT VIEW.
    AFTER THE APP IS STOPPED, COMMENT (OR REMOVE) THE LINE OF CODE BELOW: 'createDemoCategoryAndProduct()'
    AND UNCOMMENT 'queryCategories()'
     THEN YOU'LL BE ABLE TO LOGIN IN IN YOUR PARSE DASHBOARD ON back4app OR EVEN ON Adminca (https://adminca.com) AND ADD/EDIT PRODUCTS & CATEGORIES.
    IN THIS WAY YOU'LL AVOID TO MANUALLY ADD ALL THE REQUIRED COLUMNS AND FIELDS IN YOUR PARSE DASHBOARD, THE APP WILL AUTOMATICALLY ADD THEM AND
    YOU'LL HAVE TO EDIT THEM AND ADD NEW PRODUCTS/CATEGORIES */
    
    // createDemoCategoryAndProduct()
    
 
 
 
    // UNCOMMENT THE LINE BELOW AFTER YOU'VE RAN THE APP FOR THE FIRST TIME AND STOPPED IT
    queryCategories()
    
}

    

// MARK: - QUERY CATEGORIES
func queryCategories() {
    showHUD("Loading...")
    let query = PFQuery(className: CATEGORIES_CLASS_NAME)
    query.findObjectsInBackground { (objects, error)-> Void in
        if error == nil {
            self.categoriesArray = objects!
            self.categoryTableView.reloadData()
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
    return categoriesArray.count
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatCell

    var catClass = PFObject(className: CATEGORIES_CLASS_NAME)
    catClass = categoriesArray[(indexPath as NSIndexPath).row]
    
    cell.catName.text = "\(catClass[CATEGORIES_CATEGORY]!)".uppercased()
    
    // Get image
    let imageFile = catClass[CATEGORIES_IMAGE] as? PFFile
    imageFile?.getDataInBackground { (imageData, error) -> Void in
        if error == nil {
            if let imageData = imageData {
                cell.catImage.image = UIImage(data:imageData)
    }}}
    
    cell.colorView.backgroundColor = colorsArray[(indexPath as NSIndexPath).row]
    
    
return cell
}
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
}
    
    
// MARK: -  CELL HAS BEEN TAPPED
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var catObj = PFObject(className: CATEGORIES_CLASS_NAME)
    catObj = categoriesArray[(indexPath as NSIndexPath).row]
    
    let pVC = storyboard?.instantiateViewController(withIdentifier: "ProductsList") as! ProductsList
    pVC.categoryName = "\(catObj[CATEGORIES_CATEGORY]!)"
    navigationController?.pushViewController(pVC, animated: true)
}

    
   
// MARK: - ACCOUNT BUTTON
@IBAction func accountButt(_ sender: AnyObject) {
    if PFUser.current() != nil {
        let aVC = storyboard?.instantiateViewController(withIdentifier: "Account") as! Account
        present(aVC, animated: true, completion: nil)
    } else {
        let aVC = storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
        present(aVC, animated: true, completion: nil)
    }
}
    
    
    
// this method must be ran one time only
func createDemoCategoryAndProduct() {
    showHUD("Creating fields...")
    
    let catClass = PFObject(className: CATEGORIES_CLASS_NAME)
    catClass[CATEGORIES_CATEGORY] = "edit me"
    let anImage = UIImage(named: "logo")
    let imageData = anImage!.jpegData(compressionQuality: 0.1)
    let imageFile = PFFile(name:"image.jpg", data:imageData!)
    catClass[CATEGORIES_IMAGE] = imageFile
    catClass.saveInBackground(block: { (succ, error) in
        if error == nil {
            
            let pClass = PFObject(className: PRODUCTS_CLASS_NAME)
            pClass[PRODUCTS_CATEGORY] = "edit me"
            pClass[PRODUCTS_NAME] = "edit me"
            let imageData = anImage!.jpegData(compressionQuality: 0.1)
            let imageFile = PFFile(name:"image.jpg", data:imageData!)
            pClass[PRODUCTS_IMAGE1] = imageFile
            let imageFile2 = PFFile(name:"image.jpg", data:imageData!)
            pClass[PRODUCTS_IMAGE2] = imageFile2
            let imageFile3 = PFFile(name:"image.jpg", data:imageData!)
            pClass[PRODUCTS_IMAGE3] = imageFile3
            let imageFile4 = PFFile(name:"image.jpg", data:imageData!)
            pClass[PRODUCTS_IMAGE4] = imageFile4
            
            pClass[PRODUCTS_FINAL_PRICE] = 0
            pClass[PRODUCTS_BIG_PRICE] = 0
            pClass[PRODUCTS_CURRENCY] = "edit me"
            
            pClass[PRODUCTS_DESCRIPTION] = "edit me"
            
            pClass.saveInBackground(block: { (succ, error) in
                if error == nil {
                    self.simpleAlert("Products and Category classes have been created in your Parse Dashboard on back{4}app, now you can stop the app, remove the code in Home.swift, uncomment 'queryCategories()' and start inserting Products and Categories in your database")
                    self.hideHUD()
            
                // error
                } else {
                    self.simpleAlert("\(error!.localizedDescription)")
                    self.hideHUD()
            }})
            
        // error
        } else {
            self.simpleAlert("\(error!.localizedDescription)")
            self.hideHUD()
    }})
}
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
