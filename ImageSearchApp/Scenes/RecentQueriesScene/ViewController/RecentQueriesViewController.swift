//
//  RecentQueriesViewController.swift
//  ImageSearchApp
//
//  Created by Rodion Artyukhin on 15.12.2022.
//

import UIKit

protocol RecentQueriesDisplayLogic: AnyObject {
    func displayAddedQuery(_ viewModel: RecentQueriesModel.AddQuery.ViewModel)
    func displaySelectedQuery(_ viewModel: RecentQueriesModel.SelectQuery.ViewModel)
}

final class RecentQueriesViewController: UIViewController {
    
    // MARK: - Properties
    var interactor: (RecentQueriesBusinessLogic & RecentQueriesDataStore)?
    
    // MARK: - Views
    private lazy var queriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .white
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = interactor?.dataSource
        tableView.register(
            RecentQueryCell.self,
            forCellReuseIdentifier: String(describing: RecentQueryCell.self)
        )
        return tableView
    }()
    private weak var searchBar: UISearchBar? {
        let searchViewController = presentingViewController as? SearchViewController
        let searchController = searchViewController?.navigationItem.searchController
        return searchController?.searchBar
    }
    
    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        view.addSubview(queriesTableView)
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        queriesTableView.frame = view.frame
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let query = searchBar?.text ?? ""
        interactor?.addQuery(.init(query: query))
    }
}

// MARK: - RecentQueriesDisplayLogic
extension RecentQueriesViewController: RecentQueriesDisplayLogic {
    func displayAddedQuery(_ viewModel: RecentQueriesModel.AddQuery.ViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.queriesTableView.reloadData()
        }
    }
    
    func displaySelectedQuery(_ viewModel: RecentQueriesModel.SelectQuery.ViewModel) {
        guard let searchBar = searchBar else { return }
        searchBar.text = viewModel.query
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
    }
}

// MARK: - UITableViewDelegate
extension RecentQueriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.selectQuery(.init(index: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
