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
}
