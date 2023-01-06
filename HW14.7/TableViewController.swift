//
//  TableViewController.swift
//  HW12.6
//
//  Created by Илья Перевозкин on 12.08.2022.
//

import UIKit
import Alamofire
import RealmSwift


class TableViewController: UITableViewController {

    var realm = try! Realm()
    var objects = try! Realm().objects(NetworkObject.self)
    var apiResult: General?
    var urlImages: [URL] = []
    lazy var cachedDataSource: NSCache<AnyObject, UIImage> = {
        let cache = NSCache<AnyObject, UIImage>()
        return cache
    }()
    var url = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingData()
    }
    
    
    
    func fetchingData() {
        
        let url = "https://rickandmortyapi.com/api/character"
        
        AF.request(url).validate().response { response in
            switch response.result {
            case .success(let data):
                do {
                    self.apiResult = try JSONDecoder().decode(General.self, from: data!)
                    if self.objects.count != self.apiResult?.results.count {
                        for i in self.apiResult!.results {
                            
                            let object = NetworkObject()
                            object.nameCharacter = i.name
                            object.status = i.status
                            object.species = i.species
                            object.location = i.location.name
                            object.image = i.image
                    
                            try! self.realm.write {
                                self.realm.add(object)
                            }
                        }
                        
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
            self.tableView.reloadData()
        }
    }
    
    func fetchingImage(URL: URL, complition: @escaping ((UIImage?) -> Void)) {
        URLSession.shared.dataTask(with: URL) { (data, response, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    complition(image)
                }
            }
        }.resume()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if let apiResult = apiResult {
            cell.nameCharacterLabel.text = apiResult.results[indexPath.row].name
            cell.statusLabel.text = "\(apiResult.results[indexPath.row].status) - \(apiResult.results[indexPath.row].species)"
            cell.locationLabel.text = apiResult.results[indexPath.row].location.name
            
            let object = objects[indexPath.row]
            try! realm.write {
                object.nameCharacter = apiResult.results[indexPath.row].name
                object.status = apiResult.results[indexPath.row].status
                object.species = apiResult.results[indexPath.row].species
                object.location = apiResult.results[indexPath.row].location.name
                object.image = apiResult.results[indexPath.row].image
            }
            
            if apiResult.results[indexPath.row].status == "Alive" {
                cell.statusImage.tintColor = .green
            } else if apiResult.results[indexPath.row].status == "unknown" {
                cell.statusImage.tintColor = .yellow
            } else {
                cell.statusImage.tintColor = .red
            }
        } else {
            let object = objects[indexPath.row]
            cell.nameCharacterLabel.text = object.nameCharacter
            cell.statusLabel.text = "\(object.status) - \(object.species)"
            cell.locationLabel.text = object.location
            
            if object.status == "Alive" {
                cell.statusImage.tintColor = .green
            } else if object.status == "unknown" {
                cell.statusImage.tintColor = .yellow
            } else {
                cell.statusImage.tintColor = .red
            }
        }
        if let image = cachedDataSource.object(forKey: indexPath.row as AnyObject) {
            cell.cellImage.image = image
        } else {
            let object = objects[indexPath.row]
            fetchingImage(URL: URL(string: object.image)!) { image in
                cell.cellImage.image = image
                self.cachedDataSource.setObject(image!, forKey: indexPath.row as AnyObject)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let apiResult = apiResult {
            url = apiResult.results[indexPath.row].url
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        performSegue(withIdentifier: "segue", sender: cell)
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segue" else { return }
        guard let destination = segue.destination as? DetailViewController else { return }
        destination.url = url
    }


}
