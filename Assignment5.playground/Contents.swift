// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part3_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section. LegacyBeacon in
//     particular must be reached with an extension, not edited.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • The Health Rule must exist in exactly ONE place in this file.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Power Cell

// Why a class and not a struct here?  ->

/* The point is that the battery is a single shared object with mutable state—meaning
   everyone referencing it should see the same charge level—whereas a struct would
   be copied every time it was passed.
*/
 final class PowerCell {
     private var charge: Int
     
     init(charge: Int){
         if charge <= 100 && charge >= 0 {
             self.charge = charge
         }
         else if charge > 100{
             self.charge = 100
         }
         else{
             self.charge = 0
         }
     }
     
     func level() -> Int{
         return charge
     }
     func spend(_ amount: Int) -> Bool{
         if amount <= 0 || charge < amount{
             return false
         }
         else{
             charge -= amount
             return true
         }
     }
     
     func recharge(by amount: Int){
         if amount > 0{
             charge += amount
             if charge > 100{
                 charge = 100
             }
         }
     }
 }

// Encapsulation proof (leave this commented, with the compiler error):
// cell.charge = 100
// error: 'charge' is inaccessible due to 'private' protection level

// MARK: Level 2 · The Fleet

// 2.1  What does `final` on runOnce() buy you?  ->

/* The "final" keyword prevents subclasses from altering
   the "pay energy first, then perform the task" sequence,
   ensuring the drone cannot operate for free or bypass
   the check.
 */
class Drone {
    let id: String
    let cell: PowerCell
    
    init(id: String, cell: PowerCell){
        self.cell = cell
        self.id = id
    }
    
    var powerCost: Int { 10 }
    var statusLine: String {
        "\(id): \(cell.level())%"
    }
    func performTask() -> Int { 0 }
    
    final func runOnce() -> Int{
        if cell.spend(powerCost) == false{
            return 0
        }
        else{
            return performTask()
        }
    }
}


// 2.2
 final class WelderDrone: Drone {
     override var powerCost: Int { 25 }
     override func performTask() -> Int { 40 }
     
     func weldSeam() -> String{
         return "The seam is welded"
     }
 }

 class ScannerDrone: Drone {
     override var powerCost: Int { 10 }
     override func performTask() -> Int { 15 }
     
     override var statusLine: String{
         "\(super.statusLine) [scanner]"
     }
 }

 final class CargoDrone: Drone {
     override var powerCost: Int { 20 }
     override func performTask() -> Int { 25 }
 }

// 2.3
 func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
     
     switch kind{
     case "welder":
         return WelderDrone.init(id: id, cell: PowerCell(charge: charge))
     case "scanner":
         return ScannerDrone(id: id, cell: PowerCell(charge: charge))
     case "cargo":
         return CargoDrone(id: id, cell: PowerCell(charge: charge))
     default:
         return nil
     }
     
 }
// let fleet: [Drone] = ...

var builtFleet: [Drone] = []

for records in fleetData{
    if let drone = makeDrone(kind: records.kind, id: records.id, charge: records.charge){
        builtFleet.append(drone)
    }
    else{
        print("Warning: skipped \(records.id), unknown kind '\(records.kind)'")
    }
}

let fleet: [Drone] = builtFleet

// MARK: Level 3 · The Shift

 func runShift(_ fleet: [Drone], rounds: Int) -> Int {
     var counts: Int = 0
     for _ in 0..<rounds{
         for drone in fleet{
             counts += drone.runOnce()
         }
     }
     return counts
 }

 let A = runShift(fleet, rounds: 3)
 print("A: \(A)")
 var sum = 0
 for drone in fleet{
     sum += drone.cell.level()
 }
 let B = sum
 print("B: \(B)")
 var sum2 = 0
for drone in fleet{
    if drone.cell.level() >= drone.powerCost{
        sum2 += 1
    }
}
 let C = sum2
 print("C: \(C)")
for drone in fleet {
    print(drone.statusLine)
}


// MARK: Level 4 · Diagnostics

// 4.1
protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

// 4.2
protocol Rechargeable {
    mutating func recharge(by amount: Int)
}
// Why does Drone implement recharge(by:) without `mutating`?  ->
/*
 A class is a reference type: recharge(by:) changes the shared PowerCell object,
 not the Drone value itself, so no `mutating` is needed (a struct must write it).
*/

struct SensorModule: Diagnosable, Rechargeable {
    let id: String
    var chargeLevel: Int
    
     
    var componentID: String { id }
    var statusCode: Int { code(Charge: chargeLevel) }

    mutating func recharge(by amount: Int){
        if amount > 0 {
            chargeLevel += amount
            if chargeLevel > 100{
                chargeLevel = 100
            }
        }
    }
}

var sensor: [SensorModule] = []
for record in sensorData{
    sensor.append(SensorModule(id: record.id, chargeLevel: record.charge))
}

extension Drone: Rechargeable {
    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}
// 4.3
// Why could [Drone] never have held the sensors?  ->
/*
 [Drone] accepts only Drone and its subclasses, whereas SensorModule
 is a struct and cannot be a Drone; the only thing they share is the Diagnosable protocol.
*/

extension Drone: Diagnosable {
    var componentID: String { id }
    var statusCode: Int { code(Charge: cell.level()) }
}

func diagnosticsReport(_ components: [Diagnosable]) -> String {
     var report = ""
     for component in components {
         let result: String = component.diagnose()
         report += result + "\n"
     }
     return report
 }
var components: [Diagnosable] = []
for drone in fleet{
    components.append(drone)
}

for module in sensor{
    components.append(module)
}

print(diagnosticsReport(components))


// MARK: Level 5 · Shared Behaviour

// 5.1 · default diagnose() + the single home of the Health Rule
 extension Diagnosable {
     func diagnose() -> String {
         "\(componentID): code \(statusCode)"
     }
     func code (Charge charge: Int) -> Int{
         if charge < 20{
             return 2
         }
         else if charge >= 20 && charge <= 49{
             return 1
         }
         else {
             return 0
         }
     }
 }

// 5.2 · the beacon you cannot edit
 extension LegacyBeacon: Diagnosable {
     var componentID: String {
         name
     }
     var statusCode: Int{
         code(Charge: signalStrength)
     }
     func diagnose() -> String {
         "[LEGACY BEACON] \(name), status code: \(statusCode)"
     }
 }

 components.append(beacon)

print(diagnosticsReport(components))
var sum3: Int = 0
for component in components{
    sum3 += component.statusCode
}

 let D = sum3
print(D)

// 5.3
extension Int {
    var powerBar: String {
        var number = self / 10
        var bar: String = ""
        while number > 0{
            bar += "#"
            number -= 1
            continue
        }
        if number >= 10{
            bar == "##########"
        }
        if number <= 0{
            bar == ".........."
        }
        var barInt = bar.count
        while barInt < 10{
            bar += "."
            barInt += 1
        }
        return bar
    }
}


// MARK: Level 6 · Incident Reports
// Two of these do not compile. Two compile and lie.
// For each: expectation, actual behaviour, the language rule, the fix.


// Report 1
class PatchDrone: Drone {
    override func performTask() -> Int {
        return 30
    }
}

// Report 2

class HeavyWelder: Drone {
    override var powerCost: Int { 25 }
    override func performTask() -> Int { 999 }
}

// Report 3
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]

if let welder = first as? WelderDrone {
    print(welder.weldSeam())
}

// Report 4
protocol Labelled {
    var componentID: String { get }
}

extension Labelled {
    func label() -> String { "generic component" }
}

struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}

let parts: [Labelled] = [Thruster(componentID: "T-1")]
print(parts[0].label())



// MARK: Finale · Mission Code

 let missionCode = "\(A)-\(B)-\(C)-\(D)"
 print("MISSION CODE: \(missionCode)")


// MARK: Bonus

// Two ways to forbid using Drone directly; a protocol-based redesign;
// two or three sentences comparing them.


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why does a class satisfy a `mutating` protocol requirement without the
    keyword, while a struct must write it?

 2. One thing inheritance does that protocols cannot, and one thing
    protocols do that inheritance cannot:

 3. What does `final` prevent, and what did it protect in runOnce()?

 4. In Report 4, why did the protocol extension's method win?

*/
