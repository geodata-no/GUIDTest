//
//  GDUIKit.swift
//  GUIDTest
//
//  Created by Runar Svendsen on 12/06/2017.
//  Copyright © 2017 Geodata AS. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func promptUser(_ prompt: String, _ options: [String], _ cancel: String?, completion: @escaping (Int) -> ()) {
        let alertController = UIAlertController(title: "Prompt", message: prompt, preferredStyle: .actionSheet)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction(title: option, style: .default, handler: { _ in completion(index) }))
        }
        if let cancelPrompt = cancel {
            alertController.addAction(UIAlertAction(title: cancelPrompt, style: .cancel))
        }
        present(alertController, animated: true, completion: nil)
    }
}

