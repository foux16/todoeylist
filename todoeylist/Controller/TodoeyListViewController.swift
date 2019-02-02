//
//  ViewController.swift
//  todoeylist
//
//  Created by Felipe Silva Lima on 1/28/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import UIKit

class TodoeyListViewController: UITableViewController {

    //Criacao de variaveis
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(dataFilePath)
       loadItems()
        
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
            let newItem = Item()
            
            newItem.title = textField.text!
            
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
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error encoding item array, \(error)")
        }
    }
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch {
                print ("Error decoding item array, \(error)")
            }
        }
        
        
    }
    
}



