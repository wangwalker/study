//
//  HomeSudokuView.swift
//  Student
//
//  Created by Walker on 2020/12/18.
//

import UIKit

public class HomeSudokuView: UIView {

    lazy var layout: UICollectionViewFlowLayout = {
        let offset = Dimension.Margin.regular
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.sectionInset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
        return flowlayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(HomeSudokuCollectionViewCell.self, forCellWithReuseIdentifier:HomeSudokuCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellWidth = (bounds.width-2*Dimension.Margin.regular)/3
        collectionView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: 2*(cellWidth+Dimension.Margin.regular)))
        
        // 剪裁外边框
        clip(offset: Dimension.Margin.regular+1, radius: Dimension.BorderRadius.regular)
    }
}

extension HomeSudokuView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SudokuDataManager.items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeSudokuCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSudokuCollectionViewCell.identifier, for: indexPath) as! HomeSudokuCollectionViewCell
        cell.config(item: SudokuDataManager.items[indexPath.row])
        return cell
    }
}

extension HomeSudokuView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (bounds.width-2*Dimension.Margin.regular)/3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.SudokuItemDidSelect, object: self, userInfo: ["index": indexPath.row])
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

public class HomeSudokuCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "sudoku-cell-identifier"
    
    let icon: UIImageView = UIImageView(image: UIImage(named: "icon_circle"))
    let titleLabel: UILabel = UILabel(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-Dimension.IconSize.small.height)
            make.size.equalTo(Dimension.IconSize.regular)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Dimension.LabelHeight.small)
        }
    }
    
    func config(item: HomeSudokuItem) {
        titleLabel.text = item.title
        if !item.imageName.isEmpty {
            icon.image = UIImage(named: item.imageName)
        }
    }
    
    private func setupUI() {
        addSubview(icon)
        addSubview(titleLabel)
        backgroundColor = .white
        layer.borderWidth = Dimension.BorderWidth.regular
        layer.borderColor = AppTheme.dividerColor.cgColor
        
        titleLabel.font = Font.subtitle
        titleLabel.textColor = GrayColor.title
        titleLabel.textAlignment = .center
    }
}

extension UIView {
    // clip outside border with its frame by offset, positive offset means toward inside, radius means clip to round-corner rect
    // 使用蒙版剪裁视图边角，offset表示剪裁的宽度，radius为圆角半径
    func clip(offset: CGFloat, radius: CGFloat) {
        let clipPath = UIBezierPath(roundedRect: CGRect(x: offset, y: offset, width: bounds.width-2*offset, height: bounds.height-2*offset), cornerRadius: radius)
        let mask = CAShapeLayer()
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        mask.path = clipPath.cgPath
        self.layer.mask = mask
    }
    
    func clip(at origin: CGPoint, size: CGSize, radius: CGFloat) {
        let clipPath = UIBezierPath(roundedRect: CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height), cornerRadius: radius)
        let mask = CAShapeLayer()
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        mask.path = clipPath.cgPath
        layer.mask = mask
    }
}
