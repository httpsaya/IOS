// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Deck Register

// 1.1
 enum Deck: String, CaseIterable {
     case bridge
     case lab
     case cargo
     case medbay
     case engine
     
     var evacuationPriority: Int {
         switch self {
         case .bridge: return 1
         case .medbay: return 2
         case .lab: return 3
         case .engine: return 4
         case .cargo: return 5
         }
     }
 }
 for deck in Deck.allCases {
    print("\(deck.rawValue): \(deck.evacuationPriority)")
 }


// 1.2
 enum AlarmLevel: Int {
     case green = 0
     case yellow
     case orange
     case red
     
     static func level(forTotalMass mass: Int) -> AlarmLevel {
         if mass >= 0 && mass <= 500{
             return .green
         }
         else if mass <= 1000{
             return .yellow
         }
         else if mass <= 1500{
             return .orange
         }
         else {
             return .red
         }
     }
 }

print(AlarmLevel.level(forTotalMass: 940))
print(AlarmLevel.level(forTotalMass: 0))
print(AlarmLevel.level(forTotalMass: 4000))


// MARK: Level 2 · The Manifest

// 2.1
 enum ManifestEntry {
     case crate(id: Int, massKg: Int)
     case container(code: String, massKg: Int)
     case livestock(species: String, count: Int, massPerUnitKg: Int)
     case unknown(raw: String)
 }

// 2.2
 func parseEntry(_ line: String) -> ManifestEntry {
     let parts = line.split(separator: ":")
     
     guard let tag = parts.first else{ return .unknown(raw: line)}
     
     switch tag {
     case "crate":
         guard parts.count == 3,
               let id = Int(parts[1]),
               let massKg = Int(parts[2])
         else { return .unknown(raw: line) }
         return .crate(id: id, massKg: massKg)
         
     case "container":
         guard parts.count == 3,
               let massKg = Int(parts[2])
         else {return .unknown(raw: line)}
         return .container(code: String(parts[1]), massKg: massKg)
     
     case "livestock":
         guard parts.count == 4,
              let count = Int(parts[2]),
              let massPerUnitKg = Int(parts[3])
         else {return .unknown(raw: line)}
         return .livestock(species: String(parts[1]), count: count, massPerUnitKg: massPerUnitKg)
         
     default:
         return .unknown(raw: line)
     }
     
 }
print(parseEntry("crate:101:120"))
print(parseEntry("container:KZ-ALM-7:340"))

// 2.3

func mass(of entry: ManifestEntry) -> Int {
    switch entry{
    case .crate(id: _, massKg: let massKg):
        return massKg
    case .container(code: _, massKg: let massKg):
        return massKg
    case .livestock(species: _, count: let count, massPerUnitKg: let massPerUnitKg):
        let sum = count * massPerUnitKg
        return sum
    case .unknown:
        return 0
    }
}
print("\n")
var sum: Int = 0
var countunknown = 0
for line in rawManifest{
    let entry = parseEntry(line)
    let result = mass(of: entry)
    print(result)
    
    sum += result
    
    switch entry{
    case . unknown:
        countunknown += 1
    default:
        break
    }
    
}

let A = sum
print("\n\(A) and the count of unknown lines: \(countunknown)")

// MARK: Level 3 · Crew Snapshots

// 3.1
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int
    mutating func breathe(_ amount: Int) { // lowers oxygen, never below 0
        oxygen -= amount
        if oxygen < 0{
            oxygen = 0
        }
    }
    mutating func move(to deck: Deck) { // changes deck
        self.deck = deck
    }
    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

// 3.2

func buildRoter() -> [CrewSnapshot]{
    var result: [CrewSnapshot] = []
    
    for member in crewData{
        guard let deck = Deck(rawValue: member.deck) else{
            print("unknown deck '\(member.deck)' for \(member.name)")
            continue
        }
        result.append(CrewSnapshot(name: member.name, deck: deck, oxygen: member.oxygen))
    }
    return result
}

let crewRoster = buildRoter()
print(crewRoster)
print(crewRoster.count)

// 3.3 · Value-semantics demonstration (copy / plain parameter / inout)

func drainOxygen(_ snapshot: CrewSnapshot) -> CrewSnapshot {
    var local = snapshot
    local.breathe(40)
    print("local oxygen = \(local.oxygen)")
    return local
}
func drainOxygenInPlace(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(40)
    print("oxygen = \(snapshot.oxygen)")
}
print("1 Copy")
var original = CrewSnapshot.rookie(named: "Dana")
var copy = original
print("original = \(original.oxygen), copy = \(copy.oxygen)")
copy.breathe(30)
copy.move(to: .lab)
print("original = \(original.oxygen) on \(original.deck), copy = \(copy.oxygen) on \(copy.deck)")


print("no inout")
print("before call, original = \(original.oxygen)")
let returned = drainOxygen(original)
print("after call, original = \(original.oxygen), returned = \(returned.oxygen)")

print("inout function")
print("before call, original = \(original.oxygen)")
drainOxygenInPlace(&original)
print("after call, original = \(original.oxygen)")


// MARK: Level 4 · The Teleport Pod

// 4.1
final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    deinit {
        print("deinit \(id)")
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        guard occupant == nil, chargeLevel >= 20 else { return false }
        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        guard let person = occupant, chargeLevel >= 20 else { return nil }
        chargeLevel -= 20
        occupant = nil
        return person
    }
}

// 4.2 · Charge ledger: load+fire three times, then fire an empty pod

let pod = TeleportPod(id: "P-1", chargeLevel: 100)
for name in ["Timur", "Dana", "Nurlan"] {
    for member in crewRoster where member.name == name {
        let loaded = pod.load(member)
        let fired = pod.fire()
        print("\(name): loaded \(loaded), fired \(fired != nil), charge \(pod.chargeLevel)")
    }
}
_ = pod.fire()
print("empty fire: charge \(pod.chargeLevel)")
let C = pod.chargeLevel


// 4.3 · Reference-semantics demonstration

let podRef = pod
podRef.chargeLevel = 5
print("pod: \(pod.chargeLevel), podRef: \(podRef.chargeLevel)")
var snapA = crewRoster[0]
var snapB = snapA
snapB.oxygen = 1
print("snapA: \(snapA.oxygen), snapB: \(snapB.oxygen)")

// MARK: Level 5 · Station Systems

// 5.1
final class Station {
    let callSign: String
    var hullIntegrity: Int = 100 {
        willSet {
            print("hull: \(hullIntegrity) -> \(newValue)")
        }
        didSet {
            if hullIntegrity > 100 {
                hullIntegrity = 100
            } else if hullIntegrity < 0 {
                hullIntegrity = 0
            }
        }
    }
    var oxygenByDeck: [Deck: Int] = [:]
    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        return "diagnostics for \(callSign): all decks scanned"
    }()

    var totalOxygen: Int {
        var total = 0
        for value in oxygenByDeck.values {
            total += value
        }
        return total
    }

    var averageOxygen: Int {
        get {
            if oxygenByDeck.count == 0 { return 0 }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for deck in oxygenByDeck.keys {
                oxygenByDeck[deck] = newValue
            }
        }
    }

    init(callSign: String) {
        self.callSign = callSign
        for reading in deckReadings {
            if let deck = Deck(rawValue: reading.deck) {
                oxygenByDeck[deck] = reading.oxygen
            }
        }
    }
}

let station = Station(callSign: "ALMA-7")
let B = station.averageOxygen
print("start average: \(B), total: \(station.totalOxygen)")
print("before diagnostics")
print(station.fullDiagnostics)
print(station.fullDiagnostics)
station.averageOxygen = 70
print("new average: \(station.averageOxygen)")


// 5.2 · The clamp trap: 130, then -40, then 55

station.hullIntegrity = 130
print("hull: \(station.hullIntegrity)")
station.hullIntegrity = -40
print("hull: \(station.hullIntegrity)")
station.hullIntegrity = 55
print("hull: \(station.hullIntegrity)")

// MARK: Level 6 · Incident Reports
// Three of these compile and are wrong. One does not compile.
// For each: expectation, actual behaviour, the language rule, the fix.


// Report 1 fixed
var roster = crewRoster
for i in roster.indices {
    roster[i].oxygen -= 10
}
print("report 1: \(roster[0].oxygen)")

// Report 2 fixed
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = TeleportPod(id: "A", chargeLevel: podA.chargeLevel)
podB.chargeLevel = 0
print("report 2: \(podA.chargeLevel)")

// Report 3 fixed
struct Logbook {
    var entries: [String] = []
    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}
var logbook = Logbook()
logbook.add("test")
print("report 3: \(logbook.entries.count)")

// Report 4 fixed
var snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40
let podB4 = TeleportPod(id: "B", chargeLevel: 50)
podB4.chargeLevel = 10
print("report 4: \(snapshot.oxygen), \(podB4.chargeLevel)")



// MARK: Level 7 · Sealing the Black Box

final class FlightRecorder {
    private var entries: [String] = []
    private(set) var isSealed = false

    var count: Int {
        return entries.count
    }

    var transcript: String {
        var result = ""
        var number = 1
        for line in entries {
            result += "#\(number): \(line)\n"
            number += 1
        }
        return result
    }

    func add(_ entry: String) {
        if isSealed { return }
        entries.append(entry)
    }

    func seal() {
        isSealed = true
    }

    fileprivate func rawLines() -> [String] {
        return entries
    }
}

func auditTranscript(of recorder: FlightRecorder) -> String {
    var result = ""
    for line in recorder.rawLines() {
        result += "> \(line)\n"
    }
    return result
}

let recorder = FlightRecorder()
recorder.add("teleporter online")
recorder.add("crew transferred")
recorder.seal()
recorder.add("late entry")
print("entries: \(recorder.count), sealed: \(recorder.isSealed)")
print(recorder.transcript)
print(auditTranscript(of: recorder))


// MARK: Finale · Integrity Code

let D = AlarmLevel.level(forTotalMass: A).rawValue
let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("INTEGRITY CODE: \(integrityCode)")


// MARK: Bonus

var keeper: TeleportPod?
do {
    let temp = TeleportPod(id: "T-1", chargeLevel: 50)
    keeper = temp
    print("inside block")
}
print("after block")
keeper = nil
print("after keeper = nil")

func samePod(_ a: TeleportPod, _ b: TeleportPod) -> Bool {
    return a === b
}
let twin = TeleportPod(id: "P-1", chargeLevel: 5)
print("same: \(samePod(pod, podRef)), twin: \(samePod(pod, twin))")



// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why did CrewSnapshot get an initializer for free and TeleportPod did not?

 2. What does `mutating` do to self, and why do classes never need it?

 3. In Report 4 both values are `let`. What exactly does `let` freeze for a
    struct, and what does it freeze for a class?

 4. Why must a lazy property be var? When does lazy change behaviour, not
    just performance?

 5. private vs fileprivate: where in your FlightRecorder would private be
    too strict?

 Bonus. On which line does deinit fire, and why can't === be used on
 CrewSnapshot?

*/
