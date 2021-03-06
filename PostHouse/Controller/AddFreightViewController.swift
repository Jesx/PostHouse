//
//  AddFreightViewController.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/25.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit
import PKHUD

class AddFreightViewController: UIViewController {
    
    @IBOutlet weak var freightImageView: UIImageView!
    @IBOutlet weak var confirmUpload: UIButton!
    
    @IBOutlet weak var freightNameTextField: UITextField!
    @IBOutlet weak var freightDescriptionTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var startLocationTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    
    @IBOutlet weak var outerStackViewTopConstraint: NSLayoutConstraint!
    var outerStackViewTopConstraintConstant: CGFloat = 30.0
    @IBOutlet weak var outerStackView: UIStackView!
    
    @IBOutlet weak var freightNameStackView: UIStackView!
    @IBOutlet weak var freightDescriptionStackView: UIStackView!
    @IBOutlet weak var weightStackView: UIStackView!
    @IBOutlet weak var startLocationStackView: UIStackView!
    @IBOutlet weak var destinationStackView: UIStackView!
    @IBOutlet weak var priceStackView: UIStackView!
    
    var image: UIImage? = nil
    
    var stations = [GetStation.Data]()
    var station = Station.Athens
    
    var activeField: UITextField?
    var locationPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupfreightImage()
        buttonApparance(confirmUpload, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        locationPicker.delegate = self
        locationPicker.dataSource = self
        
        freightNameTextField.delegate = self
        freightDescriptionTextField.delegate = self
        weightTextField.delegate = self
        priceTextField.delegate = self
        
//        startLocationTextField.inputView = locationPicker
        startLocationTextField.isEnabled = false
        startLocationTextField.text = station.rawValue
        destinationTextField.inputView = locationPicker
        
//        startLocationTextField.delegate = self
        destinationTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
        PostHouseData().getStation { (station) in
            self.stations = station.data.filter({$0.name != self.station.rawValue})
            DispatchQueue.main.async {
                self.locationPicker.reloadAllComponents()
            }
        }
        
        // Listen for the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func setupfreightImage() {
        
        // When tapping the image view, the photo library show up
        freightImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alertSheetPresent))
        freightImageView.addGestureRecognizer(tapGesture)
    }
    
    func buttonApparance(_ sender: UIButton, color: CGColor) {
        sender.layer.borderWidth = 2
        sender.layer.borderColor = color
        sender.layer.cornerRadius = 5
        sender.clipsToBounds = true
    }
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func alertSheetPresent() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openPhotoLibraryAction = UIAlertAction(title: "照片庫", style: .default) { (_) in
            self.presentPicker()
        }
        let cancelAction =  UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(openPhotoLibraryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if priceTextField.isFirstResponder {
            if let info = notification.userInfo {
                
                let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
                
                // Find our target Y
                let targetY = view.frame.size.height - rect.height - 20
                
                // Find out where the stackview is relative to the frame
                let textFieldY = outerStackView.frame.origin.y + 20 + priceStackView.frame.origin.y
                
                let difference = targetY - textFieldY
                
                let targetOffsetForTopConstraint = outerStackViewTopConstraint.constant + difference
                
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.outerStackViewTopConstraint.constant = targetOffsetForTopConstraint
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.25, animations: {
                
                self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintConstant
                self.view.layoutIfNeeded()
                
            })
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintConstant
            self.view.layoutIfNeeded()
            
        })
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            
            self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintConstant
            self.view.layoutIfNeeded()
            
        })
    }
    
    @IBAction func didTapToUpload(_ sender: UIButton) {
        
        guard let name = freightNameTextField.text else { return }
        guard let desctoption = freightDescriptionTextField.text else { return }
        guard let weightString = weightTextField.text, let weight = Float(weightString) else { return }
        guard let startStation = startLocationTextField.text else { return }
        guard let desStation = destinationTextField.text else { return }
        guard let priceString = priceTextField.text, let price = Int(priceString) else { return }
        
        if let image = self.image {
            PostHouseData().uploadFreight(name: name, description: desctoption, weight: weight, desStation: desStation, startStation: startStation, price: price) { (response) in
                
                if response.message == "已登錄運送貨品" {
                    PostHouseData().uploadImageWithFormData(goodId: response.data.id, image: image) { (data) in
                        DispatchQueue.main.async {
                            
                            HUD.flash(.labeledSuccess(title: "上傳成功", subtitle: response.message), delay: 1)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.navigationController?.popViewController(animated: true)
                                let vc = self.navigationController?.viewControllers.last as! FreightViewController
                                vc.loadData()
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        HUD.flash(.labeledError(title: "上傳失敗", subtitle: "目前系統有問題，請稍後再傳"), delay: 1)
                    }
                }
            }
        } else {
            HUD.flash(.label("請選擇照片後再上傳"), delay: 1)
        }
        
    }
}

extension AddFreightViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            freightImageView.image = imageSelected
            freightImageView.contentMode = .scaleAspectFill
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            freightImageView.image = imageOriginal
            freightImageView.contentMode = .scaleAspectFill
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension AddFreightViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stations[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeField?.text = stations[row].name
    }
}

extension AddFreightViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case freightNameTextField:
            freightDescriptionTextField.becomeFirstResponder()
        case freightDescriptionTextField:
            weightTextField.becomeFirstResponder()
        case weightTextField:
            priceTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.25, animations: {
                
                self.outerStackViewTopConstraint.constant = self.outerStackViewTopConstraintConstant
                self.view.layoutIfNeeded()
                
            })
        }
        
        return true
    }
}

