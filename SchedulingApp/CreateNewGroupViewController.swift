import UIKit
import Parse

class User {
    
    var name:String?
}

class CreateNewGroupViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var userExists:Bool?
    var userArray:[User] = []
    var usernamesArray:[String] = []
    
    //var existingUsers:[User] = []
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //self.existingUsers = array pulled from Parse
        
        //code below for testing purposes
        //        let jake:User = User()
        //        jake.name = "jake"
        //        self.existingUsers.insert(jake,atIndex:0)
        //
        //        let jp:User = User()
        //        jp.name = "jp"
        //        self.existingUsers.insert(jp,atIndex:0)
        //
        //        let jeff:User = User()
        //        jeff.name = "jeff"
        //        self.existingUsers.insert(jeff,atIndex:0)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func queryParse(){
        let query = PFUser.query()
        query!.whereKey("username", equalTo:self.userTextField.text!)
        // query!.whereKey("username", equalTo:"JPAA")
        
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                if(objects!.count > 0){
                self.userExists = true
                print("Successfully retrieved \(objects!.count) usernames.")
                }else{
                self.userExists = false
                print("That username does not exist")

                }
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        if let result = object["username"] as? String{
                            print(result)
                            
                        }
                       
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.handleUser()
                        
                    })

                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
               
            }
        }
    }
    
    
    func checkIfUserExists(){
        
        queryParse()
        //        if self.usernamesArray.contains(self.userTextField.text!) {
        //            self.userExists = true
        //        }else{
        //            self.userExists = false
        //        }
        
    }
    
    func handleUser(){
        if(self.userExists! == true){
            let aUser = User()
            aUser.name = self.userTextField.text!
            self.userArray.insert(aUser,atIndex:0)
            self.tableView.reloadData()
            
        }else{
            let alertController = UIAlertController(title: "User does not exist!", message: "Please check spelling and try again!", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func addMemberAction(sender: AnyObject) {
        
        checkIfUserExists()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return userArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let aUser:User = self.userArray[indexPath.row]
        
        cell.textLabel?.text = (aUser.name)
        
        return cell
    }
    
    
    
    
}

