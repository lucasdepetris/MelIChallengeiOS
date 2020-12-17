//
//  APIService.swift
//  MeliChallenge
//
//  Created by lucas depetris on 13/12/2020.
//

import Foundation

class APIService :  NSObject {
    
    func apiToGetSearchData(textToSearch: String,completion : @escaping ([Product]) -> (), completionWithError:@escaping (String) -> ()){
        
        let uc = NSURLComponents()
        uc.scheme = "https"
        uc.host = "api.mercadolibre.com"
        uc.path = "/sites/MLA/search"
        let searchQuery = NSURLQueryItem(name: "q", value: textToSearch)
        uc.queryItems = [searchQuery] as [URLQueryItem]
        guard let url = uc.url else {
            completionWithError(Constantes.errorGenerico)
            return
        }
        let request = NSURLRequest(url: url)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        
        URLSession(configuration: sessionConfig).dataTask(with: request as URLRequest) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []){
                    
                    guard let jsonArray = jsonResponse as? [String: Any] else {
                        print("Error al mapear el response en un JsonArray")
                        completionWithError(Constantes.errorGenerico)
                        return
                    }
                    
                    if let arrayResults =  try? JSONSerialization.data(withJSONObject: jsonArray["results"] as Any, options: []){
                        
                        if let searchData = try? jsonDecoder.decode([Product].self, from: arrayResults){
                            completion(searchData)
                        }else{
                            print("Error al mapear el objeto de tipo Product")
                            completionWithError(Constantes.errorGenerico)
                        }
                            
                    }else{
                        print("Error al convertir el array de results a Data type")
                        completionWithError(Constantes.errorGenerico)
                    }

                }else{
                    print("Error al obtener el object JSON")
                    completionWithError(Constantes.errorGenerico)
                }
                
            }
        }.resume()
    }
}
