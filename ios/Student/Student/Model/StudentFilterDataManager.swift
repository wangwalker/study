//
//  StudentFilterDataManager.swift
//  Student
//
//  Created by Walker on 2020/12/23.
//

import UIKit

class StudentFilterDataManager: NSObject {
    static let school = StudentFilterItem(
        iconName: "icon_circle",
        title: "西安沣东中加学校"
    )
    static let staff = StudentFilterItem(
        iconName: "icon_circle",
        title: "职工选择"
    )
    
    static let follow = StudentFilterItem(
        iconName: "icon_circle",
        title: "跟进时间排序",
        style: .compact
    )
    static let paid = StudentFilterItem(
        iconName: "icon_circle",
        title: "已缴报名费",
        style: .compact
    )
    static let new = StudentFilterItem(
        iconName: "icon_circle",
        title: "新同学",
        style: .compact
    )
    static let online = StudentFilterItem(
        iconName: "icon_circle",
        title: "在线报名",
        style: .compact
    )
    static let schoolbus = StudentFilterItem(
        iconName: "icon_circle",
        title: "乘坐校车",
        style: .compact
    )
    static let residence = StudentFilterItem(
        iconName: "icon_circle",
        title: "住宿学生",
        style: .compact
    )
    static let particular = StudentFilterItem(
        iconName: "icon_circle",
        title: "特殊档案",
        style: .compact
    )
    
    static let panelItems = [follow, paid, new, online, schoolbus, residence, particular]
    
    static subscript(n: Int) -> StudentFilterItem {
        return panelItems[n]
    }
}


struct StudentFilterItem {
    var style: StudentFilterStyle
    var iconName: String
    var title: String
    
    var subtitle = ""
    var switchOn = false
    
    init(iconName: String, title: String, style: StudentFilterStyle) {
        self.iconName = iconName
        self.title = title
        self.style = style
    }
    
    init(iconName: String, title: String) {
        self.init(iconName: iconName, title: title, style: .normal)
    }
}

enum StudentFilterStyle: Int {
    case normal     // An icon, label, and accessory icon
    case compact    // A label, and a switch
}
