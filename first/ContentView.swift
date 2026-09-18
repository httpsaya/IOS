//
//  ContentView.swift
//  first
//
//  Created by Zhansaya on 10.09.2026.
//
// ASSIGNMENT 2
import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear{
            someCoding()
        }
    }
    
}

#Preview {
    ContentView()

}

func someCoding(){
    
//    EASY TASK
    
//  1. Create an array of five diﬀerent fruits. Access and print the third fruit in the array.
    var array1: [String] = ["Apple", "Strawberry", "Cherry", "Melon", "Watermelon"]
    print(array1[4])
    
//  2. Create a set of your favorite numbers. Add a new number to the set and print the updated set.
    var set: Set<Int> = [26, 7, 11]
    
    set.insert(4)
    print(set)
    
/*
     3. Create a dictonary with three key-value pairs where the keys are names of programming
     languages and the values are their release years. Access and print the release year of
     Swift.
*/
    var dict: [String: Int] = ["C": 1972, "Java": 1995, "Python": 1991]
    print(dict)
    
//  4. Create an array of four colors. Update the second color to a new one and print the updated array.
    var array2: [String] = ["red", "yellow", "pink", "black"]
    array2[1] = "blue"
    
    print(array2)
    
//  MEDIUM TASK
    
/*  1. Create two sets of integers. The first set contains the numbers [1, 2, 3, 4] and the second
       set contains [3, 4, 5, 6]. Find and print the intersec7on of the two sets.
*/
    var setMedium: Set<Int> = [1, 2, 3, 4]
    var setMedium2: Set<Int> = [3, 4, 5, 6]
    
    var result = setMedium.intersection(setMedium2)
    print(result)
    
/*  2. Create a dictonary with three student names as keys and their scores as values. Update
       the score of one student and print the updated dictonary.
*/
    var dictMedium: [Int: String] = [100: "Saya", 110: "Zhan", 120: "Max"]
    dictMedium[130] = dictMedium.removeValue(forKey: 100)
    
    print(dictMedium)
    
/*  3. You have two arrays: one contains [“apple”, “banana”] and the other contains [“cherry”,
       “date”]. Merge the two arrays into one and print the result.
*/
    var arrayMedium1: [String] = ["apple", "banana"]
    var arrayMedium2: [String] = ["cherry", "date"]
    arrayMedium1 += arrayMedium2
    
    print(arrayMedium1)
    
//    
    
}
