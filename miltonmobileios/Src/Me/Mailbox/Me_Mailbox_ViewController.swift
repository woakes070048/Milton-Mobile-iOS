import UIKit
import Alamofire

class Me_Mailbox_ViewController: UIViewController {
    @IBOutlet weak var mailboxNumberField: UILabel!
    @IBOutlet weak var mailboxCombinationField: UILabel!
    @IBOutlet weak var nameField: UILabel!
    
    func back(sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "Log Out?", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            KeychainWrapper.removeObjectForKey("loggedIn")
            KeychainWrapper.removeObjectForKey("username")
            KeychainWrapper.removeObjectForKey("password")
            KeychainWrapper.removeObjectForKey("firstName")
            KeychainWrapper.removeObjectForKey("lastName")
            KeychainWrapper.removeObjectForKey("classNumber")
            
            let alert = UIAlertView();
            alert.title = "Logged Out"
            alert.message = "You have been logged out"
            alert.addButtonWithTitle("OK")
            alert.show()
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in

        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        let newBackButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let retrievedString = KeychainWrapper.stringForKey("loggedIn") {
            if (retrievedString == "true") {
                let username = KeychainWrapper.stringForKey("username")!
                let password = KeychainWrapper.stringForKey("password")!
                
                self.nameField.text = KeychainWrapper.stringForKey("firstName")! + " " + KeychainWrapper.stringForKey("lastName")!
            
            
                Alamofire.request(.GET,"http://backend.ma1geek.org/me/mailbox/get", parameters:["username":username,"password":password]).responseJSON{response in
                    let data = response.2.value;
                    var json = JSON(data!).dictionaryObject as! [String: String]
                    let mailbox = json["mailbox"]
                    let combination = json["combo"]
                    
                    self.mailboxNumberField.text = mailbox
                    self.mailboxCombinationField.text = combination
                }
            }
            else {
                self.navigationController?.popViewControllerAnimated(false)
            }
        }
        else {
            self.navigationController?.popViewControllerAnimated(false)
        }
    }
}
