//
//  ViewController.swift
//  Game Catalog
//
//  Created by Wasla Shafique on 28/09/2023.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let catArray = ["Action", "Adventure", "Fantasy"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    @IBAction func addButtoonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Enter A New Category", message: "", preferredStyle: .alert)
        
        
        
        let newCategory = GameCategory(context : self.context)
        
        newCategory.name = textfield.text ?? ""
        
        
        let action = UIAlertAction(title: "Create", style: .default){(action) in
            print("User added category :  \(textfield.text ?? "None")")
            
            
        }
        
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Create Category"
            textfield = alertTextField
        }
        
       
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        catArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for : indexPath)
        
        let category = catArray[indexPath.row]
        
        cell.textLabel?.text = category
        return cell

    }
    
    
    //delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(catArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true) //on select the row does not stay selected and color disappers
    }
    
    
    func saveItems() {
          
          do {
            try context.save()
          } catch {
             print("Error saving context \(error)")
          }
          
          self.tableView.reloadData()
      }
}

