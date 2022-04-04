//
//  NavigationExtension.swift
//  WeatherTestPoj
//
//  Created by George on 04.04.2022.
//

import Foundation
import UIKit

extension UINavigationController {
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
            popViewController(animated: animated)

            if animated, let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: nil) { _ in
                    completion()
                }
            } else {
                completion()
            }
        }
    func hideHairline() {
           if let hairline = findHairlineImageViewUnder(navigationBar) {
               hairline.isHidden = true
           }
       }
    func restoreHairline() {
            if let hairline = findHairlineImageViewUnder(navigationBar) {
                hairline.isHidden = false
            }
        }
        func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
            if view is UIImageView && view.bounds.size.height <= 1.0 {
                return view as? UIImageView
            }
            for subview in view.subviews {
                if let imageView = self.findHairlineImageViewUnder(subview) {
                    return imageView
                }
            }
            return nil
        }
}
