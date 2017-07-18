//
//  DetailViewController.swift
//  helloworld
//
//  Created by iOS Dev Log on 2017/7/18.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class DetailViewController: UIViewController {
    
    var webView: UIWebView!
    var textView : UITextView!
    @IBOutlet weak var themeButtonItem: UIBarButtonItem!
    @IBOutlet weak var languageButtonItem: UIBarButtonItem!
    
    func configureView() {
        if let detail = detailItem {
            if let textView = textView {
                updateColors()
                
                let content = try! String(contentsOfFile: detail)
                
                textView.text = content
                let fileName = (detail as NSString).lastPathComponent
                let components = fileName.components(separatedBy: ".")
                if components.count > 0 {
                    let language = components[0].lowercased()
                    let languages = HighlightModel.sharedInstance.highlightr.supportedLanguages().sorted()
                    if languages.contains(language) {
                        HighlightModel.sharedInstance.textStorage.language = language
                    }
                    
                    title = language
                }
                
                updateColors()
            }
        } else {
            if let webView = webView {
                let url = URL(string: "https://helloworldcollection.github.io")
                let request = URLRequest(url: url!)
                webView.loadRequest(request)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if detailItem == nil {
            webView = UIWebView()
            webView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(webView)
            let topConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: bottomLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            let leftConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            
            view.addConstraints([topConstraint, rightConstraint, bottomConstraint, leftConstraint])
        } else {
            textView = UITextView(frame: CGRect.zero, textContainer: HighlightModel.sharedInstance.textContainer)
            textView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(textView)
            
            textView.isEditable = false
            textView.autocorrectionType = UITextAutocorrectionType.no
            textView.autocapitalizationType = UITextAutocapitalizationType.none
            textView.textColor = UIColor(white: 0.8, alpha: 1.0)
            let topConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: bottomLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            let leftConstraint = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
            
            view.addConstraints([topConstraint, rightConstraint, bottomConstraint, leftConstraint])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureView()
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @IBAction func pickLanguage(_ sender: AnyObject) {
        let languages = HighlightModel.sharedInstance.highlightr.supportedLanguages().sorted()
        let indexOrNil = languages.index(of: (title?.lowercased())!)
        let index = (indexOrNil == nil) ? 0 : indexOrNil!
        
        ActionSheetStringPicker.show(withTitle: "Pick a Language Syntax",
                                     rows: languages,
                                     initialSelection: index,
                                     doneBlock:
            {
                picker, index, value in
                let language = value! as! String
                HighlightModel.sharedInstance.textStorage.language = language
                self.title = language.capitalized
                
        },
                                     cancel: nil,
                                     origin: sender)
        
    }

    
    func updateColors() {
        let navBar = self.navigationController!.navigationBar
        navBar.barTintColor = HighlightModel.sharedInstance.highlightr.theme.themeBackgroundColor
        navBar.tintColor = HighlightModel.sharedInstance.invertColor((navBar.barTintColor!))
        
        textView.textColor = navBar.tintColor.withAlphaComponent(0.5)
        textView.backgroundColor = HighlightModel.sharedInstance.highlightr.theme.themeBackgroundColor
    }
}

