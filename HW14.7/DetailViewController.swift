//
//  DetailViewController.swift
//  HW12.6
//
//  Created by Илья Перевозкин on 09.12.2022.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {

    var url = ""
    var apiResult: Character?
    
    @IBOutlet var detailNameLabel: UILabel!
    @IBOutlet var detailLiveIndicator: UIImageView!
    @IBOutlet var detailLiveStatus: UILabel!
    @IBOutlet var detailSpeciesAndGender: UILabel!
    @IBOutlet var detailLastLocation: UILabel!
    @IBOutlet var detailFirstSeen: UILabel!
    @IBOutlet var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingData(URL: URL(string: url)!)
        
    }
    
    func fetchingData(URL: URL) {
        AF.request(URL).validate().response { response in
            switch response.result {
            case .success(let data):
                do {
                    self.apiResult = try JSONDecoder().decode(Character.self, from: data!)
                    if let apiResult = self.apiResult {
                        self.detailNameLabel.text = apiResult.name
                        self.detailLiveStatus.text = apiResult.status
                        self.detailSpeciesAndGender.text = "\(apiResult.species) - \(apiResult.gender)"
                        self.detailLastLocation.text = apiResult.location.name
                        switch apiResult.status {
                        case "Alive":
                            self.detailLiveIndicator.tintColor = .green
                        case "unknown":
                            self.detailLiveIndicator.tintColor = .yellow
                        case "Dead":
                            self.detailLiveIndicator.tintColor = .red
                        default:
                            return
                        }
                        URLSession.shared.dataTask(with: Foundation.URL(string: apiResult.episode.first!)!) { (data, response, error) in
                            DispatchQueue.main.async {
                                self.detailFirstSeen.text = try! JSONDecoder().decode(Episode.self, from: data!).name
                            }
                        }.resume()
                        URLSession.shared.dataTask(with: Foundation.URL(string: apiResult.image)!) { (data, response, error) in
                            DispatchQueue.main.async {
                                self.detailImageView.image = UIImage(data: data!)
                            }
                        }.resume()
                    }
                    
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
