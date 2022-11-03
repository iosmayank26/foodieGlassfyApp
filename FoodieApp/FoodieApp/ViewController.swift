//
//  ViewController.swift
//  FoodieApp
//
//  Created by Mayank Gupta on 03/11/22.
//

import UIKit
import Glassfy

class ViewController: UIViewController {
    
    enum Product: String {
        case premium
        
        var sku: String {
            return rawValue
        }
    }
    
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.tintColor = .systemYellow
        imgView.image = UIImage(systemName: "cart")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let purchaseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Purchase", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        view.addSubview(imageView)
        view.addSubview(purchaseButton)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            purchaseButton.heightAnchor.constraint(equalToConstant: 50),
            purchaseButton.widthAnchor.constraint(equalToConstant: 220),
            purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            purchaseButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
        
        purchaseButton.addTarget(self, action: #selector(purchaseProduct), for: .touchUpInside)
    }
    
    @objc private func purchaseProduct() {
        getProduct { [weak self] sku in
            debugPrint(sku.product.localizedTitle)
            debugPrint(sku.product.localizedDescription)
            debugPrint(sku.product.price)
            
            self?.purchase(sku: sku)
        }
        
    }
    
    private func checkPermissions() {
        Glassfy.permissions { permissions, error in
            guard let permissions = permissions, error == nil else { return }
            
            if permissions[Product.premium.rawValue]?.isValid == true {
                //Do whatever you want here
            }
        }
    }
    
    private func getProduct(completion: @escaping (Glassfy.Sku) -> Void) {
        Glassfy.sku(id: Product.premium.rawValue) { sku, error in
            guard let sku = sku, error == nil else { return }
            completion(sku)
        }
    }
    
    private func purchase(sku: Glassfy.Sku) {
        Glassfy.purchase(sku: sku) { [weak self] transaction, error in
            guard let transact = transaction, error == nil else { return }
            
            if transact.permissions[Product.premium.rawValue]?.isValid == true {
                self?.imageView.image = UIImage(systemName: "flame")
            }
        }
    }
    
    
}

