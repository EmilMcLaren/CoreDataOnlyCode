//
//  NewTaskViewController.swift
//  CoreDataOnlyCode
//
//  Created by Emil on 22.10.2022.
//

import UIKit
import CoreData


class NewTaskViewController: UIViewController {
    
    //context оперативная память
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //MARK:  buttoms
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New task"
        //textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
        return textField
    }()
    
    private lazy var saveButtom: UIButton = {
        let buttom = UIButton()
        buttom.tintColor = .blue
        buttom.backgroundColor = .black
        buttom.setTitle("Save Task", for: .normal)
        buttom.layer.cornerRadius = 10
        buttom.addTarget(self, action: #selector(save), for: .touchUpInside)
        return buttom
    }()
    
    private lazy var cancelButtom: UIButton = {
        let buttom = UIButton()
        buttom.tintColor = .blue
        buttom.backgroundColor = .gray
        buttom.setTitle("Cancel Task", for: .normal)
        buttom.layer.cornerRadius = 10
        buttom.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return buttom
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubView()
        setupConstrains()
    }
    
    // add the buttons
    private func setupSubView() {
        view.addSubview(taskTextField)
        view.addSubview(saveButtom)
        view.addSubview(cancelButtom)
    }
    
    private func setupConstrains() {
        
        //taskTextField
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            
        ])
        
        //saveButtom
        saveButtom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButtom.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            saveButtom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            
        ])
        
        //cancelButtom
        cancelButtom.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButtom.topAnchor.constraint(equalTo: saveButtom.bottomAnchor, constant: 20),
            cancelButtom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButtom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            
        ])
    }
    
    
    
    //is dont used because we add new cell from alert
    @objc private func save() {
        //добавляем в контекст сущность
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        // сохряняем сущность в контекст
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        
        task.name = taskTextField.text
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        dismiss(animated: true)
    }
    
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
}

//2.16
