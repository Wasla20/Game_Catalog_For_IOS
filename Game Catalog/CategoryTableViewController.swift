//
//  ViewController.swift
//  Game Catalog
//
//  Created by Wasla Shafique on 28/09/2023.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryTableViewController: UITableViewController {

    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var catArray = [GameCategory]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        loadItems()
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func addButtoonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Enter A New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Create", style: .default){(action) in
            
            let newCategory = GameCategory(context : self.context)
            
            newCategory.name = textfield.text!
            let random = arc4random_uniform(100) + 1
            newCategory.numberOfGames = Int16(random)
            
            self.saveItems()
            
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
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }*/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for : indexPath) as! SwipeTableViewCell
        cell.delegate = self
        let category = catArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell

    }
    
    
    //delegate methods
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print(catArray[indexPath.row].name ?? "")
        
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true) //on select the row does not stay selected and color disappers
    }
    
    
    func saveItems() {
          
        
        
          do {
              
         try context.save()
              print("category saved to Database")
          } catch {
             print("Error saving context \(error)")
          }
          loadItems()
          self.tableView.reloadData()
      }
    
    func loadItems(){
        let request : NSFetchRequest <GameCategory> = GameCategory.fetchRequest()
        do{
            
            catArray = try context.fetch(request)
            print("category loaded from Database")

        }
        catch{
            print("error while fetching data : \(error)")
        }
        tableView.reloadData()
    }
}


extension CategoryTableViewController :  SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("inside extension")
            //deletes on click cell
             self.context.delete(self.catArray[indexPath.row])
             self.catArray.remove(at: indexPath.row)
            
            self.saveItems()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        //tableView.reloadData()
        return [deleteAction]
    }
    
    //delete on full right swipe does not work , need to figure it out
   /*
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    */
}
