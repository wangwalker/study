//
//  BaseViewController.swift
//  Student
//
//  Created by Walker on 2020/12/21.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    public var statusBarHeight: CGFloat {
        get {
            var statusBarHeight: CGFloat = 20
            if #available(iOS 13.0, *) {
                statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            return statusBarHeight
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppTheme.backgroundColor
        
        customAppearance()
    }
    
    private func customAppearance() {
        UINavigationBar.appearance().barTintColor = GrayColor.subtitle
        UIView.appearance().tintColor = GrayColor.subtitle
        UISwitch.appearance().onTintColor = AppTheme.tintColor
        
        let naviBar = navigationController?.navigationBar
        if #available(iOS 13.0, *) {
            let appearance = navigationController?.navigationBar.standardAppearance
            appearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppTheme.tintColor]
        } else {
            naviBar?.barTintColor = AppTheme.tintColor
            naviBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppTheme.tintColor]
        }
        naviBar?.tintColor = GrayColor.subtitle
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
