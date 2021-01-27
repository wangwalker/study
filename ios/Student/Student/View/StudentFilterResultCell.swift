//
//  StudentFilterResultCell.swift
//  Student
//
//  Created by Walker on 2020/12/24.
//

import UIKit

class StudentFilterResultCell: UITableViewCell {
    static let headerHeight: CGFloat = 48.00
    static let footerHeight: CGFloat = 60.00
    static let identifier = "filter-result-cell"
    
    private let avatar = UIImageView(frame: .zero)
    private let header = StudentFilterResultHeader(frame: .zero)
    private let footer = StudentFilterResultFooter(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.Margin.regular)
            make.left.right.equalToSuperview()
            make.height.equalTo(StudentFilterResultCell.headerHeight)
        }
        avatar.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(Dimension.IconSize.large)
        }
        footer.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-Dimension.Margin.regular)
            make.left.right.equalToSuperview()
            make.height.equalTo(StudentFilterResultCell.footerHeight)
        }
        
        clip(offset: Dimension.Margin.regular, radius: Dimension.BorderRadius.regular)
    }
    
    private func setupUI() {
        selectionStyle = .none
        addSubview(avatar)
        addSubview(header)
        addSubview(footer)
        avatar.image = UIImage(named: "icon_circle")
    }
    
}

private class StudentFilterResultHeader: UIView {
    private let icon = UIImageView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let locationLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.Margin.regular)
            make.size.equalTo(Dimension.IconSize.regular)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(Dimension.Margin.small)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Dimension.Margin.large)
            make.height.equalTo(Dimension.LabelHeight.regular)
        }
    }
    
    private func setupUI() {        
        addSubview(icon)
        addSubview(nameLabel)
        addSubview(locationLabel)
        
        icon.image = UIImage(named: "icon_drag_bar")
        nameLabel.font = Font.title
        nameLabel.textColor = GrayColor.subtitle
        nameLabel.text = "14343-哈哈哈-无"
        locationLabel.font = Font.content
        locationLabel.textColor = AppTheme.tintColor
        locationLabel.text = " 陕西省西咸新区 "
//        locationLabel.set(text: "陕西省西咸新区", leftIcon: UIImage(named: "icon_circle"))
        locationLabel.addBorder(color: .white, radius: Dimension.BorderRadius.regular)
    }
}

private class StudentFilterResultFooter: UIView {
    private let originLabel = UILabel(frame: .zero)
    private let parentLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        parentLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Dimension.Margin.large)
            make.height.equalTo(Dimension.LabelHeight.large)
        }
        originLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-Dimension.Margin.large)
            make.height.equalTo(Dimension.LabelHeight.regular)
        }
    }
    
    private func setupUI() {
        addSubview(originLabel)
        addSubview(parentLabel)
        
        parentLabel.font = Font.subtitle
        parentLabel.textColor = GrayColor.subtitle
        parentLabel.numberOfLines = 2
        parentLabel.text = """
            家长: 越费力(134****8932)-公众号
            跟进: 2020-12-22 08:12:12 (王子欣)
            """
        originLabel.font = Font.subtitle
        originLabel.textColor = .white
        originLabel.backgroundColor = AppTheme.lightTintColor
        originLabel.text = " 西安中加 "
        originLabel.addBorder(color: .white, radius: Dimension.BorderRadius.regular)
    }
}

extension UIView {
    func addBorder(color: UIColor, radius: CGFloat) {
        layer.borderWidth = Dimension.BorderWidth.bold
        layer.cornerRadius = radius
        layer.borderColor = color.cgColor
        clipsToBounds = true
    }
}

extension UILabel {

    func set(text: String, leftIcon: UIImage? = nil) {
        set(text: text, leftIcon: leftIcon, rightIcon: nil, size: Dimension.IconSize.small)
    }
    
    func set(text: String, rightIcon: UIImage? = nil) {
        set(text: text, leftIcon: nil, rightIcon: rightIcon, size: Dimension.IconSize.small)
    }
    
    func set(text:String, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil, size: CGSize) {

        let leftAttachment = NSTextAttachment()
        leftAttachment.image = leftIcon
        leftAttachment.bounds = CGRect(x: 0, y: -2.5, width: size.width, height: size.height)
        if let leftIcon = leftIcon {
            leftAttachment.bounds = CGRect(x: 0, y: -2.5, width: leftIcon.size.width, height: leftIcon.size.height)
        }
        let leftAttachmentStr = NSAttributedString(attachment: leftAttachment)

        let myString = NSMutableAttributedString(string: "")

        let rightAttachment = NSTextAttachment()
        rightAttachment.image = rightIcon
        rightAttachment.bounds = CGRect(x: 0, y: -5, width: size.width, height: size.height)
        let rightAttachmentStr = NSAttributedString(attachment: rightAttachment)


        if semanticContentAttribute == .forceRightToLeft {
            if rightIcon != nil {
                myString.append(rightAttachmentStr)
                myString.append(NSAttributedString(string: " "))
            }
            myString.append(NSAttributedString(string: text))
            if leftIcon != nil {
                myString.append(NSAttributedString(string: " "))
                myString.append(leftAttachmentStr)
            }
        } else {
            if leftIcon != nil {
                myString.append(leftAttachmentStr)
                myString.append(NSAttributedString(string: " "))
            }
            myString.append(NSAttributedString(string: text))
            if rightIcon != nil {
                myString.append(NSAttributedString(string: " "))
                myString.append(rightAttachmentStr)
            }
        }
        attributedText = myString
    }
}
