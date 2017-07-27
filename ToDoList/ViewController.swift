//
//  ViewController.swift
//  ToDoList
//
//  Created by İrem Ergun on 24/07/2017.
//  Copyright © 2017 İrem Ergun. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate , NSFetchedResultsControllerDelegate, UNUserNotificationCenterDelegate{//works directly with core data and view controller
    
    
    @IBOutlet var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<DoItem>!
    var toBeDeleted: String!
    
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let toDoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        toDoLabel.text = "TO-DO LIST"
        self.navigationItem.titleView = toDoLabel
        attemptFetch()
        
    }
    func addNotification(content:UNNotificationContent,trigger:UNNotificationTrigger?, indentifier:String){
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            (errorObject) in
            if let error = errorObject{
                print("Error \(error.localizedDescription) in notification \(indentifier)")
            }
        })
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        let nameToAlter = response.notification.request.content.title
        
        if identifier == "OK"{
            findItem(name: nameToAlter)
        }
        else if(identifier == "del"){
            deleteItem(name: nameToAlter)
        }
        completionHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
            else{
                if let objs = self.fetchedResultsController.fetchedObjects {
                    let okAction = UNNotificationAction(identifier: "OK",
                                                        title: "OK", options: [])
                    
                    let deleteAction = UNNotificationAction(identifier: "del",
                                                            title: "Delete", options: [.destructive])
                    let category = UNNotificationCategory(identifier: "NotifCat",
                                                          actions: [okAction,deleteAction],
                                                          intentIdentifiers: [], options: []) //notification actions are always linked to a category. If a notification belongs to a category, the actions of that category are assigned to the notification.
                    center.setNotificationCategories([category])
                    for item in objs{
                        let content = UNMutableNotificationContent()
                        content.title = item.name!
                        content.body = item.detail!
                        content.sound = UNNotificationSound.default()
                        content.categoryIdentifier = "NotifCat"
                        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: item.date! as Date)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                        let identifier = "notif \(item.name!)"
                        let request = UNNotificationRequest(identifier: identifier,
                                                            content: content, trigger: trigger)
                        center.add(request, withCompletionHandler: { (error) in
                            if let error = error {
                                print("Error! \(error.localizedDescription)")
                            }
                        })
                    }
                }
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge,.alert,.sound])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    func configureCell(cell: CustomCell, indexPath: NSIndexPath){
        let item = fetchedResultsController.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        if let objs = fetchedResultsController.fetchedObjects , objs.count > 0{
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ViewtoDetail", sender: item)
        }
        
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ViewtoDetail"){
            let destViewController: DetailViewController = segue.destination as! DetailViewController
            if let item = sender as! DoItem? {
                destViewController.itemToShow = item
            }
        }
        else if(segue.identifier == "ViewToEdit"){
            let destViewController: EditViewController = segue.destination as! EditViewController
            destViewController.isEdit = false
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            titleLabel.backgroundColor = UIColor.white
            titleLabel.text = "Add Event"
            destViewController.navigationItem.titleView = titleLabel
        }
       
    }
    func attemptFetch(){
        let fetchRequest: NSFetchRequest<DoItem> = DoItem.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        self.fetchedResultsController = fetchedResultsController
        
        do{
            try self.fetchedResultsController.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! CustomCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    func deleteItem(name: String){
        if let objs = fetchedResultsController.fetchedObjects, objs.count > 0{
            for o in objs{
                if(o.name == name){
                    context.delete(o)
                    ad.saveContext()
                    break;
                }
            }
        }
    }
    func findItem(name: String){
        if let objs = fetchedResultsController.fetchedObjects, objs.count > 0{
            for o in objs{
                if(o.name == name){
                    o.isDone = true
                    ad.saveContext()
                    break;
                }
            }
        }
    }
    
}

