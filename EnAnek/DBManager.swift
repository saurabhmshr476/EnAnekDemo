//
//  DBManager.swift
//  EnAnek
//
//  Created by user on 16/09/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DBManager
{
    static let sharedInstance = DBManager()
    var context:NSManagedObjectContext?
    private init(){}
    func savePhotos(_ items:[FlickrPhoto],searchTerm:String)
    {
        let context = self.persistentContainer.viewContext
        for flickrphoto in  items{
            
            if let photo =  NSEntityDescription.insertNewObject(forEntityName: "FlickrPhotos", into: context) as? FlickrPhotos{
                photo.farm=Int64(flickrphoto.farm)
                photo.largeImage=flickrphoto.largeImage
                photo.thumbnail=flickrphoto.thumbnail
                photo.photoID=flickrphoto.photoID
                photo.secret=flickrphoto.secret
                photo.server=flickrphoto.server
                photo.searchString=searchTerm.lowercased();
                photo.timeStamp=Date()
                self.saveContext()
            }
            
            }
       
        
    }
    
    func removePhotos(searchTerm:String) {
        let context = self.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<FlickrPhotos> = FlickrPhotos.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "searchString == %@", searchTerm.lowercased())
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
                self.saveContext()
            }
        }
    }
    
    func getPhotos(searchTerm:String)->[FlickrPhoto]
    {
        let context = self.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<FlickrPhotos> = FlickrPhotos.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "searchString == %@", searchTerm.lowercased())
        let sort = NSSortDescriptor(key: #keyPath(FlickrPhotos.timeStamp), ascending: true)
        fetchRequest.sortDescriptors = [sort]

        var flickrPhotos = [FlickrPhoto]();
        if let data = try? context.fetch(fetchRequest),data.count > 0
        {
            for savePhoto in data{
                let photo = FlickrPhoto(photoID: savePhoto.photoID!, farm: Int(savePhoto.farm), server: savePhoto.server!, secret: savePhoto.secret!)
                flickrPhotos.append(photo)
            }
           
            
            
            
            return flickrPhotos
        }
        else
        {
            print ("fetch task failed")
        }
        return flickrPhotos
    }
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "EkAnek")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
