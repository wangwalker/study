//
//  StudentFilterPanel.swift
//  Student
//
//  Created by Walker on 2020/12/23.
//

import UIKit

class StudentFilterPanel: UIView {
    private let items = StudentFilterDataManager.panelItems
    private let cells = StudentFilterDataManager.panelItems.map { _ in StudentFilterCell(style: .default, reuseIdentifier: StudentFilterCell.identifier)
    }
    private lazy var filterButton: UIButton = {
        let btn = UIButton(type: .roundedRect)
        btn.setTitle(" 开始筛选 ", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.lightText, for: .highlighted)
        btn.titleLabel?.font = Font.boldTitle
        btn.backgroundColor = AppTheme.tintColor
        btn.layer.cornerRadius = Dimension.BorderRadius.regular
        btn.addTarget(self, action: #selector(startFilter), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.backgroundColor = .white
        tb.separatorStyle = .none
        tb.rowHeight = Dimension.TBRowHeight.regular
        tb.estimatedRowHeight = Dimension.TBRowHeight.regular
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(tableView)
        addSubview(filterButton)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(filterButton.snp.top).offset(-Dimension.Margin.large)
        }
        filterButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Dimension.Margin.large*3)
            make.height.equalTo(Dimension.ButtonHeight.small)
        }
    }
    
    @objc private func startFilter() {
        print("start filter students...")
    }
}

extension StudentFilterPanel: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cells[indexPath.row]
        cell.config(item: items[indexPath.row])
        
        return cell
    }
}

extension StudentFilterPanel: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = items[indexPath.row];
        item.switchOn = !item.switchOn
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// A masked container view holds `StudentFilterPanel`
class MaskedStudentFilterPanel: UIView {
    private let multiplier: CGFloat = 0.48
    private let panel = StudentFilterPanel(frame: .zero)
    private var panelHidden = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(panel)
        // It is hidden initially, after user taps bar button at navigation item, showing it with animated way
        isHidden = true
        backgroundColor = AppTheme.maskColor
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        panel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.snp.right)
            make.width.equalToSuperview().multipliedBy(multiplier)
        }
    }
    
    public func toggle() {
        UIView.animateKeyframes(withDuration: Interval.Animation.short, delay: 0, options: .calculationModePaced) {
            self.isHidden = !self.isHidden
        } completion: { (cmp) in
            self.togglePanel()
        }
    }
    
    // Show or hide panel
    private func togglePanel() {
        let panelWidth = bounds.width * multiplier
        let transform = CGAffineTransform(translationX: panelHidden ? -panelWidth : panelWidth, y: 0)
        
        UIView.animateKeyframes(withDuration: Interval.Animation.regular, delay: 0, options: .calculationModeCubic) {
            self.panel.transform = transform
        } completion: { (completion) in
            self.panelHidden = !self.panelHidden
        }
    }

}
