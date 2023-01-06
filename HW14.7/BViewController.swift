//
//  BViewController.swift
//  HW14.7
//
//  Created by Илья Перевозкин on 23.12.2022.
//

import UIKit
import RealmSwift

class BViewController: UIViewController {

    @IBOutlet weak var bTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bTableView.dataSource = self
    }
    
    let realm = try! Realm()
    let results = try! Realm().objects(PersistanceRealm.self)
    
     @IBAction func addTaskAction(_ sender: Any) {
         let alertController = UIAlertController(title: "Новая задача", message: "Введите задачу:", preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
         let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
             let tf = alertController.textFields?.first
             if let newTask = tf?.text {
                 let task = PersistanceRealm()
                 task.task = newTask
                 try! self.realm.write {
                     self.realm.add(task)
                 }
                 self.bTableView.reloadData()
             }
             
         }
         alertController.addTextField()
         alertController.addAction(cancelAction)
         alertController.addAction(saveAction)

         present(alertController, animated: true)
     }

}
extension BViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bTableView = tableView
        return results.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = bTableView.dequeueReusableCell(withIdentifier: "BCell")!
        let object = results[indexPath.row]
        cell.textLabel?.text = object.task
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(results[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
         let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
             success(true)
         })
         deleteAction.backgroundColor = .red

         return UISwipeActionsConfiguration(actions: [deleteAction])
     }
    
}
