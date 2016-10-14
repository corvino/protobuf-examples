import Foundation

if 2 != CommandLine.argc {
    print("Usage:  \(CommandLine.argc) \(CommandLine.arguments[0])")
    exit(-1)
}

let data = NSData(contentsOfFile: CommandLine.arguments[1]) as! Data
let addressBook = try Tutorial_AddressBook(protobuf: data)

for person in addressBook.person {
    print("Person ID: \(person.id)")
    print("  Name: \(person.name)")
    if let email = person.email {
        print("  E-mail address: \(email)")
    }

    for number in person.phone {
        guard let type = number.type else { continue; }
        switch type {
        case .mobile:
            print("  Mobile phone #: ", separator: "", terminator: "")
        case .home:
            print("  Home phone #: ", separator: "", terminator: "")
        case .work:
            print("  Work phone #: ", separator: "", terminator: "")
        }
        print(number.number)
    }
}
