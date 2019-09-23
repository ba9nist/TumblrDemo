//
//  UIViewController+Alert.swift
//
//  Created by yevhenii boryspolets on 9/17/18.
//  Copyright © 2018 Home. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert message's button title"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showError(error: Error?, handler: ((UIAlertAction) -> Void)? = nil) {
        guard let error = error else {
            return
        }

        DispatchQueue.main.async {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error message title"), message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Error Alert message's button title"), style: .cancel, handler: handler))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    func showAlertWithTextField(title: String?, message: String?, textFields: [UITextField], successHandler: (([String]) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for field in textFields {
            alertController.addTextField { (textField) in
                textField.keyboardType = field.keyboardType
                textField.placeholder = field.placeholder
            }
        }
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: "AlertView button"), style: .default, handler: { (_) in
            var result = [String]()
            if let textFields = alertController.textFields {
                for tf in textFields {
                    result.append(tf.text ?? "")
                }
            }
            
            successHandler?(result)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "AlertView button"), style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAWSError(error: Error?, handler: ((UIAlertAction) -> Void)? = nil) {
        if let errorDict = ((error as NSError?)?.userInfo["HTTPBody"] as? NSDictionary)?["error"] as? NSDictionary {
            
            let errorMessage = errorDict["message"] as? String ?? ""
            
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error message title"), message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Error Alert message's button title"), style: .cancel, handler: handler))
            self.present(alert, animated: true, completion: nil)
        } else {
            showError(error: error)
        }
    }
}
