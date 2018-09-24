//
//  PhotoEditingViewController.swift
//  PhotoEditi
//
//  Created by Admin on 24/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import ImageProcessing
class PhotoEditingViewController: UIViewController, PHContentEditingController {

    var input: PHContentEditingInput?
 
    var processedImage: UIImage?
   var processor = ImageProcessor()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addFilterButton: UIButton!
    
    @IBAction func cancel(sender: UIButton) {
        if let input = input {
            imageView.image = input.displaySizeImage
            processedImage = nil
        }
    }
    
    @IBAction func addFilter(sender: UIButton) {
        if let input = input {
            processedImage = processor.processImage(image: input.displaySizeImage!)
            imageView.image = processedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PHContentEditingController
    
    func canHandle(_ adjustmentData: PHAdjustmentData) -> Bool {
        // Inspect the adjustmentData to determine whether your extension can work with past edits.
        // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
        return false
    }
    
    func startContentEditing(with contentEditingInput: PHContentEditingInput, placeholderImage: UIImage) {
        // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
        // If you returned true from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
        // If you returned false, the contentEditingInput has past edits "baked in".
        input = contentEditingInput
    }
    
    func finishContentEditing(completionHandler: @escaping ((PHContentEditingOutput?) -> Void)) {
        // Update UI to reflect that editing has finished and output is being rendered.
        if input == nil {
            self.cancelContentEditing()
            return
        }
        
        // Render and provide output on a background queue.
        DispatchQueue.global().async {
            // Create editing output from the editing input.
            let contentEditingOutput = PHContentEditingOutput(contentEditingInput: self.input!)
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: "Face Blur")
            let identifier = "Addtech.Hacker-News.AddEditingPhoto"
            let adjustdata = PHAdjustmentData(formatIdentifier: identifier, formatVersion: "1.0", data: archiveData)
            // Provide new adjustments and render output to given location.
            contentEditingOutput.adjustmentData = adjustdata
            if let path = self.input?.fullSizeImageURL?.path{
                var image = UIImage(contentsOfFile: path)
                image = self.processor.processImage(image: image!)
                let jpegData = UIImageJPEGRepresentation(image!, 1.0)
                
                
                do {
                    let saveSucceeded = try jpegData?.write(to: contentEditingOutput.renderedContentURL, options: .atomic)
                    if (saveSucceeded != nil)  {
                        completionHandler(contentEditingOutput)
                    }
                    else {
                        print("Save error")
                        completionHandler(nil)
                    }
                    
                }
                catch let error as NSError{
                    print(error)
                }
                
            }else {
                print("Load error")
                completionHandler(nil)
            }
            // let renderedJPEGData = <#output JPEG#>
            // renderedJPEGData.writeToURL(output.renderedContentURL, atomically: true)
            
            // Call completion handler to commit edit to Photos.
            completionHandler(contentEditingOutput)
            
            // Clean up temporary files, etc.
        }
    }
    
    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return false
    }
    
    func cancelContentEditing() {
        // Clean up temporary files, etc.
        // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
    }

}
