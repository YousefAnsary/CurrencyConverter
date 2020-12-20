//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Yousef on 12/20/20.
//

import UIKit
import IPicker
import RxSwift

class HomeViewController: BaseViewController {

    //MARK: - Variables& IBOutlets
    @IBOutlet private weak var baseCurrencySelectorView: UIView!
    @IBOutlet private weak var baseCurrencyLbl: UILabel!
    @IBOutlet private weak var currenciesTableView: UITableView!
    
    var showCalculationPopup: ((_ baseCurrency: Currency, _ selectedCurrency: Currency)-> ())?
    var viewModel: HomeViewModel!
    private lazy var refreshControl = UIRefreshControl()
    private lazy var baseCurrencyPicker = IDataPicker()
    private lazy var disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
        
        configureViewModel(viewModel: viewModel)
        viewModel.fetchAllCurrencies()
        
    }

    //MARK: - Actions Handlers
    @objc private func baseCurrencySelectorViewDidTapped(_ sender: UIGestureRecognizer) {
        baseCurrencyPicker.setData(data: viewModel.currenciesStrings)
        baseCurrencyPicker.pickerBackgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.1960784314, alpha: 0.9507705479)
        baseCurrencyPicker.fontColor = .white
        baseCurrencyPicker.onDoneBtnTapped { [weak self] index in
            guard let self = self else {return}
            let selectedItem = self.viewModel.currencies.value[index]
            self.viewModel.baseCurrency.accept(selectedItem)
            self.baseCurrencyLbl.text = selectedItem.code
        }
        baseCurrencyPicker.show(inView: self.view)
    }
    
    //MARK: - Private Methods
    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(baseCurrencySelectorViewDidTapped))
        baseCurrencySelectorView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupTableView() {
        let cellId = "CurrencyTableCell"
        currenciesTableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        currenciesTableView.addSubview(refreshControl)
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] in
            guard let self = self, let code = self.viewModel.baseCurrency.value?.code else {return}
            self.viewModel.fetchCurrencies(base: code)
        }).disposed(by: disposeBag)
        viewModel.isLoadingObservable.bind(to: refreshControl.rx.isRefreshing).disposed(by: disposeBag)
        
        viewModel.currencies.bind(to: currenciesTableView.rx.items(cellIdentifier: cellId, cellType: CurrencyTableCell.self)) {
            row, element, cell in
            cell.currency = element
        }.disposed(by: disposeBag)
        
        currenciesTableView.rx.itemSelected.subscribe(onNext: { [weak self] index in
            guard let self = self else {return}
            self.showCalculationPopup?(self.viewModel.baseCurrency.value!, self.viewModel.currencies.value[index.row])
        }).disposed(by: disposeBag)
    }
    
}

