//
//  AppTheme.swift
//  Student
//
//  Created by Walker on 2020/12/21.
//

import UIKit

class AppTheme: NSObject {
    
    // 主题色
    static let tintColor:       UIColor = UIColor(hex: 0xf15955)
    static let lightTintColor:  UIColor = UIColor(r: 239, g: 89, b: 90, a: 0.80)
    // 背景色
    static let backgroundColor: UIColor = UIColor(hex: 0xf8f8f8)
    static let lightBackgroundColor: UIColor = UIColor(hex: 0xfafafa)
    // 蒙版背景色
    static let maskColor:       UIColor = UIColor(white: 0, alpha: 0.60)
    // 分割线颜色
    static let dividerColor:    UIColor = UIColor(white: 0, alpha: 0.15)
    
}

struct Font {
    static let headline: UIFont = UIFont.systemFont(
        ofSize: Dimension.FontSize.headline,
        weight: UIFont.Weight.regular
    )
    
    static let boldTitle: UIFont = UIFont.systemFont(
        ofSize: Dimension.FontSize.title,
        weight: UIFont.Weight.medium
    )
    
    static let title: UIFont = UIFont.systemFont(
        ofSize: Dimension.FontSize.title,
        weight: UIFont.Weight.regular
    )
    
    static let subtitle: UIFont = UIFont.systemFont(
        ofSize: Dimension.FontSize.subtitle
    )
    
    static let content: UIFont = UIFont.systemFont(
        ofSize: Dimension.FontSize.content
    )
    
    static let description: UIFont = UIFont.systemFont(
        ofSize: Dimension.FontSize.description
    )
}

struct GrayColor {
    // 一级内容，标题、按钮、评论内容等
    static let title:        UIColor = UIColor(white: 0, alpha: 0.90)
    // 辅助内容
    static let subtitle:     UIColor = UIColor(white: 0, alpha: 0.50)
    // 说明内容
    static let content:      UIColor = UIColor(white: 0, alpha: 0.30)
}

struct Dimension {
    struct Margin {
        static let small:       CGFloat = 4.00
        static let regular:     CGFloat = 8.00
        static let large:       CGFloat = 16.00
    }
    
    struct BorderWidth {
        static let small:       CGFloat = 0.20
        static let regular:     CGFloat = 0.40
        static let bold:        CGFloat = 0.60
    }
    
    struct FontSize {
        static let headline:    CGFloat = 22.00
        static let title:       CGFloat = 17.00
        static let subtitle:    CGFloat = 15.00
        static let content:     CGFloat = 14.00
        static let description: CGFloat = 13.00
    }
    
    struct LabelHeight {
        static let regular:     CGFloat = 32.00
        static let small:       CGFloat = 21.00
        static let large:       CGFloat = 44.00
    }
    
    struct ButtonHeight {
        static let small:       CGFloat = 40.00
        static let regular:     CGFloat = 52.00
        static let large:       CGFloat = 64.00
    }
    
    struct TBRowHeight {
        static let regular:     CGFloat = 48.00
        static let medium:      CGFloat = 56.00
        static let large:       CGFloat = 64.00
        static let veryLarge:   CGFloat = 80.00
    }
    
    struct BorderRadius {
        static let large:       CGFloat = 16.00
        static let regular:     CGFloat = 8.00
        static let small:       CGFloat = 4.00
    }
    
    struct IconSize {
        static let regular:     CGSize  = CGSize(width: 28.00, height: 28.00)
        static let large :      CGSize  = CGSize(width: 48.00, height:  48.00)
        static let small :      CGSize  = CGSize(width: 18.00, height: 18.00)
    }
}

struct Interval {
    struct Animation {
        static let short:       TimeInterval = 0.20
        static let regular:     TimeInterval = 0.40
        static let long:        TimeInterval = 0.60
    }
}

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }
  
    convenience init(hex: Int) {
        self.init(r: (hex & 0xff0000) >> 16, g: (hex & 0xff00) >> 8, b: (hex & 0xff), a: 1)
    }
}
