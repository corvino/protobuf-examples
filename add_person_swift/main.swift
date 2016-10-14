import Foundation

if 2 != CommandLine.argc {
    print("Usage:  \(CommandLine.argc) \(CommandLine.arguments[0])\n")
    exit(-1)
}

let data = try NSData(contentsOfFile: CommandLine.arguments[1]) as Data
var addressBook = try Tutorial_AddressBook(protobuf: data)

var person = Tutorial_Person()

print("Enter person ID number: ", separator: "", terminator: "")
guard let idString = readLine(strippingNewline: true) else { exit(-1) }
guard let id = Int32(idString) else { exit(-1) }
person.id = id

print("Enter name: ", separator: "", terminator: "")
let name = readLine(strippingNewline: true)
if let name = name {
    person.name = name
}

print("Enter email address (blank for none): ", separator: "", terminator: "")
let email = readLine(strippingNewline: true)
if let email = email {
    person.email = email
}

while true {
    print("Enter a phone number (or leave blank to finish: ", separator: "", terminator: "");
    guard let number = readLine(strippingNewline: true) else { break; }
    guard 0 < number.characters.count else { break; }

    var phoneNumber = Tutorial_Person.PhoneNumber()
    phoneNumber.number = number

    print("Is this a mobile, home, or work phone? ", separator: "", terminator: "")
    if let type = readLine(strippingNewline: true) {
        switch type {
        case "mobile":
            phoneNumber.type = .mobile
        case "home":
            phoneNumber.type = .home
        case "work":
            phoneNumber.type = .work
        default:
            print("Unknown phone type.  Using default.")
        }
    }
    person.phone.append(phoneNumber)
}

addressBook.person.append(person)
let output = try addressBook.serializeProtobuf() as NSData
output.write(toFile: CommandLine.arguments[1], atomically: true)
