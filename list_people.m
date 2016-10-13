#import <Foundation/Foundation.h>
#import "Addressbook.pbobjc.h"

void ListPeople(AddressBook *addressBook)
{
    for (Person *person in addressBook.personArray) {
        printf("Person ID: %d\n", person.id_p);
        printf("  Name: %s\n", person.name.UTF8String);
        if (person.hasEmail) {
            printf("  E-mail address: %s\n", person.email.UTF8String);
        }

        for (Person_PhoneNumber *phoneNumber in person.phoneArray) {
            switch (phoneNumber.type) {
                case Person_PhoneType_Mobile:
                    printf("  Mobile phone #: ");
                    break;
                case Person_PhoneType_Home:
                    printf("  Home phone #: ");
                    break;
                case Person_PhoneType_Work:
                    printf("  Work phone #: ");
                    break;
            }
            printf("%s\n", phoneNumber.number.UTF8String);
        }
    }
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (2 != argc) {
            printf("Usage:  %d %s\n", argc, argv[0]);
            return -1;
        }

        NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%s", argv[1]]];
        NSError *error;
        AddressBook *addressBook = [[AddressBook alloc] initWithData:data error:&error];

        if (error) {
            printf("Failed to parse address book.\n");
            return -1;
        }

        ListPeople(addressBook);
    }
    return 0;
}
