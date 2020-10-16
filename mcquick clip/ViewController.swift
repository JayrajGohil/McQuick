//
//  ViewController.swift
//  mcquick clip
//
//  Created by Jayrajkumar Gohil on 10/14/20.
//

import UIKit

struct ProductModel {
    let image: UIImage
    let title: String
    let price: String
    let calories: String
    let category: String
}

struct MenuModel {
    let title: String
    let category: String
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var menuFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var productFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var basketView: UIView!
//    @IBOutlet weak var basketCollectionView: UICollectionView!
    @IBOutlet weak var basketViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var basketFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var tapGesture:UITapGestureRecognizer!
    @IBOutlet weak var btnApplePay: UIButton!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var btnPaymentClose: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblTotalItem: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!

    private let spacing:CGFloat = 0.5
    
    private let basketOpenHeight:CGFloat = 600
    private let basketCloseHeight:CGFloat = 60
    
    private let menuCollectionViewTag = 100
    private let productCollectionViewTag = 200
    private let basketItemCollectionViewTag = 300
    
    let productCellReuseIdentifier = "ProductCell"
    let menuCellReuseIdentifier = "MenuCell"
    let basketItemCellReuseIdentifier = "BasketItemCell"
    
    let menuData: [MenuModel] = [MenuModel(title: "Sandwiches&Meal", category: "SandwichesMeal"),
                                MenuModel(title: "Beverages", category: "Beverages"),
                                MenuModel(title: "McCafe", category: "McCafe"),
                                MenuModel(title: "Fries", category: "McCafe"),
                                MenuModel(title: "Bakery", category: "McCafe")]
    
    let sandwichData: [ProductModel] = [
                                ProductModel(image: #imageLiteral(resourceName: "BigMac"), title: "Big Mac", price: "4.29", calories: "550", category: "SandwichesMeal"),
                                ProductModel(image: #imageLiteral(resourceName: "Cheeseburger"), title: "Cheeseburger", price: "1.49", calories: "300", category: "SandwichesMeal"),
                                ProductModel(image: #imageLiteral(resourceName: "Hamburger"), title: "Hamburger", price: "1.29", calories: "250", category: "SandwichesMeal"),
                                ProductModel(image: #imageLiteral(resourceName: "TripleCheeseburger"), title: "Triple Cheeseburger", price: "3.19", calories: "530", category: "SandwichesMeal"),
                                ProductModel(image: #imageLiteral(resourceName: "McChicken"), title: "McChicken", price: "1.59", calories: "400", category: "SandwichesMeal"),
                                ProductModel(image: #imageLiteral(resourceName: "McDouble"), title: "McDouble", price: "1.79", calories: "380", category: "SandwichesMeal"),
                                ProductModel(image: #imageLiteral(resourceName: "DoubleCheeseburger"), title: "Double Cheeseburger", price: "2.19", calories: "440", category: "SandwichesMeal"),
                                ProductModel(image: #imageLiteral(resourceName: "QuarterPounderwCheese"), title: "Quarter Pounder with Cheese", price: "4.39", calories: "510", category: "SandwichesMeal"),
                                
                                ProductModel(image: #imageLiteral(resourceName: "MediumCaramelFrappe"), title: "Caramel Frappe", price: "3.29", calories: "510", category: "McCafe"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumCaramelMacchiato"), title: "Caramel Macchiato", price: "2.79", calories: "320", category: "McCafe"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumCoffee"), title: "Medium Coffee", price: "1.49", calories: "0", category: "McCafe"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumIcedCaramelCoffee"), title: "Iced Caramel Coffee", price: "2.00", calories: "190", category: "McCafe"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumIcedCaramelMacchiato"), title: "Iced Caramel Macchiato", price: "2.79", calories: "250", category: "McCafe"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumMochaFrappe"), title: "Mocha Frappe", price: "3.29", calories: "510", category: "McCafe"),
        
                                ProductModel(image: #imageLiteral(resourceName: "MediumCoke"), title: "Coke", price: "1.00", calories: "210", category: "Beverages"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumDietCoke"), title: "Diet Coke", price: "1.00", calories: "0", category: "Beverages"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumDrPepper"), title: "Dr Pepper", price: "1.00", calories: "200", category: "Beverages"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumFantaOrange"), title: "Fanta Orange", price: "1.00", calories: "210", category: "Beverages"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumHawaiianPunch"), title: "Fruit Punch", price: "1.00", calories: "210", category: "Beverages"),
                                ProductModel(image: #imageLiteral(resourceName: "MediumSprite"), title: "Sprite", price: "1.00", calories: "200", category: "Beverages"),
                                ProductModel(image: #imageLiteral(resourceName: "MinuteMaidPremiumOrangeJuice"), title: "Minute Maid Orange Juice", price: "2.59", calories: "200", category: "Beverages")
    ]
    
    var finalProductData: [ProductModel] = [ProductModel]()
    
    var arrSelectedProductIndex = [IndexPath]() // This is selected cell Index array
    var arrSelectedProductData = [ProductModel]() // This is selected cell data array
    
    var selectedMenuIndex: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menuCollectionView.tag = menuCollectionViewTag
        menuCollectionView.register(UINib.init(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuCollectionView.delaysContentTouches = false
        
        menuFlowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        menuFlowLayout.minimumLineSpacing = spacing
        menuFlowLayout.minimumInteritemSpacing = spacing
        
        
        productCollectionView.tag = productCollectionViewTag
        productCollectionView.register(UINib.init(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        productCollectionView.delaysContentTouches = false
        
        productFlowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        productFlowLayout.minimumLineSpacing = spacing
        productFlowLayout.minimumInteritemSpacing = spacing
        
        
//        basketCollectionView.tag = basketItemCollectionViewTag
//        basketCollectionView.register(UINib.init(nibName: "BasketItemCell", bundle: nil), forCellWithReuseIdentifier: "BasketItemCell")
//
//        basketFlowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
//        basketFlowLayout.minimumLineSpacing = spacing
//        basketFlowLayout.minimumInteritemSpacing = spacing
        
        resetView()
    }
    
    private func resetView() {
        self.paymentView.isHidden = true
        self.view.sendSubviewToBack(self.paymentView)
        
        self.btnApplePay.backgroundColor = UIColor.white
        
        self.btnApplePay.isHidden = true
        self.basketViewHeightConst.constant = basketCloseHeight
        
        self.finalProductData.removeAll()
        
        self.arrSelectedProductIndex.removeAll()
        self.arrSelectedProductData.removeAll()
        
        self.selectedMenuIndex = 0
        
        menuCollectionView.reloadData()
        productCollectionView.reloadData()
        
        self.searchBar.endEditing(true)
    }
    
    @IBAction func tapBasket(_ sender: Any) {
        if basketView.frame.height == basketCloseHeight {
            self.openBasket()
        } else {
            self.closeBasket()
        }
    }
    
    func openBasket() {
//        basketCollectionView.reloadData()
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn) {
            self.lblTotalItem.isHidden = true
            self.lblTotalPrice.isHidden = true
            self.basketView.frame = CGRect(x: 0, y: self.view.frame.height - self.basketOpenHeight - 200, width: self.view.frame.width, height: self.basketOpenHeight)
            self.basketViewHeightConst.constant = self.basketOpenHeight
        } completion: { (Bool) in
            self.btnApplePay.isHidden = false
        }
    }
    
    func closeBasket() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn) {
            self.lblTotalItem.isHidden = false
            self.lblTotalPrice.isHidden = false
            self.basketView.frame = CGRect(x: 0, y: self.view.frame.height - self.basketCloseHeight, width: self.view.frame.width, height: self.basketCloseHeight)
            self.basketViewHeightConst.constant = self.basketCloseHeight
            self.btnApplePay.isHidden = true
        } completion: { (Bool) in
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == menuCollectionViewTag {
            return self.menuData.count
        } else if collectionView.tag == productCollectionViewTag {
            self.finalProductData = self.sandwichData.filter { $0.category.lowercased() == menuData[selectedMenuIndex].category.lowercased()}
            return self.finalProductData.count
        } else {
            return self.arrSelectedProductData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == menuCollectionViewTag {
            let cell:MenuCell = collectionView.dequeueReusableCell(withReuseIdentifier: menuCellReuseIdentifier, for: indexPath as IndexPath) as! MenuCell
            cell.lblMenuTitle.attributedText = nil
            if selectedMenuIndex == indexPath.row {
                let underlineAttribute = [
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,
                    NSAttributedString.Key.underlineColor: UIColor.systemYellow] as [NSAttributedString.Key : Any]
                let underlineAttributedString = NSAttributedString(string: menuData[indexPath.row].title, attributes: underlineAttribute)
                cell.lblMenuTitle.attributedText = underlineAttributedString
            } else {
                cell.configure(with: menuData[indexPath.row])
            }
            cell.layoutSubviews()
            return cell
        } else if collectionView.tag == productCollectionViewTag{
            let cell:ProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellReuseIdentifier, for: indexPath as IndexPath) as! ProductCell
            cell.configure(with: self.finalProductData[indexPath.row]) // The row value is the same as the index of the desired text within the array.
            if arrSelectedProductIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
                cell.productHighlightView.alpha = 0.7
            } else {
                cell.productHighlightView.alpha = 0
            }
            cell.layoutSubviews()
            return cell
        } else {
            let cell:BasketItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: basketItemCellReuseIdentifier, for: indexPath as IndexPath) as! BasketItemCell
            cell.configure(with: self.finalProductData[indexPath.row])
            cell.layoutSubviews()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == menuCollectionViewTag {
            let numberOfItemsPerRow:CGFloat = 1
            let spacingBetweenCells:CGFloat = 16
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.productCollectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
            }else{
                return CGSize(width: 0, height: 0)
            }
        } else if collectionView.tag == productCollectionViewTag{
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 0.5
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.productCollectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
            }else{
                return CGSize(width: 0, height: 0)
            }
        } else {
            let numberOfItemsPerRow:CGFloat = 1
            let spacingBetweenCells:CGFloat = 0.5
            
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
            
            if let collection = self.productCollectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width, height: width)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
    }
        
// MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
        if collectionView.tag == menuCollectionViewTag {
            selectedMenuIndex = indexPath.row
            menuCollectionView.reloadData()
            productCollectionView.reloadData()
        } else {
            let strData = sandwichData[indexPath.item]
            if arrSelectedProductIndex.contains(indexPath) {
                arrSelectedProductIndex = arrSelectedProductIndex.filter { $0 != indexPath}
                arrSelectedProductData = arrSelectedProductData.filter { $0.title != strData.title}
            }
            else {
                arrSelectedProductIndex.append(indexPath)
                arrSelectedProductData.append(strData)
            }
            productCollectionView.reloadData()
            self.updateTotal()
        }
    }
    
    func updateTotal() {
        self.lblTotalItem.text = "Items: " + String(arrSelectedProductData.count)
        var total:Double = 0.0
        for product in arrSelectedProductData {
            total = total + Double(product.price)!
        }
        self.lblTotalPrice.text = "Subtotal: $" + String(total)
    }
    
    
    @IBAction func clkApplePay(_ sender: Any) {
        let loadingView = UIView.init(frame: self.view.frame)
        loadingView.backgroundColor = UIColor.lightGray
        
        let jeremyGif = UIImage.gifImageWithName("giphy")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame.size = CGSize(width: 200, height: 200)
        imageView.center = CGPoint(x: loadingView.frame.size.width  / 2,
                                     y: loadingView.frame.size.height / 2)

        
        loadingView.addSubview(imageView)
        self.view.addSubview(loadingView)
        self.view.bringSubviewToFront(loadingView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // code to remove your view
            self.view.sendSubviewToBack(loadingView)
            loadingView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.showHideTransitionViews) {
                self.paymentView.isHidden = false
                self.view.bringSubviewToFront(self.paymentView)
            } completion: { (Bool) in
            }
        }
    }
    
    @IBAction func clkPaymentClose(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.showHideTransitionViews) {
            self.resetView()
        } completion: { (Bool) in
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }

}

