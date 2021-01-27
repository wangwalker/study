//
//  ArchiveViewController.swift
//  Student
//
//  Created by Walker on 2020/12/22.
//

import UIKit

// 招生档案
class ArchiveViewController: BaseViewController {

    private let school = StudentFilterDataManager.school
    private let staff = StudentFilterDataManager.staff
    
    private let schoolRow = StudentFilterRow(frame: .zero)
    private let staffRow = StudentFilterRow(frame: .zero)
    private let searchBar = UISearchBar(frame: .zero)
    private let resultView = StudentFilterResultView(frame: .zero)
    private let filterPanel = MaskedStudentFilterPanel(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBarButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        schoolRow.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(Dimension.TBRowHeight.regular)
        }
        staffRow.snp.makeConstraints { (make) in
            make.top.equalTo(schoolRow.snp.bottom)
            make.left.right.height.equalTo(schoolRow)
        }
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(staffRow.snp.bottom)
            make.left.right.equalTo(schoolRow)
            make.height.equalTo(Dimension.TBRowHeight.medium)
        }
        resultView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        filterPanel.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
    }

    // MARK: - Private
    
    private func setupUI() {        
        view.addSubview(schoolRow)
        view.addSubview(staffRow)
        view.addSubview(searchBar)
        view.addSubview(resultView)
        view.addSubview(filterPanel)
        
        schoolRow.config(item: school)
        staffRow.config(item: staff)
        staffRow.hideBorder(true)
        
        searchBar.placeholder = "学生名字/拼音/档案号"
        searchBar.barTintColor = AppTheme.backgroundColor
        searchBar.searchTextField.backgroundColor = .white
        searchBar.delegate = self
    }

    private func setupBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "筛选", style: .plain, target: self, action: #selector(togglePanel))
    }
    
    @objc private func togglePanel() {
        filterPanel.toggle()
    }
}

extension ArchiveViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchBar.showsCancelButton {
            searchBar.setShowsCancelButton(true, animated: true)
        }
    }
}
