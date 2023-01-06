//
//  СViewController.swift
//  HW14.7
//
//  Created by Илья Перевозкин on 24.12.2022.
//

import UIKit
import CoreData

class СViewController: UIViewController {
    
    
    @IBOutlet weak var cTableView: UITableView!
    var tasks:[Tasks] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cTableView.dataSource = self
        
    }
    
    @IBAction func addTaskAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Новая задача", message: "Введите задачу:", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
            let tf = alertController.textFields?.first
            if let newTask = tf?.text {
                self.saveTask(newTask)
                self.cTableView.reloadData()
            }
            
        }
        alertController.addTextField()
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true)
    }
    func saveTask(_ task: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        let tasksObject = Tasks(entity: entity, insertInto: context)
        tasksObject.task = task
        do {
            try context.save()
            tasks.append(tasksObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

    

extension СViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cTableView = tableView
        return tasks.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cTableView.dequeueReusableCell(withIdentifier: "cCell")!
        let object = tasks[indexPath.row]
        cell.textLabel?.text = object.task
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
            if let tasks = try? context.fetch(fetchRequest) {
                context.delete(tasks[indexPath.row])
                self.tasks.remove(at: indexPath.row)
            }
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
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


