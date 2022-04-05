//
//  TimePopUpViewController.swift
//  BuzzPaddle
//
//  Created by John Bresnahan on 10/4/17.
//  Copyright © 2017 BuzzTroll Computing. All rights reserved.
//

import UIKit

class TimePopUpViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var mInitalValue : String?
    var mTitle : String?
    var mConsumer : PopupPickerConsumer?
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pickTimeChoice: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .popover
        self.preferredContentSize = CGSize(width: 180, height: 150)
        
        if let aConsumer = mConsumer {
            pickTimeChoice.delegate = aConsumer.getPickerDelegate()
            pickTimeChoice.dataSource = aConsumer.getPickerDelegate()
        
            lblTitle.text = aConsumer.getTitle()
            aConsumer.getPickerDelegate().setValueFromStore(thePicker: self.pickTimeChoice)
        }
        else {
            print("TimePopUpViewController ERROR!")
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUp(theConsumer: PopupPickerConsumer) {
        mConsumer = theConsumer
    }
    
    @IBAction func buttonPress(_ sender: Any) {
        if let aConsumer = mConsumer {
            aConsumer.saveValue(thePicker: pickTimeChoice)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func show(vc : BaseViewControll) {
        self.modalPresentationStyle = .popover
        self.preferredContentSize = CGSize(width: 180, height: 150)
        
        
        if let presentationController = self.popoverPresentationController, let aConsumer = mConsumer {
            presentationController.delegate = vc
            presentationController.permittedArrowDirections = .any
            presentationController.sourceView = aConsumer.getUIControl()
            presentationController.sourceRect = aConsumer.getUIControl().bounds
            vc.present(self, animated: true, completion: {
                self.mConsumer!.getPickerDelegate().setValueFromStore(thePicker: self.pickTimeChoice!)
                self.pickTimeChoice!.reloadAllComponents()

            }
            )
        }
    }
}

protocol PopupPickerConsumer {
    func saveValue(thePicker: UIPickerView)
    func loadValue()
    func getPickerDelegate() -> BuzzPickerDelegate
    func getUIControl() -> UIControl
    func getTitle() -> String
}

