//
//  UVCExtension.swift
//  Cricky
//
//  Created by Faiaz Rahman on 25/2/23.
//

import Foundation
import UIKit
extension UIViewController {
    func showToast(message: String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: (view.frame.size.width - 200) / 2, y: view.frame.size.height - 200, width: 200, height: 35))
        toastLabel.backgroundColor = #colorLiteral(red: 0.2078386843, green: 0.2078466415, blue: 0.338671118, alpha: 1).withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
