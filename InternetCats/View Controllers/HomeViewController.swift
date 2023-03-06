//
//  ViewController.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController, LoadableView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tagTextField: UITextField!
    var viewModel: HomeViewModel!
    var loadingView: LoadingView = UIView.fromNib()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.setupLoadingView()
        self.setupBindings()
        self.loadTagListThenFirstPage()
    }
}

// MARK: - UI Methods
extension HomeViewController {
    func configureUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = LayoutSettings.spacing
            layout.minimumInteritemSpacing = LayoutSettings.spacing
        }
    }
    
    func setupBindings() {
        self.cancellables.forEach { $0.cancel() }
        self.cancellables.removeAll()
        
        self.viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                switch(state) {
                case .loading:
                    self.loadingView.isHidden = false
                case .finishedLoadingTags:
                    self.configureTagPicker()
                case .finishedLoadingCats:
                    self.loadingView.isHidden = true
                    self.collectionView.reloadData()
                case .errorFetchingTags(let error):
                    self.loadingView.isHidden = true
                    self.show(alert: "Tags could not load: " + error.localizedDescription)
                case .errorFetchingCats(let error):
                    self.loadingView.isHidden = true
                    self.show(alert: "Cats could not load: " + error.localizedDescription)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func refreshFirstPage() {
        self.viewModel.loadFirstPage()
    }
    
    func loadTagListThenFirstPage() {
        self.viewModel.loadTagListThenFirstPage()
    }
    
    func configureTagPicker() {
        let tagPicker = UIPickerView()
        tagPicker.delegate = self
        self.tagTextField.delegate = self
        self.tagTextField.inputView = tagPicker
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionViewCell", for: indexPath) as! CatCollectionViewCell
        
        let cat = self.viewModel.cats[indexPath.item]
        let viewModel = CatCollectionViewModel(cat: cat)
        cell.configure(withViewModel: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.shouldLoadNextPage(indexPath.item) {
            self.viewModel.loadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCat = self.viewModel.cats[indexPath.item]
        let detailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailCatViewController") as! DetailCatViewController
        detailViewController.viewModel = DetailCatViewModel(cat: selectedCat)
        
        let nav = UINavigationController(rootViewController: detailViewController)
        self.present(nav, animated: true)
    }
    
    private func shouldLoadNextPage(_ currentItemIndex: Int) -> Bool {
        let loadOffsetRows = 2
        let catCount = self.viewModel.cats.count
        if self.viewModel.state.case != .loading && currentItemIndex > (catCount - (LayoutSettings.itemsPerRow * loadOffsetRows)) {
            return true
        } else {
            return false
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsInRow = CGFloat(LayoutSettings.itemsPerRow)
        var columnWidth = (collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right)
        
        if let layoutCV = collectionViewLayout as? UICollectionViewFlowLayout {
            columnWidth -= (layoutCV.minimumInteritemSpacing * (numberOfItemsInRow - 1))
        }
        
        columnWidth /= numberOfItemsInRow
        
        return CGSize(width: columnWidth, height: columnWidth)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.tags.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.tags[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tagTextField.text = self.viewModel.tags[row]
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.selectedTag = self.tagTextField.text
        self.refreshFirstPage()
    }
}
