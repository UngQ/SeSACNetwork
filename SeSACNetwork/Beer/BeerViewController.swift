//
//  BeerViewController.swift
//  SeSACNetwork
//
//  Created by ungq on 1/16/24.
//

import UIKit
import Kingfisher
import Alamofire

struct Beer: Codable {
    let name: String
    let description: String
    let image_url: String
}

class BeerViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var beerImageView: UIImageView!
    @IBOutlet var beerNameLabel: UILabel!
    @IBOutlet var beerDescriptionLabel: UILabel!
    @IBOutlet var randomButton: UIButton!
    
    var randomBeer: [Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        callRequest()
   
    }
    
    @IBAction func randomButtonClicked(_ sender: UIButton) {
        callRequest()
    }
}


extension BeerViewController {
    func configureView() {
        titleLabel.text = "오늘은 이 맥주를 추천합니다!"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        beerNameLabel.font = .boldSystemFont(ofSize: 16)
        beerNameLabel.textAlignment = .center
        beerDescriptionLabel.numberOfLines = 0
        beerDescriptionLabel.font = .systemFont(ofSize: 15)
        beerDescriptionLabel.textAlignment = .center
        randomButton.setTitle("다른 맥주 추천받기", for: .normal)
        randomButton.setImage(UIImage(systemName: "n.square.fill"), for: .normal)
    }
    
    func callRequest() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url).responseDecodable(of: [Beer].self) { response in
            switch response.result {
            case .success(let success):
                print("성공")
                self.randomBeer = success
                self.dataInput()
            case .failure(let failure):
                print("재실행")
                self.callRequest()
            }
        }
    }
    
    func dataInput() {
        beerNameLabel.text = randomBeer[0].name
        beerDescriptionLabel.text = randomBeer[0].description
        let imageUrl = URL(string: randomBeer[0].image_url)
        self.beerImageView.kf.setImage(with: imageUrl)
    }
}
