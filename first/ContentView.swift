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
    
    //    Step 2: Create Variables for Your Hobbies and Interests
    //    Declare variables for your hobbies and interests, as example:
    //    • hobby: Your favorite hobby (String).
    //    • numberOfHobbies: The total number of hobbies you have (Int).
    //    • favoriteNumber: Your favorite number (Int).
    //    • isHobbyCrea&ve: Whether your hobby is crea4ve (Bool).
    //    Add some more details about you.
    
    var hobbies: String = "watching series"
    var numberOfHobbies: Int = 5
    var favoriteNumber: Int = 7
    var isHobbyCreative: Bool = false
    
    var secondHobby: String = "hiking"
    var yearOfEnrolling: Int = 2023
    
    
//    Step 3: Create a Summary of Your Life Story
//    Use string interpola4on to combine all your variables into one final summary string.
//    The summary should look something like:
//    • “My name is John Doe. I am 20 years old, born in 2003. I am currently a student. I enjoy pain>ng, which is
//    a crea>ve hobby. I have 5 hobbies in total, and my favorite number is 7.”
    
    let lifeStory: String = "My name is \(firstName) \(lastName). I'm \(age) years old, born in \(birthYear). I'm currently \(isStudent ? "a student of KBTU at 4th course" : "not a student"). At my free time I like \(hobbies) which is \(isHobbyCreative ? "a creative hobby" : "not a creative hobby"). I have \(numberOfHobbies) hobbies in total and my favorite number is \(favoriteNumber). Besides, I love \(secondHobby) . Aslo, another interesting fact about me is that I live in \(currentCity) since \(yearOfEnrolling)."
    
    print(lifeStory)
    
//    Bonus Task:
//    Add an addi4onal variable for futureGoals (String), and append it to your life story (and any other
//    interes4ng informa4on related to you 🙂). Also try to use emoji as value of variables and variable names.
//    • Example: “In the future, I want to become a professional iOS developer.”
    
    var futureGoals: String = "I want to be rich."
    var story: String = "ship my first app on the App Store"
    var favoriteEmoji: String = "😄"
     
    var fullLifeStory: String = lifeStory + " In the future, \(futureGoals) And \(story)" + " that makes me feel \(favoriteEmoji)"
     
     
    print(fullLifeStory)
}
