//
//  LocationItemsView.swift
//  TurtleShop
//
//  Created by Chris Turner on 15/08/2024.
//

import SwiftUI

struct LocationItemsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var location: Location
    
    @State private var isShowingNewItemView = false
    @FocusState private var focusedField: FocusedField?
    @State private var isShowingNoNameAlert = false
    @State private var newOrEdit : newOrEdit = .edit

    var items: [Item] {
        var allItems: [Item]
        
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "location = %@", location)
        allItems = (try? dataController.container.viewContext.fetch(request)) ?? []
        
        return allItems.sorted()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Location Name") {
                    VStack(alignment: .leading) {
                        TextField("Item Name", text: $location.locationName, prompt: Text("Enter the location name here"))
                            .focused($focusedField, equals: .locationName)
                    }
                }
                
                List {
                    if location.locationItems.isEmpty {
                        
                    } else {
                        Section("Items in location") {
                            ForEach (items) { item in
                                ItemRow(item: item)
                                    .contentShape(Rectangle())
                                    .listRowBackground(item.listBackgroundColor)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Location")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Please enter a name for the location", isPresented: $isShowingNoNameAlert) {
                Button("Ok", role: .cancel) { }
            }
//            .onReceive(location.objectWillChange) { _ in
//                dataController.queueSave()
//            }
            .onAppear {
                if location.locationName == "" {
                    focusedField = .locationName
                    newOrEdit = .new
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Save") {
                        if location.locationName == "" {
                            isShowingNoNameAlert.toggle()
                        } else {
                            dataController.selectedLocation = nil
                            dataController.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    Button("Cancel", role: .destructive) {
                        if newOrEdit == .new {
                            dataController.delete(location)
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            dataController.container.viewContext.rollback()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dataController.selectedLocation = location
                        dataController.newItem()
                        isShowingNewItemView.toggle()
                    } label : {
                        Label("Add Item", systemImage: "plus")
                    }
                }


            }
//            .navigationDestination(isPresented: $isShowingNewItemView) {
//                if let selectedItem = dataController.selectedItem {
//                    ItemView(item: selectedItem)
//                }
//            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $isShowingNewItemView) {
                ItemView(item: dataController.selectedItem!)
            }
        }
    }
}

#Preview {
    LocationItemsView(location: .example)
}
