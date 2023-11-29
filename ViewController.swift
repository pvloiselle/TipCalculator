//
//  ViewController.swift
//  TipCalculator
//
//  Created by Peter Loiselle on 6/18/23.
//

import Vision
import Foundation
import UIKit
import SwiftUI

extension String {
    func toDouble() -> Double? {
        return Double(self)
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var lineView1: UIView!
    var lineView2: UIView!
    var lineView3: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        backgroundImage.image = UIImage(named: "example3")
        backgroundImage.contentMode = .scaleAspectFill
        
        self.view.addSubview(backgroundImage)
        self.view.sendSubviewToBack(backgroundImage)
        
        
     //   lineView1 = UIView(frame: CGRect(x: 210, y: 210, width: 130, height: 2))
     //   lineView1.backgroundColor = UIColor.black
     //   view.addSubview(lineView1)
        
//        lineView2 = UIView(frame: CGRect(x: 210, y: 255, width: 130, height: 2))
//        lineView2.backgroundColor = UIColor.black
//        view.addSubview(lineView2)
//        
//        lineView3 = UIView(frame: CGRect(x: 210, y: 310, width: 130, height: 2))
//        lineView3.backgroundColor = UIColor.black
//        view.addSubview(lineView3)
        
        // Add the UIImageView as a subview to your main view
        
        
        
        //  checkLabel.layer.cornerRadius = 10
        //  checkLabel.layer.masksToBounds = true
        
        instructionsAndError.textColor = UIColor.black
        checkLabel.textColor = UIColor.black
        tipLabel.textColor = UIColor.black
        totalCostLabel.textColor = UIColor.black
        checkCostText.textColor = UIColor.black
        splitLabel.textColor = UIColor.black
        tipPercentLabel.textColor = UIColor.black
        tipPercentTracker.textColor = UIColor.black
        Split.textColor = UIColor.black
        
        
        // Add the slider to the view
        //  view.addSubview(tipSlider)
        checkCostText.backgroundColor = .white
        checkCostText.keyboardType = .decimalPad
        checkCostText.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        // Set the toolbar as the input accessory view
        checkCostText.inputAccessoryView = toolbar
        
//        lineView2.isHidden = true
//        lineView3.isHidden = true
        
        tipLabel.isHidden = true
        
        totalCostLabel.isHidden = true
        
        // hide the slider initially
        tipSlider.isHidden = true
        
        splitLabel.isHidden = true
        
        splitSlider.isHidden = true
        
        roundUpButton.isHidden = true
        roundDownButton.isHidden = true
        
        splitOneLess.isHidden = true
        splitOneMore.isHidden = true
        
        tipPercentLabel.isHidden = true
        tipPercentTracker.isHidden = true
        
        Split.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Check if the text field is the one you want to have an undeletable character
        if textField == checkCostText {
            // Check if the replacement string is empty (deletion)
            if string.isEmpty {
                // Check if the range includes the position of the undeletable character
                if range.location == 0 {
                    // Return false to prevent the deletion of the undeletable character
                    return false
                }
            }
        }
        
        // Allow other text field changes
        return true
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        // Perform any action when the "Done" button is tapped
        let checkCostTextPlaceholder = checkCostText.text
        let cleanedText = (checkCostTextPlaceholder?.replacingOccurrences(of: "$", with: ""))!
        if let doubleCheckCostText = Double(cleanedText) {
            checkCost = doubleCheckCostText
            checkCostText.text = makeStringAndMaybeAddZero(cost: checkCost)
            checkCostText.resignFirstResponder() // Hide the keyboard
            
            self.instructionsAndError.isHidden = true
            self.checkLabel.isHidden = false
            self.tipLabel.isHidden = false
            self.tipSlider.isHidden = false
            self.splitLabel.isHidden = false
            self.totalCostLabel.isHidden = false
            self.splitSlider.isHidden = false
            self.roundUpButton.isHidden = false
            self.roundDownButton.isHidden = false
            self.splitOneLess.isHidden = false
            self.splitOneMore.isHidden = false
            self.tipPercentLabel.isHidden = false
            self.tipPercentTracker.isHidden = false
            self.Split.isHidden = false
//            self.lineView2.isHidden = false
//            self.lineView3.isHidden = false
            
            updateLabels(sliderValue: sliderValue, splitSliderValue: splitSliderValue)
        }
        
        else if cleanedText.isEmpty {
            checkCost = 0.0
            checkCostText.text = makeStringAndMaybeAddZero(cost: checkCost)
            checkCostText.resignFirstResponder()
            
            self.instructionsAndError.isHidden = true
            self.checkLabel.isHidden = false
            self.tipLabel.isHidden = false
            self.tipSlider.isHidden = false
            self.splitLabel.isHidden = false
            self.totalCostLabel.isHidden = false
            self.splitSlider.isHidden = false
            self.roundUpButton.isHidden = false
            self.roundDownButton.isHidden = false
            self.splitOneLess.isHidden = false
            self.splitOneMore.isHidden = false
            self.tipPercentLabel.isHidden = false
            self.tipPercentTracker.isHidden = false
            self.Split.isHidden = false
//            self.lineView2.isHidden = false
//            self.lineView3.isHidden = false
            
            updateLabels(sliderValue: sliderValue, splitSliderValue: splitSliderValue)
        }
        
        else {
            self.instructionsAndError.isHidden = false
            instructionsAndError.textColor = UIColor.red
            instructionsAndError.text = "Please enter a valid dollar amount."
        }
        
    }
    
    
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            // Handle error when the selected media is not an image or cannot be cast to UIImage
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        // Call a method or closure to handle the captured/selected image
        recognizeText(image: image) { extractedText in
            
            // print("extracted text: \(extractedText)")
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    } ()
    
    
    @IBOutlet weak var checkLabel: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var totalCostLabel: UILabel!
    
    @IBOutlet weak var splitLabel: UILabel!
    
    @IBOutlet weak var tipSlider: UISlider!
    
    @IBOutlet weak var splitSlider: UISlider!
    
    @IBOutlet weak var instructionsAndError: UILabel!
    
    @IBOutlet weak var checkCostText: UITextField!
    
    @IBOutlet weak var roundUpButton: UIButton!
    
    @IBOutlet weak var roundDownButton: UIButton!
    
    @IBOutlet weak var splitOneLess: UIButton!
    
    @IBOutlet weak var splitOneMore: UIButton!
    
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipPercentTracker: UILabel!
    @IBOutlet weak var Split: UILabel!
    
    
    
    
    var checkCost: Double = 5.0
    var tip: Double = 50.0
    var sliderValue = 20
    var splitSliderValue = 1
    
    @IBAction func tipSliderValueChanged(_ sender: UISlider) {
        sliderValue = Int (sender.value)
        tip = (checkCost) * Double(sliderValue) / 100
        
        updateLabels(sliderValue: sliderValue, splitSliderValue: splitSliderValue)
    }
    
    
    @IBAction func splitSliderValueChanged(_ sender: UISlider) {
        splitSliderValue = Int (sender.value)
        
        updateLabels(sliderValue: sliderValue, splitSliderValue: splitSliderValue)
    }
    
    @IBAction func roundedUp(_ sender: UIButton) {
        
        if 0 <= sliderValue && sliderValue < 10 {sliderValue = 10}
        else if 10 <= sliderValue && sliderValue < 15 {sliderValue = 15}
        else if 15 <= sliderValue && sliderValue < 18 {sliderValue = 18}
        else if 18 <= sliderValue && sliderValue < 20 {sliderValue = 20}
        else if 20 <= sliderValue && sliderValue < 22 {sliderValue = 22}
        else if 22 <= sliderValue && sliderValue < 25 {sliderValue = 25}
        else if 25 <= sliderValue && sliderValue < 35 {sliderValue += 5}
        else if 35 <= sliderValue && sliderValue <= 40 {sliderValue = 40}
        
        tipSlider.setValue(Float(sliderValue), animated: true)
        
        updateLabels(sliderValue: sliderValue, splitSliderValue: splitSliderValue)
    }
    
    @IBAction func roundedDown(_ sender: UIButton) {
        if 30 < sliderValue && sliderValue <= 40 {sliderValue -= 5}
        else if 25 < sliderValue && sliderValue <= 30 {sliderValue = 25}
        else if 22 < sliderValue && sliderValue <= 25 {sliderValue = 22}
        else if 20 < sliderValue && sliderValue <= 22 {sliderValue = 20}
        else if 18 < sliderValue && sliderValue <= 20 {sliderValue = 18}
        else if 15 < sliderValue && sliderValue <= 18 {sliderValue = 15}
        else if 10 < sliderValue && sliderValue <= 15 {sliderValue = 10}
        else {sliderValue = 0}
        
        tipSlider.setValue(Float(sliderValue), animated: true)
        
        updateLabels(sliderValue: sliderValue, splitSliderValue: splitSliderValue)
    }
    
    @IBAction func splitOneLess(_ sender: UIButton) {
        if 1 < splitSliderValue {
            splitSliderValue -= 1
            splitSlider.setValue(Float(splitSliderValue), animated: true)
            updateLabels(sliderValue: sliderValue, splitSliderValue: splitSliderValue)
        }
    }
    
    @IBAction func splitOneMore(_ sender: UIButton) {
        if 20 > splitSliderValue {
            splitSliderValue += 1
            splitSlider.setValue(Float(splitSliderValue), animated: true)
            updateLabels(sliderValue: sliderValue, splitSliderValue: splitSliderValue)
        }
    }
    
    
    
    
    func updateLabels(sliderValue: Int, splitSliderValue: Int) {
        
        let individualCost = checkCost / Double(splitSliderValue)
        
        
        tip = individualCost * Double(sliderValue) / 100
        tipLabel.text = "Tip:               " + makeStringAndMaybeAddZero(cost: tip)
        
        checkCostText.text = makeStringAndMaybeAddZero(cost: individualCost)
        
        splitLabel.text = String(splitSliderValue)
        
        totalCostLabel.text = "Total Cost:      " + makeStringAndMaybeAddZero(cost: individualCost + tip)
        
        tipPercentTracker.text = String(sliderValue) + "%"
    }
    
    
    func makeStringAndMaybeAddZero(cost: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: cost)) ?? ""
    }
    
    
    func recognizeText(image: UIImage?, completion: @escaping (String) -> Void) {
        guard let cgImage = image?.cgImage else {
            completion("")
            return
        }
        
        //handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        //request
        let request = VNRecognizeTextRequest {[weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else{
                completion("")
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            
            
            //strategy that I currently use to sort for price
            
            var stringArray = text.components(separatedBy: ", ")
            
            
            for i in stringArray {
                let string = String(i)
                if string.contains(".") == false {
                    stringArray.remove(at: stringArray.firstIndex(of: i)!)
                    //newStringArray.append(string)
                }
            }
            
            
            let numbersOnlyStringWith$ = stringArray.joined(separator: ", ")
            
            
            
            let dollarSignPresent = numbersOnlyStringWith$.contains("$")
            
            
            var numbersOnlyArray = [Double]()
            for i in stringArray {
                var string = String(i)
                if dollarSignPresent {
                    if string.contains("$") == false && string.prefix(1) == "5" {
                        string = string.replacingOccurrences(of: "5", with: "$")
                    }
                    string = string.replacingOccurrences(of: "$", with: "")
                    
                }
                let cost = Double(string)
                if cost != nil {
                    numbersOnlyArray.append(cost!)
                }
            }
            
            
            
            self?.checkCost = numbersOnlyArray.max() ?? 0.0
            // everything else should be separated into a new function from here on out.
            
            let checkCostString = self!.makeStringAndMaybeAddZero(cost: self?.checkCost ?? 0.0)
            
            self!.tip = self!.checkCost * 20 / 100
            
            let totalCost = (self?.checkCost ?? 0.0) + (self?.tip ?? 0.0)
            let totalCostString = self!.makeStringAndMaybeAddZero(cost: totalCost)
            
            self!.tipLabel.text = "Tip:               " + self!.makeStringAndMaybeAddZero(cost: self!.checkCost * 0.2)
            self!.totalCostLabel.text = "Total Cost:      " + totalCostString
            self!.splitLabel.text = String(self!.splitSliderValue)
            
            self!.checkCostText.text = checkCostString
            
            
            if self!.checkCost != 0 {
                self!.instructionsAndError.isHidden = true
                self!.checkLabel.isHidden = false
                self!.tipLabel.isHidden = false
                self!.tipSlider.isHidden = false
                self!.splitLabel.isHidden = false
                self!.totalCostLabel.isHidden = false
                self!.splitSlider.isHidden = false
                self!.roundUpButton.isHidden = false
                self!.roundDownButton.isHidden = false
                self!.splitOneLess.isHidden = false
                self!.splitOneMore.isHidden = false
                self!.tipPercentLabel.isHidden = false
                self!.tipPercentTracker.isHidden = false
                self!.Split.isHidden = false
//                self!.lineView2.isHidden = false
//                self!.lineView3.isHidden = false
            }
            
            else {
                self!.instructionsAndError.isHidden = false
                self?.instructionsAndError.textColor = UIColor.red
                self!.instructionsAndError.text = "No reciept detected. Please try again or the enter cost manually."
            }
        }
        
        
        //process request
        do {
            try handler.perform([request])
        }
        catch {
            print("error")
            completion("")
        }
        
    }
}
