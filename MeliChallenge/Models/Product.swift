//
//  Product.swift
//  MeliChallenge
//
//  Created by lucas depetris on 13/12/2020.
//

import Foundation


struct Product: Decodable {
    let title: String
    let id:String
    let price:Float
    let thumbnail:String
    let seller:Seller
    let available_quantity:Int
    let condition:String
    let sold_quantity:Int
    let shipping:Shipping
}

struct Seller: Decodable {
    let id: Float
    //let permalink:String
    //let seller_reputation:SellerReputation
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        //case permalink = "permalink"
        //case seller_reputation = "seller_reputation"
    }
    
    /*init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        if let permalink = try? values.decode(String.self, forKey: .permalink){
                self.permalink = permalink;
        }else{
                self.permalink = "";
        }
        
        if let seller = try? values.decode(SellerReputation.self, forKey: .seller_reputation){
                self.seller_reputation = seller;
        }else{
                self.seller_reputation = Sell;
        }
        
        
        }*/
}

struct SellerReputation: Decodable {
    
    let power_seller_status:String
    let level_id:String
    
    enum CodingKeys: String, CodingKey {
        case power_seller_status = "power_seller_status"
        case level_id = "level_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        if let status = try? values.decode(String.self, forKey: .power_seller_status){
                self.power_seller_status = status;
        }else{
                self.power_seller_status = "";
        }
        
        if let level = try? values.decode(String.self, forKey: .level_id){
                self.level_id = level;
        }else{
                self.level_id = "";
        }
        
        
        }
}

struct Shipping: Decodable {
    let free_shipping: Bool

}
