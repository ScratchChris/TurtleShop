//
//  MealIngredientsList.swift
//  TurtleShop
//
//  Created by Chris Turner on 15/08/2024.
//

import SwiftUI

struct MealIngredientsList: View {
    @EnvironmentObject var dataController: DataController
    
    @ObservedObject var meal: Meal
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var isShowingNoNameAlert = false
    @State private var isShowingNewItemView = false
    @FocusState private var focusedField: FocusedField?
    @State private var newOrEdit : newOrEdit = .edit
    @State private var isShowingNoLocationsAlert = false
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var locations: FetchedResults<Location>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var mealCategories: FetchedResults<MealCategory>

    var items: [Item] {
        var allItems: [Item]
        
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "ANY meals == %@", meal)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []
        
        return allItems.sorted()
    }
    
    var itemsNotInMeal: [Item] {
        var allItems: [Item]
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "NOT (SELF IN %@)", meal.ingredients!)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []
        
        return allItems.sorted()
    }

    
    var body: some View {
        NavigationStack {
            
            Form {
                Section("Meal Name") {
                    VStack(alignment: .leading) {
                        TextField("Item Name", text: $meal.mealName, prompt: Text("Enter the meal name here"))
                    }
                    .focused($focusedField, equals: .mealName)
                }
                Section("Meal Categories") {
                    ForEach(mealCategories) { mealCategory in
                        if meal.mealCategories.contains(mealCategory) {
                            HStack {
                                Text(mealCategory.mealCategoryName)
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                            .onTapGesture {
                                mealCategory.removeFromMeals(meal)
                                dataController.save()
                            }
                        } else {
                            Text(mealCategory.mealCategoryName)
                                .foregroundStyle(.secondary)
                                .onTapGesture {
                                    mealCategory.addToMeals(meal)
                                    dataController.save()
                                }
                        }
                    }
                }
                Section("Ingredients (Long press to remove from meal)") {
                    if meal.mealIngredients.isEmpty {
                        Text("No ingredients in the meal yet")
                            .foregroundStyle(.secondary)
                    } else {
                        List {
                            ForEach (items) { item in
                                IngredientsRow(item: item)
                                    .contentShape(Rectangle())
                                    .onLongPressGesture {
                                        item.removeFromMeals(meal)
                                        if item.mealsCount == 0 {
                                            item.onShoppingList.toggle()
                                        }
                                    }
                            }
                        }
                    }
                }
                
                Section("Tap other items to add to meal") {
                    List {
                        ForEach(itemsNotInMeal) { item in
                            IngredientsRow(item: item)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    item.addToMeals(meal)
                                    if meal.selected == true {
                                        item.onShoppingList = true
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Edit Meal")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(meal.objectWillChange) { _ in
                dataController.queueSave()
            }
            .onAppear {
                if meal.mealName == "" {
                    focusedField = .mealName
                    newOrEdit = .new
                }
                print(itemsNotInMeal)
            }
            .toolbar {
                Button {
                    if locations.isEmpty {
                        isShowingNoLocationsAlert.toggle()
                    } else {
                        dataController.selectedMeal = meal
                        dataController.newItem()
                        isShowingNewItemView.toggle()
                    }
                } label : {
                    Label("Add Item", systemImage: "plus")
                }
            }
            .alert("Please enter a name for the meal", isPresented: $isShowingNoNameAlert) {
                Button("Ok", role: .cancel) { }
            }
            .alert("No Locations", isPresented: $isShowingNoLocationsAlert) {
                Button("Ok", role: .cancel) { }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Save") {
                        if meal.mealName == "" {
                            isShowingNoNameAlert.toggle()
                        } else {
                            dataController.selectedMeal = nil
                            dataController.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .destructive) {
                        if newOrEdit == .new {
                            dataController.delete(meal)
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            dataController.container.viewContext.rollback()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isShowingNewItemView) {
                ItemView(item: dataController.selectedItem!)
            }
        }
    }
}

#Preview {
    MealIngredientsList(meal: .example)
}
