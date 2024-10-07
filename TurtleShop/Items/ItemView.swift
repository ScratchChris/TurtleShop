//
//  ItemView.swift
//  TurtleShop
//
//  Created by Chris Turner on 16/08/2024.
//

import SwiftUI

enum newOrEdit {
    case new
    case edit
}

struct ItemView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var item: Item
    @Environment(\.presentationMode) var presentationMode
    @State private var new = false
    @State private var isShowingNoNameAlert = false
    
    @State private var newOrEdit : newOrEdit = .edit
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var locations: FetchedResults<Location>
    @FocusState private var focusedField: FocusedField?
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Name") {
                    VStack(alignment: .leading) {
                        TextField("Item Name", text: $item.itemName, prompt: Text("Enter the item name here"))
                            .focused($focusedField, equals: .itemName)
                    }
                }
                
                    Section("Item Details") {
                        if item.itemNewOrStaple == .neither {
                            Text("Item is currently only in meals and not in the main shopping list.  To add this as a seperate item to your main shopping list, check the staple box below")
                                .foregroundStyle(.secondary)
                                .animation(.easeInOut)
                        }
                        
                        if item.itemNewOrStaple == .new {
                            Text("New Item!")
                                .contentShape(Rectangle())
                                .listRowBackground(Color.green.opacity(0.2))
                        }
                        Toggle(isOn: .init(
                            get: { item.itemNewOrStaple == .staple },
                            set: { newValue in item.itemNewOrStaple = newValue ? .staple : .neither }
                            
                        ) ) {
                            Text("Staple Item")
                        }
                        .onChange(of: item.itemNewOrStaple) { oldValue, newValue in
                            if newValue == .staple {
                                item.onShoppingList = true
                            }
                            print(item.itemNewOrStaple)
                        }
                        .contentShape(Rectangle())
                        .listRowBackground(Color.yellow.opacity(0.2))
                        .tint(.yellow)
                    }
                
                
                //Staple check box, or status of new, or neither because it's in a meal.  If it's only in a meal, show it as only in a meal (and which meal) and allow for selection of staple.
                
                Section("Item Location") {
                    Picker("Location", selection: $item.location) {
                        ForEach(locations) { location in
                            Text(location.locationName).tag(location)
                        }
                        
                    }
//                    .frame(height: 75)
                    .pickerStyle(.wheel)
                    
                }
                
                Section("Item Meals") {
                    if item.itemMeals.isEmpty {
                        Text("Item is currently not in any meals")
                            .foregroundStyle(.secondary)
                    } else {
                        List {
                            ForEach(item.itemMeals) { meal in
                                Text(meal.mealName)
                            }
                        }
                    }
                }
            }
//            .onReceive(item.objectWillChange) { _ in
//                dataController.queueSave()
//            }
            .onAppear {
                if item.itemName == "" {
                    if dataController.selectedLocation == nil {
                        item.location = locations[0]
                    }
                    focusedField = .itemName
                    newOrEdit = .new
                }
                
            }
            .interactiveDismissDisabled()
            .alert("Please enter a name for the item", isPresented: $isShowingNoNameAlert) {
                Button("Ok", role: .cancel) { }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Save") {
                        if item.itemName == "" {
                            isShowingNoNameAlert.toggle()
                        } else {
//                            dataController.selectedItem = nil
                            
                            dataController.selectedMeal = nil
                            dataController.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .destructive) {
                        if newOrEdit == .new {
                            dataController.delete(item)
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
        }
    }
    
}

#Preview {
    ItemView(item: .example)
}
