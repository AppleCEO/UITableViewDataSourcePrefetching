//
//  ViewController.swift
//  UITableViewDataSourcePrefetching
//
//  Created by 도미닉 on 1/16/26.
//

import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private var dataArray = [String](repeating: "false", count: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    private func prefetchCellData(_ indexPath: IndexPath) {
        dataArray[indexPath.row] = "\(indexPath.row)"
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                self.tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .fade)
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if dataArray[indexPath.row] != "false" {
            cell.textLabel?.text = dataArray[indexPath.row]
            print("cellForRowAt \(indexPath.row)")
        } else {
            self.prefetchCellData(indexPath)
        }
        
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print("prefetchRowsAt \(indexPath.row)")
            self.prefetchCellData(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print("cancelPrefetchingForRowsAt \(indexPath.row)")
            dataArray[indexPath.row] = "false"
        }
    }
}
