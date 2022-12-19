//
//  ViewController.swift
//  InternetCats
//
//  Created by Derek Buchanan on 12/18/22.
//

import UIKit

class HomeViewController: UIViewController, LoadableView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tagTextField: UITextField!
    var loadingView: LoadingView = UIView.fromNib()
    var catRepository: CatDataRepository = CatDataRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.setupLoadingView()
        self.loadTagList()
        self.refresh()
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
    
    func refresh() {
        self.loadingView.isHidden = false
        self.catRepository.loadFirstPage() { error in
            DispatchQueue.main.async {
                if !self.catRepository.isLoadingImages && !self.catRepository.isLoadingTags {
                    self.loadingView.isHidden = true
                }
                
                if let error {
                    self.show(alert: "Images could not load: " + error.localizedDescription)
                    return
                }
                
                self.collectionView.reloadData()
            }
        }
    }
    
    func loadTagList() {
        self.loadingView.isHidden = false
        self.catRepository.loadTagList() { error in
            DispatchQueue.main.async {
                if !self.catRepository.isLoadingImages && !self.catRepository.isLoadingTags {
                    self.loadingView.isHidden = true
                }
                
                if let error {
                    self.show(alert: "Tag list could not load: " + error.localizedDescription)
                    return
                }
                
                self.configureTagPicker()
            }
        }
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
        return self.catRepository.cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionViewCell", for: indexPath) as! CatCollectionViewCell
        cell.setup(self.catRepository.cats[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.shouldLoadNextPage(indexPath.item) {
            self.catRepository.loadNextPage { error in
                DispatchQueue.main.async {
                    if let error {
                        self.show(alert: error.localizedDescription)
                        return
                    }
                    
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCat = self.catRepository.cats[indexPath.item]
        let detailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailCatViewController") as! DetailCatViewController
        detailViewController.cat = selectedCat
        
        let nav = UINavigationController(rootViewController: detailViewController)
        self.present(nav, animated: true)
    }
    
    private func shouldLoadNextPage(_ currentItemIndex: Int) -> Bool {
        let loadOffsetRows = 2
        let catCount = self.catRepository.cats.count
        if !self.catRepository.isLoadingImages && currentItemIndex > (catCount - (LayoutSettings.itemsPerRow * loadOffsetRows)) {
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
        return self.catRepository.tags.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.catRepository.tags[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tagTextField.text = self.catRepository.tags[row]
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.catRepository.tag = self.tagTextField.text
        self.refresh()
    }
}
