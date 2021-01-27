//
//  StudentFilterCell.swift
//  Student
//
//  Created by Walker on 2020/12/23.
//

import UIKit

class StudentFilterCell: UITableViewCell {
    static let identifier = "student-filter-cell"
    
    var row = StudentFilterRow(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(row)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        row.frame = self.bounds
    }
    
    func config(item: StudentFilterItem) {
        row.config(item: item)
    }
    
}
