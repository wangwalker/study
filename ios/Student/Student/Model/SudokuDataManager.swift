//
//  HomeSudokuDataManager.swift
//  Student
//
//  Created by Walker on 2020/12/18.
//

import UIKit

public class SudokuDataManager: NSObject {
    static let items: [HomeSudokuItem] = [
        HomeSudokuItem(title: "所有档案", imageName: ""),
        HomeSudokuItem(title: "在线报名", imageName: ""),
        HomeSudokuItem(title: "预约提醒", imageName: ""),
        HomeSudokuItem(title: "职工动态", imageName: ""),
        HomeSudokuItem(title: "档案跟进", imageName: ""),
        HomeSudokuItem(title: "数据汇总", imageName: ""),
    ]
    
}

struct HomeSudokuItem {
    var title: String
    var imageName: String
    
    // Related view controller
    lazy var viewController: UIViewController = {
        var vc = BaseViewController()
        
        if title == "所有档案" {
            vc = ArchiveViewController()
        } else if title == "在线报名" {
            
        }
        
        vc.title = title
        return vc
    }()
}

extension Notification {
    static let SudokuItemDidSelect = Notification.Name("HomeSudokuItemSelected")
}
