//
//  TabCoordinator.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit

/// A `TabCoordinator` is a `Coordinator` for tabs of a UITabBarController
protocol TabCoordinator: Coordinator {
    /// - note: Serves as the root view controller of the tab
    var navigationController: UINavigationController { get }
    var tabBarItem: UITabBarItem { get }
}
