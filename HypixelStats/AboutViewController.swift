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
        
        let mainText = "Powered by the Hypixel API.\n\nMade by Doogry.\n\nQuestions or suggestions? Please email "
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        let attributedString = NSMutableAttributedString(string: mainText, attributes: attributes)
        
        attributedString.setLink(url: "https://api.hypixel.net/", stringValue: "Hypixel API")
        attributedString.setLink(url: "https://hypixel.net/members/doogry.1257405/", stringValue: "Doogry")
        
        textView.attributedText = attributedString
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }

}
