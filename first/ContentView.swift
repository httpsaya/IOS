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
    
//    Create an array of five diﬀerent fruits. Access and print the third fruit in the array.
    var array1: [String] = ["Apple", "Strawberry", "Cherry", "Melon", "Watermelon"]
    print(array1[4])
    
//    Create a set of your favorite numbers. Add a new number to the set and print the updated set.
    var set: Set<Int> = [26, 7, 11]
    
    set.insert(4)
    print(set)
    
/*
     Create a dictonary with three key-value pairs where the keys are names of programming
     languages and the values are their release years. Access and print the release year of
     Swift.
*/
    var dict: [String: Int] = ["C": 1972, "Java": 1995, "Python": 1991]
    print(dict)
    
//    Create an array of four colors. Update the second color to a new one and print the updated array.
    var array2: [String] = ["red", "yellow", "pink", "black"]
    array2[1] = "blue"
    
    print(array2)
    
}
