//
//  AboutViewController.swift
//  HypixelStats
//
//  Created by Edison Ooi on 9/3/21.
//

import UIKit

class AboutViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let completeString = NSMutableAttributedString()
        
        let mainText = "Powered by the Hypixel API.\n\nQuestions or suggestions? Please email statshypickle@gmail.com\n\n\n\n\n\n"
        
        let attributionText = "App Icon is a modified version of pickle by Tyler Hanns from thenounproject.com"
        let affiliationText = "\n\nHypickle is not affiliated with Hypixel."
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        let secondaryAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1),
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ]
        
        let mainString = NSMutableAttributedString(string: mainText, attributes: attributes)
        let affiliationString = NSMutableAttributedString(string: affiliationText, attributes: secondaryAttributes)
        let attributionString = NSMutableAttributedString(string: attributionText, attributes: secondaryAttributes)
        
        
        mainString.setLink(url: "https://api.hypixel.net/", stringValue: "Hypixel API")
        attributionString.setLink(url: "https://thenounproject.com/term/pickle/852963/", stringValue: "pickle")
        
        completeString.append(mainString)
        completeString.append(attributionString)
        completeString.append(affiliationString)
        
        
        textView.attributedText = completeString
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }

}
