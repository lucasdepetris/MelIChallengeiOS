//
//  ProductViewModel.swift
//  MeliChallenge
//
//  Created by lucas depetris on 13/12/2020.
//

import Foundation

class ProductListViewModel : NSObject{
    
    private var apiService : APIService!
    private(set) var searchData : [ProductListModel]! {
            didSet {
                self.bindProductViewModelToController()
            }
        }
    private(set) var errorMessage : String! {
            didSet {
                self.bindErrorProductViewModelToController()
            }
        }
    private var textToSearch:String = ""
    var bindProductViewModelToController : (() -> ()) = {}
    var bindErrorProductViewModelToController : (() -> ()) = {}
    
    init(textToSearch:String) {
        super.init()
        self.textToSearch = textToSearch
        self.apiService = APIService()
        callFuncToGetSearchData()
    }
    
    func callFuncToGetSearchData(){
        self.apiService.apiToGetSearchData(textToSearch: self.textToSearch, completion: {
                                            (searchData) in self.searchData = searchData
        },completionWithError: {
            (error) in self.errorMessage = error
        })
    }
}
