//
//  CreateUserViewController.swift
//  Firebase-boilerplate
//
//  Created by Mariano Montori on 7/24/17.
//  Copyright © 2017 Mariano Montori. All rights reserved.
//

import UIKit
import FirebaseAuth
import PMAlertController
import SVProgressHUD

class CreateUserViewController: UIViewController {

    
    //@IBOutlet weak var profilePicImageView: UIImageView!
    //@IBOutlet  var locationLabel: UILabel!
    @IBOutlet  var fullnameTextField: UITextField!
    @IBOutlet  var usernameTextField: UITextField!
    @IBOutlet  var emailTextField: UITextField!
    @IBOutlet  var passwordTextField: UITextField!
    @IBOutlet  var signUpButton: UIButton!
    @IBOutlet  var descriptionTextView: UITextView!
    
    
    //var currentLocation = ""
    
    let PLACEHOLDER_TEXT = "This is your skills bio. Describe any skill you have. Use #Hashtags so other users can find you easier (EX: #Makeup, #Barber, #Guitarist). (You may also add this later in your profile)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        descriptionTextView.isEditable = true
        
        applyPlaceholderStyle(aTextview: descriptionTextView, placeholderText: PLACEHOLDER_TEXT)
               
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Back to Login screen!")
            }
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        guard let fullname = fullnameTextField.text,
            let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let userDescription = descriptionTextView.text,
            !username.isEmpty,
            !fullname.isEmpty,
            !email.isEmpty,
            !password.isEmpty
            else {
                print("Required fields are not all filled!")
                return
            }
        
        //let image : UIImage = self.profilePicImageView.image!
        //let descriptionText = descriptionTextView.text
        
        AuthService.createUser(controller: self, email: email, password: password) { (authUser) in
            guard let firUser = authUser else {
                return
            }
            
            UserService.create(firUser, username: username, fullname: fullname, userDescription: userDescription, email: email) { (user) in
                guard let user = user else {
                    return
                }
                User.setCurrent(user, writeToUserDefaults: true)
                let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
                let createUserSecVC = storyboard.instantiateViewController(withIdentifier: "CreateUserSecondVC") as! CreateUserSecondVC
                self.present(createUserSecVC, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Helper functions
    
    }

extension CreateUserViewController{
    
    // MARK: - Helper functions
    
    func configureView(){
        applyKeyboardPush()
        applyKeyboardDismisser()
        signUpButton.layer.cornerRadius = 10
    }
    
    /* MARK: HELPER functions */
    func dimissKeyboard()
    {
        view.endEditing(true)
    }
    
    // MARK: - Helper functions for custom placeholder
    // function for styling need to create custom placeholder for textView
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.darkText
        aTextview.alpha = 1.0
    }
    
    func moveCursorToStart(aTextView: UITextView)
    {
        DispatchQueue.main.async { () -> Void in
            aTextView.selectedRange = NSMakeRange(0, 0)
        }
    }
    

}


extension CreateUserViewController : UITextViewDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* MARK: - Text View Delegate functions */
    
    //Custom dissmissKeyboard function called (Dismisses keyboard with a click on the view)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dimissKeyboard()
    }
    
    //TODO: Needs to be fixed cursor keeps showing up at the end of the line
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == descriptionTextView && textView.text == PLACEHOLDER_TEXT
        {
            // function to move cursor to the beggining
            self.moveCursorToStart(aTextView: textView)
        }
        
    }
    
    // For custom placeholder in TextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        /* Creating custom placeholder to mimic TextField Placeholder */
        //remove the placeholder text when they start typing
        // first, see if the field is empty
        // If its not empty, then the text should be black and not italic
        // But, we also need to remove the placeholder text if thats the only text
        
        //text.utf16.count gets the length of the string
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 // Have text, so don't show the placeholder
        {
            //check if the only text is the placeholder and remove it if needed
            if textView == descriptionTextView && textView.text == PLACEHOLDER_TEXT
            {
                if text.utf16.count == 0 //They hit the back button
                {
                    return false
                }
                
                //Changing textView text back to dark color
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            
            return true
        }
        else // no text, so show the placeholder
        {
            applyPlaceholderStyle(aTextview: textView, placeholderText: PLACEHOLDER_TEXT)
            moveCursorToStart(aTextView: textView)
            return false
        }
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView == descriptionTextView && textView.text == PLACEHOLDER_TEXT
        {
            moveCursorToStart(aTextView: textView)
        }
    }

}
