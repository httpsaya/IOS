//
//  ContentView.swift
//  first
//
//  Created by Zhansaya on 10.09.2026.
//

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
    //    • firstName: Your first name (String).
    //    • lastName: Your last name (String).
    //    • age: Your current age (Int).
    //    • birthYear: The year you were born (Int).
    //    • isStudent: Whether or not you are currently student (Bool).
    //    • height: Your height in meters (Double).
        
    //    Add some more details about you.
    //    Bonus Challenge: Create a constant currentYear and calculate your age by subtrac4ng birthYear from
    //    currentYear.
        
        var firstName: String = "Zhansaya"
        var lastName: String = "Umirkulova"
        let birthYear: Int = 2006
        var isStudent: Bool = true
        var height: Double = 165
        var currentCity: String = "Almaty"
        
    //    Bonus Task
        var currentYear: Int = 2026
        var age: Int = currentYear - birthYear
        
        print(age)
}
