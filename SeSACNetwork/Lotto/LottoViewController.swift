//
//  LottoViewController.swift
//  SeSACNetwork
//
//  Created by ungq on 1/16/24.
//

import UIKit
import Alamofire

struct Lotto: Codable {
    static let currentDrwNo: Int = 1102
    
    let drwNo: Int //회차
    let drwNoDate: String //날짜
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
}

class LottoViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var drwtNo1ImageView: UIImageView!
    @IBOutlet var drwtNo2ImageView: UIImageView!
    @IBOutlet var drwtNo3ImageView: UIImageView!
    @IBOutlet var drwtNo4ImageView: UIImageView!
    @IBOutlet var drwtNo5ImageView: UIImageView!
    @IBOutlet var drwtNo6ImageView: UIImageView!
    @IBOutlet var plusImageView: UIImageView!
    @IBOutlet var bnusNoImageView: UIImageView!
    
    var data: Lotto? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    @IBAction func tapGestureClicked(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension LottoViewController {
    func configureView() {
        
        tabBarItem.title = "Lotto"
        tabBarItem.image = UIImage(systemName: "l.joystick.tilt.up.fill")
        
        textField.font = .boldSystemFont(ofSize: 48)
        textField.textColor = .systemRed
        titleLabel.text = "당첨결과"
        titleLabel.font = .boldSystemFont(ofSize: 40)
        titleLabel.textAlignment = .center
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textAlignment = .center
        
        plusImageView.image = UIImage(systemName: "plus")
        
        let dataPicker = UIPickerView()
        dataPicker.delegate = self
        dataPicker.dataSource = self
        textField.inputView = dataPicker
        
        callRequest(number: Lotto.currentDrwNo)
    }
    
    func callRequest(number: Int) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        AF.request(url).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let success):
                self.data = success
                self.changeData()
            case .failure(let failure):
                print("실패")
            }
        }
    }
    
    func changeData() {
        textField.text = "\(data!.drwNo)회"

        dateLabel.text = dateFormatter(date: data!.drwNoDate)
        
        drwtNo1ImageView.image = UIImage(systemName: "\(data!.drwtNo1).circle.fill")
        drwtNo2ImageView.image = UIImage(systemName: "\(data!.drwtNo2).circle.fill")
        drwtNo3ImageView.image = UIImage(systemName: "\(data!.drwtNo3).circle.fill")
        drwtNo4ImageView.image = UIImage(systemName: "\(data!.drwtNo4).circle.fill")
        drwtNo5ImageView.image = UIImage(systemName: "\(data!.drwtNo5).circle.fill")
        drwtNo6ImageView.image = UIImage(systemName: "\(data!.drwtNo6).circle.fill")
        bnusNoImageView.image = UIImage(systemName: "\(data!.bnusNo).circle.fill")
    }
    
    func dateFormatter(date: String) -> String {
        let beforeDateFormatter = DateFormatter()
        beforeDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = beforeDateFormatter.date(from: date)
        let afterDateFormatter = DateFormatter()
        afterDateFormatter.dateFormat = "yyyy년 MM월 dd일 추첨"
        let result = afterDateFormatter.string(from: date!)
        return result
    }
}




extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Lotto.currentDrwNo
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return "\(Lotto.currentDrwNo-row)회"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        callRequest(number: Lotto.currentDrwNo - row)
    }
}
