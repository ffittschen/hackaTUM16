//
//  TabCoordinator.swift
//  MachtSpass
//
//  Created by Florian Fittschen on 11/11/2016.
//  Copyright © 2016 BaconLove. All rights reserved.
//

import Foundation
import UIKit

protocol TabCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
    var tabBarItem: UITabBarItem { get }
}
