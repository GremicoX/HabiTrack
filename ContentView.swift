//
//  ContentView.swift
//  HabiTrack
//
//  Created by Gregory Covert on 6/11/21.
//

import SwiftUI

struct Habit: Identifiable, Codable {
    var id = UUID()
    let habitStruct: String
    let habitDesc: String
    let frequencyStruct: String
    let habitCompleted: Int
}

class Habits: ObservableObject {
    @Published var habitsClass = [Habit]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(habitsClass) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    
    init() {
        if let habits = UserDefaults.standard.data(forKey: "Habits") {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([Habit].self, from: habits) {
                self.habitsClass = decoded
                return
            }
        }
        self.habitsClass = []
    }
}

struct ContentView: View {
    
    // Set an observed variable equal to an instance of the class Habits()
    @ObservedObject var habitsOO = Habits()
    
    @State private var isShowingAddHabitSheet = false
    
    // This is the part that is not correct. I reverted to giving this a value to clear the error messages.
    @State private var completed = 0
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(habitsOO.habitsClass) { habits in
                    NavigationLink(
                        destination: VStack {
                            Text(habits.habitStruct)
                                .font(.title)
                            Text(habits.habitDesc)
                            Spacer()
                            Stepper("Completed \(completed) times!", value: $completed)
                            
                            // Button added per Dan OLeary twitter suggestion.
                            Button(action: {
                                
                                // To do: Set variable named 'completed' to equal the struct property 'habitCompleted' so that changes get saved.
                                print("Habit completed \(completed) times")
                            }, label: {
                                Text("Save")
                            })
                            Spacer()
                        },
                        label: {
                            VStack(alignment: .leading) {
                                Text(habits.habitStruct)
                                    .font(.headline)
                                Text(habits.frequencyStruct)
                                    .font(.subheadline)
                            }
                        })
                    
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("HabiTrack")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                isShowingAddHabitSheet = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $isShowingAddHabitSheet) {
                AddHabit(habits: self.habitsOO)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        habitsOO.habitsClass.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
