//
//  HomeViewController.swift
//  MeliChallenge
//
//  Created by lucas depetris on 13/12/2020.
//

import UIKit
import AVKit


class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet var tableViewResults: UITableView!
    @IBOutlet var MySearchBar: UISearchBar!
    private var productViewModel:ProductListViewModel!
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MySearchBar.delegate = self;
        self.MySearchBar.placeholder = "Busca un producto";
        // Do any additional setup after loading the view.
        self.tableViewResults.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableViewResults.delegate = self;
        tableViewResults.dataSource = self;
        //tableViewResults.estimatedRowHeight = 131;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (!Reachability.isConnectedToNetwork()){
            print("Internet Connection Not Available!")
            self.showAlertError(message: Constantes.notConnection)
            return
        }
        
        if(searchBar.text == ""){
            self.showAlertError(message: Constantes.fieldEmpty)
            return
        }
        
        myActivityIndicator.center = view.center
        myActivityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        view.addSubview(myActivityIndicator)
        self.myActivityIndicator.startAnimating()
        
        self.productViewModel = ProductListViewModel(textToSearch: searchBar.text ?? "")
        self.productViewModel.bindProductViewModelToController = {
            DispatchQueue.main.async {
                if(self.productViewModel.searchData.count > 0){
                    self.tableViewResults.reloadData()
                }else{
                    self.showAlertError(message: Constantes.resultsNotFound)
                }
                self.myActivityIndicator.stopAnimating()
            }
        }
        self.productViewModel.bindErrorProductViewModelToController = {
            DispatchQueue.main.async {
                self.showAlertError(message: self.productViewModel.errorMessage)
                self.myActivityIndicator.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.productViewModel != nil){
            return self.productViewModel.searchData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProductTableViewCell = tableViewResults.dequeueReusableCell(withIdentifier: "customCell") as! ProductTableViewCell
        
        cell.titleLabel.text = self.productViewModel.searchData[indexPath.row].title
        cell.subtitleLabel.text = FormatUtilsConverter.toCurrency(Double(self.productViewModel.searchData[indexPath.row].price))
        let url = URL(string: self.productViewModel.searchData[indexPath.row].thumbnail)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                
                guard let dataImage = data else{
                    cell.imgProduct.image = UIImage(imageLiteralResourceName: "NoImageLarge")
                    return
                }
                cell.imgProduct.image = UIImage(data: dataImage)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "detailViewController") as! ProductDetailViewController
        resultViewController.product = self.productViewModel.searchData[indexPath.row]
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    func showAlertError(message:String){
        let alert = UIAlertController(title: "Atención", message: message, preferredStyle: UIAlertController.Style.alert)
        alert .addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in switch action.style{
            case .default:
                print("default")
            case .cancel: break
                
            case .destructive: break
               
            @unknown default: break
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
