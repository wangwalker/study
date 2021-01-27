//
//  StudentSelectionRow.swift
//  Student
//
//  Created by Walker on 2020/12/22.
//

import UIKit

class StudentFilterRow: UIView {
    
    private let icon = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let switcher = UISwitch(frame: .zero)
    private let bottomBorder = UIView(frame: .zero)
    private let accessory = UIImageView(image: UIImage(named: "arrow-right"))

    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorder.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.Margin.large)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(Dimension.BorderWidth.regular)
        }
    }
    
    // Configure view with model
    func config(item: StudentFilterItem) {
        
        titleLabel.text = item.title
        
        switch item.style {
        case .compact:
            layoutCompact()
            titleLabel.textColor = GrayColor.subtitle
            switcher.isHidden = false
            accessory.isHidden = true
            break
        default:
            icon.image = UIImage(named: item.iconName)
            layoutNormal()
            break
        }
        
    }
    
    // Hide or shown bottom border
    func hideBorder(_ hidden: Bool) {
        bottomBorder.isHidden = hidden
    }
    
    private func setupUI() {
        
        backgroundColor = AppTheme.backgroundColor
        
        addSubview(icon)
        addSubview(titleLabel)
        addSubview(accessory)
        addSubview(switcher)
        addSubview(bottomBorder)
        
        titleLabel.font = Font.title
        titleLabel.textColor = GrayColor.title
        switcher.isHidden = true
        bottomBorder.backgroundColor = AppTheme.dividerColor

    }
    
    private func layoutNormal() {
        let titleCount = CGFloat(titleLabel.text?.count ?? 10)
        let titleWidth = titleCount * Dimension.FontSize.headline
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self).offset(Dimension.Margin.large)
            make.size.equalTo(Dimension.IconSize.regular)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(Dimension.Margin.large)
            make.width.equalTo(titleWidth)
        }
        accessory.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Dimension.Margin.large)
            make.size.equalTo(Dimension.IconSize.small)
        }
    }
    
    private func layoutCompact() {
        let titleCount = CGFloat(titleLabel.text?.count ?? 10)
        let titleWidth = titleCount * Dimension.FontSize.headline
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.Margin.large)
            make.width.equalTo(titleWidth)
        }
        switcher.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Dimension.Margin.large)
        }
    }
}

