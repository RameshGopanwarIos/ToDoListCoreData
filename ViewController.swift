//
//  ViewController.swift
//  SampleToDoListApp
//
//  Created by Ramesh Gopanwar on 19/12/24.
//

import UIKit

class ToDoListCell: UITableViewCell {
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: context is for performing objects in coreData DataBase
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var tableView: UITableView!
    let reuseIdentifer = "ToDoListCell"
    private var items = [ToDoList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.reloadData()
        
        title = "Day Tasks"
        //adding tableView to subView, will receive touch events
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        let alert = UIAlertController(title: "new item", message: "enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                //when user adds empty text, deleting all existing tasks in table
                return self.deleteItem(item: self.items)
            }
            self.createItem(name: text)
        }))
        present(alert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as? ToDoListCell else {
            preconditionFailure()
        }
        cell.textLabel?.text = "\(item.name) - \(item.createdOn)"
        cell.textLabel?.textColor = .blue
                //cell.backgroundColor = .systemBackground
        return cell
                
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let alert = UIAlertController(title: "selected \(item.name)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(alert, animated: true)
    }
    func createItem(name: String) {
        let newItem = ToDoList(context: context)
        newItem.name = name
        newItem.createdOn = Date()
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            //error
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
    }
    
    func updateItem(item: ToDoList, newName: String) {
        item.name = newName
        do {
            try context.save()
        }
        catch {
            //error
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    func deleteItem(item: [ToDoList]) {
        for item in items {
            context.delete(item)
        }
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            //error
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    //To get all items from dataBase
    func getAllItems() {
        do {
            items = try context.fetch(ToDoList.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            //error
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
    }


}

