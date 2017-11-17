//
//  HireViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 8/13/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit
import SendGrid
import PMAlertController

class HireViewController: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    let PLACEHOLDER_TEXT = ""
    var postUser : User!
    var jobTitle: String = ""
    var jobDescription: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTV.isEditable = true
        applyPlaceholderStyle(aTextview: descriptionTV, placeholderText: PLACEHOLDER_TEXT)
       // navigationItem.title = "Hire: \(postUser.username)"
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255.0/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
        
        print(postUser)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hireButtonPressed(_ sender: Any) {
        
        //TODO: Need to implement check for nil text input
        guard let title = titleTF.text,
                  let description = descriptionTV.text
            
        else {
            return
        }
        
        self.jobTitle = title
        self.jobDescription = description
        
        
        
        JobService.create(title: title, jobDescription: description, postUser: postUser)
        RecieptService.create(title: title, jobDescription: description, postUser: postUser)
        self.sendEmailSG()
        //self.dismiss(animated: true, completion: nil)
        self.alertVC()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HireViewController{
    
    func configureView(){
        applyKeyboardPush()
        applyKeyboardDismisser()
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
    
    func alertVC()
    {
        let alertVC = PMAlertController(title: "Job Assigned", description: "You have assigned a job to user \n \(postUser.username)", image: UIImage(named: ""), style: .alert)
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
           // self.navigationController?.popToRootViewController(animated: true)
        print("Capture action Cancel")
        }))
        alertVC.addAction(PMAlertAction(title: "OK", style: .default, action: {
            
            self.dismiss(animated: false) {
                // go back to MainMenuView as the eyes of the user
                self.presentingViewController?.dismiss(animated: true, completion: nil);
                //self.navigationController?.popToRootViewController(animated: true)
            }
//            self.dismiss(animated: true, completion: nil)
           // self.navigationController?.popToRootViewController(animated: true)
            print("Okay pressed")
        }))
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    // Sendgrid email
    func sendEmailSG()
    {
        // Send a basic example
        let currentEmail = postUser.email
        let bodyString = "\n Hello \(postUser.fullname)! \n \(User.current.username) has assigned a new job to you. The job has a \n title of: \n \(self.jobTitle) \n description of: \n \(jobDescription) \n\n From, \n Savvy "
        let personalization = Personalization(recipients: currentEmail)
        let plainText = Content(contentType: ContentType.plainText, value: bodyString )
        //let htmlText = Content(contentType: ContentType.htmlText, value: "<h1>Hello World</h1>")
        let email = Email(
            personalizations: [personalization],
            from: Address("savvyinc.jobs@gmail.com"),
            content: [plainText],
            subject: "New Job Assigned!"
        )
        do {
            try Session.shared.send(request: email)
        } catch {
            print(error)
        }
    }
    
}

extension HireViewController : UITextViewDelegate
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
        if textView == descriptionTV && textView.text == PLACEHOLDER_TEXT
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
            if textView == descriptionTV && textView.text == PLACEHOLDER_TEXT
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
        if textView == descriptionTV && textView.text == PLACEHOLDER_TEXT
        {
            moveCursorToStart(aTextView: textView)
        }
    }
    
}
