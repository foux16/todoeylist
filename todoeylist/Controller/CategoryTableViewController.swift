//
//  ConfigureTableViewController.swift
//  todoeylist
//
//  Created by Felipe Silva Lima on 2/4/19.
//  Copyright © 2019 Felipe Silva Lima. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    //MARK: - Instances Declaration
    var categoryArray = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    // MARK: - TableView Data Source Methods
    //Indicando a quantidade de Linhas que tera a table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //Inicializando e reutilizando as celulas para cada Linha
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Definindo identificador da Celular
        let identifier : String = "CategoryCell"
        //Criando celula reutilizavel
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        //Setando o Texto dela para o conteudo da Array
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //Animando as celulas selecionadas e Levando para os items
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC =  segue.destination as! TodoeyListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            print("A categoria selecionada foi: \(destinationVC.selectedCategory)")
        }
    }
    
    //Criando o alerta de criacao de nova categoria
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Criando um objeto para prencher com texto que vai ser usado pelo AlertAction
        var textField = UITextField()
        //criando um controlador de alerta
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        //criando uma acao para o alerta chamado de addCategoria
        let addCategory = UIAlertAction(title: "Add a new Category", style: .default) { (addCategory) in
           
            var newCategory = Categories(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
            self.tableView.reloadData()
        }
        //criando outra acao pra o alerta chamado de cancelar
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (cancelAction) in
            print("Cancel Pressed")
        }
        //adicionando as acoes ao alerta
        alert.addAction(addCategory)
        alert.addAction(cancelAction)
        //adcionando um textfield ao alerta
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category Name"
            textField = alertTextField
        }
        //exibindo o alerta
        present(alert, animated: true, completion: nil)
    }
    
    //criando uma funcao para salvar as informacoes ao corebase
    func saveCategory(){
        do{
            try context.save()
        } catch {
            print("An error Occured attempting save data: \(error)")
        }
    }//end of saveCategory function
    
    //criando uma funcao para recaregar a data do corebase
    func loadCategory(with request: NSFetchRequest<Categories> = Categories.fetchRequest()){
       do{
            categoryArray = try context.fetch(request)
       } catch {
        print("An error Ocurred attempting load data: \(error)")
        }
        tableView.reloadData()
    }//end of loadCategory function
    
}//end of Main Class

