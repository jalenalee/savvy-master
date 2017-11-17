//
//  AddPostViewController.swift
//  Savvy
//
//  Created by Elmer Astudillo on 7/31/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import UIKit


class AddPostViewController : UIViewController
{
    
    @IBOutlet var postTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    var pickerData = [String]()
    var category : String?
    var videoURL : URL?
    let PLACEHOLDER_TEXT = "Describe your talent using text and hashtags#"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(videoURL ?? "VideoURL is NIL")
        
        //TODO: need to add more categories
        pickerData = ["Beauty", "Music", "Automotive", "Art", "Grooming"]
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        descriptionTV.delegate = self
        descriptionTV.isEditable = true
        applyPlaceholderStyle(aTextview: descriptionTV, placeholderText: PLACEHOLDER_TEXT)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func postButtonWasPressed(_ sender: UIButton) {
        
        guard let newVideoURL = videoURL,
              let postTitle = postTF.text?.lowercased(),
              let postDescription = descriptionTV.text,
              let pickerCategory = category
            else { return }
        
        // Converting URL to String
        //Creating a post object
        //let post = Post(postDescription: postDescription, videoURL: videoURLString)
        // Saving to firebase
        let urlString = videoURL?.path
         let videoSnapshot = VideoHelper.videoSnapshot(videoURL: urlString!)
        
        
        
        PostService.create(postTitle: postTitle, postDescription: postDescription, category: pickerCategory, videoURL: newVideoURL, image: videoSnapshot! )
        
//        let mainST = UIStoryboard(name: "Main", bundle: nil)
//        let VC = mainST.instantiateViewController(withIdentifier: "TabBarController")
//        present(VC, animated: false, completion: nil)
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}



extension AddPostViewController{
    
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
    
}

extension AddPostViewController : UIPickerViewDelegate
{
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.category = pickerData[row]
        print(self.category ?? "nil")
    }
}

extension AddPostViewController : UIPickerViewDataSource
{

    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerData.count
    }
    
}

extension AddPostViewController : UITextViewDelegate
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

