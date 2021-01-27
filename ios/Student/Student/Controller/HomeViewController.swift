//
//  ViewController.swift
//  Student
//
//  Created by Walker on 2020/12/18.
//

import UIKit

class HomeViewController: BaseViewController, UICollectionViewDelegate {
    let sudoku: HomeSudokuView = HomeSudokuView(frame: .zero)
    
    // MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sudoku.snp.makeConstraints { (make) in
            let cellWidth = (view.bounds.width-2*Dimension.Margin.regular)/3
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Dimension.Margin.small)
            make.left.width.equalTo(view)
            make.height.equalTo(2*(cellWidth+Dimension.Margin.regular))
        }
    }
    
    // MARK: - Private methods

    func setupUI() {
        title = "学生档案"
        view.addSubview(sudoku)
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectSudokuItem(_:)), name: Notification.SudokuItemDidSelect, object: nil)
    }
    
    @objc func selectSudokuItem(_ sender: Notification) {
        guard let index = sender.userInfo?["index"] as? Int else {
          fatalError()
        }
        
        var item = SudokuDataManager.items[index]
        navigationController?.pushViewController(item.viewController, animated: true)
    }
}

