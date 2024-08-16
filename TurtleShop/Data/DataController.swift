//
//  DataController.swift
//  TurtleShop
//
//  Created by Chris Turner on 06/08/2024.
//

import CoreData

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    @Published var selectedItem: Item?
    @Published var selectedMeal: Meal?
    @Published var selectedLocation: Location?
    
//    @Published var selectedFilter: Filter? = Filter.all
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "dev/null")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator, queue: .main, using: remoteStoreChanged)
        
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    func createSampleData() {
        //deletes existing data and creates new samples
        
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let location = Location(context: viewContext)
            location.id = UUID()
            location.name = "Location \(i)"
            
            let meal = Meal(context:viewContext)
            meal.id = UUID()
            meal.name = "Meal \(i)"
            
            for j in 1...5 {
                let item = Item(context: viewContext)
                item.id = UUID()
                item.name = "Item \(i)-\(j)"
                item.itemNewOrStaple = .new
                item.onShoppingList = true
                item.itemStatus = .unselected
                location.addToItems(item)
                meal.addToIngredients(item)
            }
            
            for k in 1...5 {
                let item = Item(context: viewContext)
                item.id = UUID()
                item.name = "Item \(i)-\(k+5)"
                item.itemNewOrStaple = .staple
                item.onShoppingList = true
                item.itemStatus = .unselected
                location.addToItems(item)
                meal.addToIngredients(item)
            }
        
        }
        
        try? viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    private func delete(_ fetchRequest : NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        delete(request1)
        
        let request2: NSFetchRequest<NSFetchRequestResult> = Location.fetchRequest()
        delete(request2)
        
        let request3: NSFetchRequest<NSFetchRequestResult> = Meal.fetchRequest()
        delete(request3)
        
        let request4: NSFetchRequest<NSFetchRequestResult> = MealCategory.fetchRequest()
        delete(request4)
        
        save()
    }
    
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
}

