//
//  ViewController.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import Combine
import UIKit

class HomeViewController: UIViewController, LoadableView {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tagTextField: UITextField!
    private var viewModel: HomeViewModel!
    var loadingView: LoadingView = UIView.fromNib()
    var cancellables = Set<AnyCancellable>()

    init?(coder: NSCoder, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupLoadingView()
        setupBindings()
        loadTagListThenFirstPage()
    }
}

// MARK: - UI Methods

extension HomeViewController {
    func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = LayoutSettings.spacing
            layout.minimumInteritemSpacing = LayoutSettings.spacing
        }
    }

    func setupBindings() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                switch state {
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
        viewModel.loadFirstPage()
    }

    func loadTagListThenFirstPage() {
        viewModel.loadTagListThenFirstPage()
    }

    func configureTagPicker() {
        let tagPicker = UIPickerView()
        tagPicker.delegate = self
        tagTextField.delegate = self
        tagTextField.inputView = tagPicker
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionViewCell", for: indexPath) as! CatCollectionViewCell

        let cat = self.viewModel.cats[indexPath.item]
        let viewModel = CatCollectionViewModel(cat: cat)
        cell.configure(withViewModel: viewModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if shouldLoadNextPage(indexPath.item) {
            viewModel.loadNextPage()
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCat = viewModel.cats[indexPath.item]
        let viewModel = DetailCatViewModel(cat: selectedCat)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(identifier: "DetailCatViewController") { coder in
            return DetailCatViewController(coder: coder, viewModel: viewModel)
        }

        let nav = UINavigationController(rootViewController: detailViewController)
        present(nav, animated: true)
    }

    private func shouldLoadNextPage(_ currentItemIndex: Int) -> Bool {
        let loadOffsetRows = 2
        let catCount = viewModel.cats.count
        if viewModel.state.case != .loading && currentItemIndex > (catCount - (LayoutSettings.itemsPerRow * loadOffsetRows)) {
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
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.tags.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.tags[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tagTextField.text = viewModel.tags[row]
    }
}

// MARK: - UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_: UITextField) {
        viewModel.selectedTag = tagTextField.text
        refreshFirstPage()
    }
}
