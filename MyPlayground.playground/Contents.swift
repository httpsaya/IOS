// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each signature when you start working on it.


// MARK: Level 1 · Decoding Telemetry

// 1.1
func parseReading(_ raw: String) -> Reading? {
    guard let (name, valueText) = splitOnce(raw, by: ":"),
          !name.isEmpty,
          let value = Int(valueText),
          value >= 0 || name == "TEMP"
    else{
        return nil
    }
    return (sensor: name, value: value)
            
}
// 1.2
 func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
     var valid: [Reading] = []
     var invalidCount = 0
     
     for line in lines{
         if let reading = parseReading(line){
             valid.append(reading)
         }else{
             invalidCount += 1
         }
     }
     return(valid: valid, invalidCount: invalidCount)
 }
 let parsed = parseLog(rawLog)
 

 let A = parsed.invalidCount
 print("Valid: \(parsed.valid), invalid: \(A)")

// MARK: Level 2 · Analysis

// 2.1
 func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
     var result: [Reading] = []
     for reading in readings {
         if isIncluded(reading){
             result.append(reading)
         }
     }
     return result
 }

 func values(of readings: [Reading]) -> [Int] {
     var result: [Int] = []
     for reading in readings{
         result.append(reading.value)
     }
     return result
 }

// 2.2
 func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
     guard let first = values.first else { return nil }
     
     var maxValue = first
     var minValue = first
     var sum = 0
     
     for value in values{
         if value < minValue{
             minValue = value
         }
         if value > maxValue{
             maxValue = value
         }
         sum += value
     }
     return (min: minValue, max: maxValue, average: Double(sum) / Double(values.count))
 }

 func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
     stats(of: values)
 }
 
 let o2Reading = select(parsed.valid) { reading in reading.sensor == "O2" }
 let o2Stats = stats(of: values(of: o2Reading))
 let B = Int(o2Stats?.average ?? 0)

 print(B)

// 2.3 · The Closure Ladder (5 sorts, then compare results in code)

 let readings = parsed.valid

// 1.
 let sorted1 = readings.sorted(by: { (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})

// 2.
let sorted2 = readings.sorted(by: { a, b in
    return a.value > b.value
})

// 3.
let sorted3 = readings.sorted(by: { a, b in a.value > b.value })

// 4.
let sorted4 = readings.sorted(by: { $0.value > $1.value })

// 5.
let sorted5 = readings.sorted { $0.value > $1.value }

print(values(of: sorted1) == values(of: sorted2))
print(values(of: sorted1) == values(of: sorted3))
print(values(of: sorted1) == values(of: sorted4))
print(values(of: sorted1) == values(of: sorted5))

// MARK: Level 3 · Temperature Stabilization

// 3.1
 func heatUp(_ t: Int) -> Int {
     return Int(t + 5)
 }
 func coolDown(_ t: Int) -> Int {
     return Int(t - 3)
 }
 func hold(_ t: Int) -> Int {
     return t
 }
 func chooseProtocol(for temp: Int) -> (Int) -> Int {
     if temp < 18{
         return heatUp(_:)
     }
     else if temp > 24{
         return coolDown(_:)
     }
     else {
         return hold(_:)
     }
 }

// 3.2
 func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
     var temp: Int = start
     var steps: Int = 0
     while (temp < 18 || temp > 24) && steps < maxSteps {
         let f = chooseProtocol(for: temp)
         temp = f(temp)
         steps += 1
     }
     let stable = temp >= 18 && temp <= 24
     return(finalTemp: temp, steps: steps, isStable: stable)
 }
 
 let TempReading = select(parsed.valid) {reading in reading.sensor == "TEMP"}
 let TempStats = stats(of: values(of: TempReading))
 let value = Int(TempStats?.min ?? 0)
 let C = runUntilStable(from: value).steps
 print(C)


// MARK: Level 4 · The Crew

// 4.1
 func oxygenLevel(of member: CrewMember) -> Int? {
     member.module?.oxygenTank?.level
 }

// 4.2
 func status(of member: CrewMember) -> String {
     let name = member.name
     let moduleName = member.module?.name ?? "open space"

     guard let module = member.module else{
         return "\(name): no data (open space)"
     }
     guard let level = member.module?.oxygenTank?.level else {
         return "\(name): no data (\(moduleName))"
     }
     if level < 20{
         return "\(name) \(level)% CRITICAL"
     }
     else {
         return "\(name) \(level)% OK"
     }
     
 }
for member in crew{
    print(status(of: member))
}

// 4.3
 @discardableResult
 func transferOxygen(
    from source: inout Int,
    to target: inout Int,
    amount: Int) -> Int {
        if source <= 100 && target <= 100{
            if amount > 0{
                var transfer = amount
                if transfer > source{
                    transfer = amount
                }
                if transfer > 100 - target{
                    transfer = 100 - target
                }
                source -= transfer
                target += transfer
                
                return target
            }
        }
        return 0
    }
guard let labTank = lab.oxygenTank,
      let habTank = hab.oxygenTank else {
    fatalError("Tank not found")
}
 
 let D = transferOxygen(from: &labTank.level, to: &habTank.level, amount: 30)
 print(D)

// 4.4
 func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
     var found: [CrewMember] = []
     
     for name in names{
         guard let member = roster[name] else{
             print("Unknown crew member: \(name)")
             continue
         }
         found.append(member)
     }
     let sortedMember = found.sorted { $0.priority < $1.priority }
     
     var result: [String] = []
     for member in sortedMember{
         result.append(member.name)
     }
     return result
 }
 print(evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))


// MARK: Level 5 · The Saboteur's Logbook
// The saboteur's code is below, commented out (it needs your
// oxygenLevel(of:) to compile). Comment on every problem, then
// write fixed versions and a test that proves the logic bug is gone.

// member.module! Nurlan has no module because he is in open space. The program can crash.
// oxygenTank! Dana has no oxygen tank because Dock does not have a tank. The program can crash again.
// oxygenLevel(of:)!  Dana and Nurlan have no oxygen data. The function returns nil, and ! causes an error.
// result! if nobody is critical, result stays nil, so the program can crash.
// There is a logic problem. The loop checks everyone and replaces the previous person each time. So, in the end we get the last critical person, not the first one.
// String is not enough if we want to return nil. So we should use String?. This allows the function to return nil when nobody is critical.

func reportOxygen(for member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data"
    }
    return "\(member.name): \(level)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        guard let level = oxygenLevel(of: member) else {
            continue
        }
        if level < 20 {
            return member.name
        }
    }
    return nil
}



// MARK: Finale · Launch Code

 let launchCode = "\(A)-\(B)-\(C)-\(D)"
 print("LAUNCH CODE: \(launchCode)")


// MARK: Bonus

// func makeAlarm(threshold: Int) -> (Int) -> Bool { }


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. guard let vs if let beyond syntax:

 2. Why can't you pass [Int] to stats(_ values: Int...)?

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?

 5. Full type of chooseProtocol and how to read it:

 Bonus. Where does the alarm counter live after makeAlarm returns?

*/
