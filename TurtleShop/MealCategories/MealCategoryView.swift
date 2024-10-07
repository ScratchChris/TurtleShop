//
//  MealCategoryView.swift
//  TurtleShop
//
//  Created by Chris Turner on 19/01/2025.
//

import SwiftUI

struct MealCategoryView: View {
    @EnvironmentObject var dataController: DataController

    @ObservedObject var mealCategory: MealCategory
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingNoNameAlert = false

    @FocusState private var focusedField: FocusedField?

    @State private var newOrEdit : newOrEdit = .edit

    var body: some View {
        NavigationStack {
            Form {
                Section("Category Name") {
                    VStack(alignment: .leading) {
                        TextField("Category Name", text: $mealCategory.mealCategoryName, prompt: Text("Enter the category name here"))
                            .focused($focusedField, equals: .mealCategoryName)
                    }
                }
                Section("Number of meals needed in category") {
                    Stepper("\(mealCategory.numberOfMeals) meals", value: $mealCategory.numberOfMeals)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Save") {
                        if mealCategory.mealCategoryName == "" {
                            isShowingNoNameAlert.toggle()
                        } else {
//                            dataController.selectedItem = nil

                            dataController.selectedMealCategory = nil
                            dataController.save()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .destructive) {
                        if newOrEdit == .new {
                            dataController.delete(mealCategory)
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
            .onAppear {
                if mealCategory.mealCategoryName == "" {
                    focusedField = .mealCategoryName
                    newOrEdit = .new
                }

            }
            .alert("Please enter a name for the Meal Category", isPresented: $isShowingNoNameAlert) {
                Button("Ok", role: .cancel) { }
            }
        }
    }
}

#Preview {
    MealCategoryView(mealCategory: MealCategory.example)
}
