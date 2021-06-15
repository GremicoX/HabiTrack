//
//  AddHabit.swift
//  HabiTrack
//
//  Created by Gregory Covert on 6/12/21.
//

import SwiftUI

struct AddHabit: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var habits: Habits
    @State private var habit = ""
    @State private var habitDesc = ""
    @State private var frequency = "Daily"
    @State private var habitCompleted = 0
    
    static let frequencyTypes = ["Daily", "Weekly"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Habit", text: $habit)
                
                TextField("Description", text: $habitDesc)
                
                Picker("Frequency", selection: $frequency) {
                    ForEach(Self.frequencyTypes, id: \.self) {
                        Text($0)
                    }
                }
            }
            .navigationBarTitle("Add a new habit")
            .navigationBarItems(trailing: Button("Save") {
                let habit = Habit(habitStruct: self.habit, habitDesc: self.habitDesc, frequencyStruct: self.frequency, habitCompleted: self.habitCompleted)
                self.habits.habitsClass.append(habit)
                self.presentationMode.wrappedValue.dismiss()
                })
        }
    }
}

struct AddHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddHabit(habits: Habits())
    }
}
