//
//  ViewController.swift
//  todoeylist
//
//  Created by Felipe Silva Lima on 1/28/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import UIKit
import CoreData

class TodoeyListViewController: UITableViewController {

    //Criacao de variaveis
    var itemArray = [Item]()
    
    var selectedCategory : Categories? {
        didSet{
            
            loadItems()
            
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    //MARK - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
       
        return cell
        
    }
    
    //MARK - Table View Delegate Methods
    //Metodo que verifica qual celula foi selecionada.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Utilizando uma caracteristica da table view chamada acessory para marcar/desmarcar as tarefas selecionadas.
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
        
        tableView.reloadData()
        
       
    }
    //MARK - Add New Itemms
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Today Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user toches de Add new Item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems() {
        do{
            try context.save()
        } catch{
            print("Error saving context: \(error)")
        }
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error Fetching Data from context: \(error)")
        }
        tableView.reloadData()
    }
}
//MARK: - Search Bar Methods
extension TodoeyListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //NSPredicate CONTAINS[cd] -> vai procurar por palavras que deem um match e que desconsiderem o case sensitive e acentos = [cd]
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //sortDescriptors sao arrays, nesse caso nossa array so tem um elemento que e o "NSSortDescriptor(key: "title", ascending: true)"
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }//End searchBarSearchButtonClicked function
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }//End async
            
        }//End If Statement

    }//end searchBar
    
}//End Extension


