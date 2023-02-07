//
//  ViewController.swift
//  CoreDataOnlyCode
//
//  Created by Emil on 22.10.2022.
//
import Foundation
import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
     private let cellID = "cell"
     private var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavBar()
        rightBarItem()
        
    }
    
    //in viewDidLoad dont work
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    

    //MARK: UI elements add
    //navig Bar
    private func setupNavBar() {
        //navig Bar
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //set color and setting for navBar
        let navBarAppreance = UINavigationBarAppearance()
        navBarAppreance.configureWithOpaqueBackground()
        navBarAppreance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppreance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppreance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 191/255,
            alpha: 194/255)
        navigationController?.navigationBar.standardAppearance = navBarAppreance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppreance
        
    }

    
    //add action buttom "ADD"
    private func rightBarItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask))
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    //MARK: objc methods
    
    //for open new view
    @objc private func addNewTask() {
//        let newTaskViewController = NewTaskViewController()
//        present(newTaskViewController, animated: true)
//        newTaskViewController.modalPresentationStyle = .fullScreen
        showAlert(withTitle: "New Task", andMessage: "Вы хотите добавить новую задачу?")
        
        
    }
    
    
    
    //for get data
    private func fetchData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    private func save(_ taskname: String) {
        //memory data
        //добавляем в контекст сущность
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        // сохряняем сущность в контекст
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        
        task.name = taskname
        tasks.append(task)
        
        let cellIndex = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        dismiss(animated: true)
    }

}




//MARK: TableViewDelegate
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        
        //MARK: дополнительная возможность с defaultContentConfiguration
//        var content = cell.defaultContentConfiguration()
//        content.text = task.name
//        cell.contentConfiguration = content
        
        cell.textLabel?.text = task.name
        return cell
    }
    
}


