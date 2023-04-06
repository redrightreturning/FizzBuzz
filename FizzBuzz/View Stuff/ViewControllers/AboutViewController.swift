//
//  AboutViewController.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/18/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import UIKit

protocol AboutViewControllerDelegate {
    func dismissed()
}
class AboutViewController: UIViewController, DeviceFeedback, FizzBuzz{

    static let STORYBOARD_ID = "AboutViewController"
    
    var delegate : AboutViewControllerDelegate?
    @IBOutlet weak var cancelView: CancelView!
    @IBOutlet weak var mainView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Cancel tap view
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(self.outsideViewTapped(sender: )))
        view.addGestureRecognizer(tapOutside)
    }
    
    override func viewDidLayoutSubviews() {
        let radius : CGFloat = 10.0
        mainView.layer.cornerRadius = radius
        mainView.layer.masksToBounds = false
        
        mainView.layer.shadowColor = UIColor.gray.cgColor
        //view.layer.shadowPath = view.layer.path
        mainView.layer.shadowOpacity = 0.2
        mainView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        mainView.layer.shadowRadius = 10.0
    }
    
    func dismissView(){
        lightDeviceFeedback()
        audioManager.closeMenu()
        cancelView.animateView()
        dismiss(animated: true, completion: {[unowned self] in
            self.delegate?.dismissed()
        })
    }
    
    @objc func outsideViewTapped(sender : UITapGestureRecognizer){
        let loc = sender.location(in: mainView)
        if(!mainView.point(inside: loc, with: nil)){
            dismissView()
        }
    }
    
    @IBAction func cancelViewTapped(_ sender: CancelView) {
        dismissView()
    }
    
    @IBAction func websiteButtonTapped(_ sender: ButtonView) {
        lightDeviceFeedback()
        sender.animateView()
        audioManager.playNumber()
        let websiteString = "http://elliotkg.com/"
        if let url = URL(string: websiteString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func helpButtonTapped(_ sender: ButtonView) {
        lightDeviceFeedback()
        sender.animateView()
        audioManager.playFizz()
        let storyBoard = UIStoryboard(name: self.storyboardName, bundle: nil)
        let howToViewController = storyBoard.instantiateViewController(withIdentifier: HowToViewController.STORYBOARD_ID) as! HowToViewController
        howToViewController.isFirstPresentation = true
        present(howToViewController, animated: true, completion: nil)
    }
    
    @IBAction func emailButtonTapped(_ sender: ButtonView) {
        lightDeviceFeedback()
        sender.animateView()
        audioManager.playBuzz()
        let mailString = "mailto:ElliotKGoldman@Gmail.com?subject=FizzBuzz"
        if let url = URL(string: mailString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
