//
//  ViewController.swift
//  Student_CoreData
//
//  Created by Md Murad Hossain on 13/12/22.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var textMobile: UITextField!
    @IBOutlet weak var myView: UIView!
    
    var i = Int()
    var isUpdateData = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPlusButtonAnimationConfiguration()
    }
    
    private func viewPlusButtonAnimationConfiguration() {
        myView.pulsate()
        myView.layer.cornerRadius = 28.9
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        sender.showAnimation { [self] in
            
            // Create Alert Action
            let alerAction = UIAlertController(title: "Confirm", message: "Are you sure to save this information data?", preferredStyle: .alert)
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
                
                let dict = ["name" : textName.text, "address" : textAddress.text, "city" : textCity.text, "mobile" : textMobile.text]
                if isUpdateData {
                    DatabaseHelper.shareInstance.editData(object: dict as! [String:String], i: i)
                }else{
                    DatabaseHelper.shareInstance.save(object: dict as! [String:String])
                }
                
                //print("Ok button tapped")
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                //print("Cancel button tapped")
            }
            //Add OK and Cancel button to an Alert object
            alerAction.addAction(ok)
            alerAction.addAction(cancel)
            // Present alert message to user
            self.present(alerAction, animated: true, completion: nil)
           
        }
    }
    
    @IBAction func showSaveDataButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "listViewController") as! listViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: Save coreData passing

extension ViewController: DataPass {
    
    func data(object: [String : String], index: Int, isEdit: Bool) {
        textName.text = object["name"]
        textAddress.text = object["address"]
        textCity.text = object["city"]
        textMobile.text = object["mobile"]
        i = index
        isUpdateData = isEdit

    }
    
}

// MARK: Save Button tap animation

public extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
        
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.90, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}

// MARK: Show button Animation -

extension UIView {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1
        pulse.fromValue = 0.90
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 10000000000
        pulse.initialVelocity = 0.98
        pulse.damping = 1000000
        layer.add(pulse, forKey: "pulse")
    }
}


