//
//  TerminologyDetailViewController.swift
//  Anatomy Lab
//
//  Created by Hector Cen on 9/16/16.
//  Copyright © 2016 Hector Cen. All rights reserved.
//

import UIKit

class TerminologyDetailViewController: UIViewController {

    @IBOutlet weak var terminologyTableView: UITableView!
    @IBOutlet weak var termImageView: UIImageView!
    var searchController: UISearchController?
    
    var terminologyTableViewDelegateDatasource: LabTerminologyDelegateDatasource?
    var terminologyMenuTabViewModel: TerminologyTabMenuViewModel?
    var generalTerminologyViewModel: GeneralTerminologyViewModel?
    var searchControllerDelegate: SearchControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewModel()
        setupTerminologyTableView()
        setupViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: IBActions
extension TerminologyDetailViewController {
    
}

//MARK: View Model Configuration
extension TerminologyDetailViewController {
    
    func configure(withViewModel viewModel: GeneralTerminologyViewModel) {
        terminologyTableViewDelegateDatasource?.terms = viewModel.allTerms()
    }
    
    func configureMenu(inMenuViewController menuViewController: GeneralMenuViewController, withViewModel viewModel: TerminologyTabMenuViewModel?) {
        
        guard let validViewModel = viewModel else {
            return
        }
        menuViewController.configure(withViewModel: validViewModel)
    }
    
    func configuredTerminologyTabMenuViewModel(fromViewController viewController: GeneralMenuViewController) ->TerminologyTabMenuViewModel {
        
        let _terminologyTabMenuViewModel = TerminologyTabMenuViewModel(fromViewController: viewController)
        
        _terminologyTabMenuViewModel.stationCellDeselectionHandler = { tableView, lab, indexPath in
            _terminologyTabMenuViewModel.selectedStations[lab][indexPath.row] = 0
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
        }
        
        _terminologyTabMenuViewModel.stationSelectionChanged = { [weak self] stations in
            
            if let validTerms = self?.generalTerminologyViewModel?.terms(forStations: stations) {
                self?.termImageView.image = nil
                self?.terminologyTableViewDelegateDatasource?.terms = validTerms
                self?.terminologyTableView.reloadData()
            }
        }
        
        return _terminologyTabMenuViewModel
    }
    
}

//MARK: Private API
extension TerminologyDetailViewController {
    
    func setupViewModel() {
        generalTerminologyViewModel = GeneralTerminologyViewModel()
    }
    
    func setupViews() {
        
        if let parentVC = parentViewController?.parentViewController as? GeneralSplitViewController {
            let menuButton = UIBarButtonItem(title: String.localizedStringWithFormat("Labs"),
                                             style: .Done,
                                             target: parentVC.displayModeButtonItem().target,
                                             action: parentVC.displayModeButtonItem().action)
            
            navigationItem.leftBarButtonItem = menuButton

            if let menuNavViewController = parentVC.childViewControllers[0] as? UINavigationController,
                let menuViewController = menuNavViewController.childViewControllers.first as? GeneralMenuViewController {
                
                terminologyMenuTabViewModel = configuredTerminologyTabMenuViewModel(fromViewController: menuViewController)
                configureMenu(inMenuViewController: menuViewController, withViewModel: terminologyMenuTabViewModel)
            }
        }
        
        if let validViewModel = generalTerminologyViewModel {
            configure(withViewModel: validViewModel)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
                
    }
    
    func setupTerminologyTableView() {
        
        terminologyTableViewDelegateDatasource = LabTerminologyDelegateDatasource()
        
        terminologyTableViewDelegateDatasource?.cellSelectionHandler = { [weak self] term in
            self?.termImageView.image = UIImage(named: term.first?.1["image"].stringValue ?? "")
        }
        
        terminologyTableView.scrollEnabled = true
        terminologyTableView.delegate = terminologyTableViewDelegateDatasource
        terminologyTableView.dataSource = terminologyTableViewDelegateDatasource
    }
    
    func setupSearchController() {
        
        searchControllerDelegate = SearchControllerDelegate()
        
        searchControllerDelegate?.searchControllerTextHandler = { [weak self] searchText in
            self?.filterTermsForSearchText(searchText)
        }
        
        searchControllerDelegate?.searchBarCancelButtonTapped = { [weak self] in
            
            guard let validViewModel = self?.generalTerminologyViewModel else {
                return
            }
            
            self?.terminologyTableViewDelegateDatasource?.terms = validViewModel.terms
            self?.terminologyTableView.reloadData()
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.autocapitalizationType = .None
        searchController?.searchBar.autocorrectionType = .No
        searchController?.searchBar.keyboardType = .NamePhonePad
        searchController?.searchBar.delegate = searchControllerDelegate
        
        searchController?.searchResultsUpdater = searchControllerDelegate
        searchController?.dimsBackgroundDuringPresentation = false
        terminologyTableView.tableHeaderView = searchController?.searchBar
    }
    
    func filterTermsForSearchText(searchText: String? = "", scope: String = "All") {
        
        guard let validViewModel = generalTerminologyViewModel,
            let validSearchText = searchText where !validSearchText.isEmpty else {
            return
        }
        terminologyTableViewDelegateDatasource?.terms = validViewModel.terms(validSearchText)
        terminologyTableView.reloadData()
    }
    
}