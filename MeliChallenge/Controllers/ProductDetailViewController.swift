//
//  ProductDetailViewController.swift
//  MeliChallenge
//
//  Created by lucas depetris on 14/12/2020.
//

import UIKit
import Foundation

class ProductDetailViewController: UIViewController {
    var product:Product?
    
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var titleProduct: UILabel!
    
    @IBOutlet var priceProduct: UILabel!
    @IBOutlet var productQuantitySold: UILabel!
    @IBOutlet var conditionProduct: UILabel!
    
    @IBOutlet var constraintFreeShipping: NSLayoutConstraint!
    @IBOutlet var freeShippingLabel: UILabel!
    @IBOutlet var sellerType: UILabel!
    @IBOutlet var profileSeller: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: self.product!.thumbnail)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let dataImage = data{
                    self.imgProduct.image = UIImage(data: dataImage)
                }else{
                    self.imgProduct.image = UIImage(imageLiteralResourceName: "NoImageLarge")
                }
            }
        }
        self.titleProduct.text = product?.title
        if let price = self.product?.price{
            self.priceProduct.text = FormatUtilsConverter.toCurrency(Double(price))
        }else{
            self.priceProduct.text = "Precio no disponible."
        }
        if let sold = self.product?.sold_quantity{
            self.productQuantitySold.text = String(format: "Vendidos: %d", sold)
        }else{
            self.productQuantitySold.text = "Vendidos: 0"
        }
        if let condition = self.product?.condition{
            self.conditionProduct.text = String(format: "Condición: %@", condition)
        }else{
            self.conditionProduct.text = "Condición: Desconocida"
        }
        
        if((self.product?.shipping.free_shipping) != true){
            self.constraintFreeShipping.constant = 0
        }
        
        if let status = self.product?.seller.seller_reputation.power_seller_status{
            self.sellerType.text = String(format: "Mercadolider %@", status)
        }
        
        
    }
    
    @IBAction func goToProfile(_ sender: Any) {
        if let profileSeller = self.product?.seller.permalink{
            if let url = URL(string: profileSeller) {
                UIApplication.shared.open(url)
            }
        }
    }
}
