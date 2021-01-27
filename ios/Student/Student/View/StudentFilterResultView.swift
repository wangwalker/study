//
//  StudentFilterResultView.swift
//  Student
//
//  Created by Walker on 2020/12/24.
//

import UIKit

class StudentFilterResultView: UIView {
    let rowHeight: CGFloat = 220.00
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.separatorStyle = .none
        tb.backgroundColor = AppTheme.backgroundColor
        tb.rowHeight = rowHeight
        tb.estimatedRowHeight = rowHeight
        tb.dataSource = self
        tb.delegate = self
        return tb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
    }
    
    private func setupUI() {
        addSubview(tableView)
    }
}

extension StudentFilterResultView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StudentFilterResultCell(style: .default, reuseIdentifier: StudentFilterResultCell.identifier)
        
        return cell
    }
}

extension StudentFilterResultView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
