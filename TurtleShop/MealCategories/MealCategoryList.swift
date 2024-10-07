//
//  MealCategoryList.swift
//  TurtleShop
//
//  Created by Chris Turner on 19/01/2025.
//

import SwiftUI

struct MealCategoryList: View {
    @EnvironmentObject var dataController: DataController

    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var mealCategories: FetchedResults<MealCategory>

    @State private var isShowingMealCategoryView = false


    var body: some View {
        NavigationStack {
            List {
                ForEach(mealCategories) { mealCategory in
                    HStack {
                        Text(mealCategory.mealCategoryName)
                            .swipeActions(edge: .trailing) {
                                Button("", systemImage: "trash", role: .destructive, action: {
                                    dataController.delete(mealCategory)
                                })
                                Button("", systemImage: "pencil", action: {
                                    dataController.selectedMealCategory = mealCategory
                                    isShowingMealCategoryView.toggle()
                                })
                                .tint(.green)
                            }

                    }
                }

            }
            .navigationTitle("Meal Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Category") {
                        dataController.newMealCategory()
                        isShowingMealCategoryView.toggle()

                    }
                }
            }
            .sheet(isPresented: $isShowingMealCategoryView) {
                MealCategoryView(mealCategory: dataController.selectedMealCategory!)
            }

        }
    }
}

#Preview {
    MealCategoryList()
}
