//
//  DataController.swift
//  TurtleShop
//
//  Created by Chris Turner on 06/08/2024.
//

import CoreData

enum FocusedField {
    case itemName
    case mealName
    case locationName
    case mealCategoryName
}

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    @Published var selectedItem: Item?
    @Published var selectedMeal: Meal?
    @Published var selectedLocation: Location?
    @Published var selectedMealCategory: MealCategory?
    @Published var selectedShoppingTrip: ShoppingTrip?

    @Published var filterText = ""
    
    private var saveTask: Task<Void, Error>?
    
    //    @Published var selectedFilter: Filter? = Filter.all
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
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
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func queueSave() {
        saveTask?.cancel()
        
        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(3))
            save()
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

        let request5: NSFetchRequest<NSFetchRequestResult> = ShoppingTrip.fetchRequest()
        delete(request5)

        save()
    }
    
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    func itemsInMeal() -> [Item] {
        var predicates = [NSPredicate]()
        
        if let selectedMeal = selectedMeal {
            let mealPredicate = NSPredicate(format: "meals CONTAINS %@", selectedMeal)
            predicates.append(mealPredicate)
        }
        
        let request = Item.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let allItems = (try? container.viewContext.fetch(request)) ?? []
        print(allItems.count)
        return allItems.sorted()
        
    }
    
    //    func itemsForSelection() -> [Item] {
    //        var predicates = [NSPredicate]()
    //
    //        if let selectedLocation = selectedLocation {
    //            let locationPredicate = NSPredicate(format: "location == %@", selectedLocation)
    //            predicates.append(locationPredicate)
    //        }
    //
    //        if let selectedMeal = selectedMeal {
    //            let mealPredicate = NSPredicate(format: "meals CONTAINS %@", selectedMeal)
    //            predicates.append(mealPredicate)
    //        }
    //
    //        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)
    //
    //        if trimmedFilterText.isEmpty == false {
    //            let itemPredicate = NSPredicate(format: "name CONTAINS[c] %@", trimmedFilterText)
    //            predicates.append(itemPredicate)
    //        }
    //
    //        let request = Item.fetchRequest()
    //        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    //        let allItems = (try? container.viewContext.fetch(request)) ?? []
    //        print(allItems.count)
    //        return allItems.sorted()
    //
    //
    //    }
    
    func newItem() {
        let item = Item(context: container.viewContext)
        item.id = UUID()
        item.name = ""
        item.itemStatus = .unselected
        item.purchased = false
        item.shoppingListOrder = 0

        if let selectedLocation = selectedLocation {
            item.location = selectedLocation
        }
        
        if let selectedMeal = selectedMeal {
            item.addToMeals(selectedMeal)
            item.itemNewOrStaple = .neither
            if selectedMeal.selected == true {
                item.onShoppingList = true
            } else {
                item.onShoppingList = false
            }
        } else {
            item.itemNewOrStaple = .new
            item.onShoppingList = true
        }
        save()
        
        selectedItem = item
//        selectedMeal = nil
//        selectedLocation = nil
    }
    
    func newMeal() {
        let meal = Meal(context: container.viewContext)
        meal.id = UUID()
        meal.name = ""
        meal.selected = false
        save()
        
        selectedMeal = meal
    }

    func newMealCategory() {
        let mealCategory = MealCategory(context: container.viewContext)
        mealCategory.id = UUID()
        mealCategory.name = ""
        mealCategory.numberOfMeals = 0
        save()
        
        selectedMealCategory = mealCategory
    }

    func newLocation() {
        let location = Location(context: container.viewContext)
        location.id = UUID()
        location.name = ""
        save()
        
        selectedLocation = location
    }
    
    func newShoppingTrip() {
        let shoppingTrip = ShoppingTrip(context: container.viewContext)
        shoppingTrip.id = UUID()
        shoppingTrip.date = Date.now
        save()
        
        selectedShoppingTrip = shoppingTrip
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            // return true if they added a certin number of issues
            let fetchRequest = Item.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "purchased":
            //items that have been purchased (this probably won't work yet)
            let fetchRequest = Item.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "purchased == true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // an unknown award criterion; this should never been allow
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }


        // add cases in here for locations and meals, and items purchased.

    }

    
}

