#import <Foundation/Foundation.h>
#import "Addressbook.pbobjc.h"

NSString* ReadString()
{
    size_t size = 0;
    char *str = NULL;
    getline(&str, &size, stdin);
    if (str && strcmp("\n", str)) {
        return [[NSString stringWithUTF8String:str] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    }
    free(str);
    return nil;
}

Person* PromptForAddress()
{
    Person *person = [[Person alloc] init];
    printf("Enter person ID number: ");
    int personID;
    scanf("%d", &personID);
    getchar();
    person.id_p = personID;

    printf("Enter name: ");
    NSString *name = ReadString();
    if (name) {
        person.name = name;
    }

    printf("Enter email address (blank for none): ");
    NSString *email = ReadString();
    if (email) {
        person.email = email;
    }

    while (true) {
        printf("Enter a phone number (or leave blank to finish): ");
        NSString *number = ReadString();
        if (!number) {
            break;
        }

        Person_PhoneNumber *phoneNumber = [[Person_PhoneNumber alloc] init];
        phoneNumber.number = number;
        printf("Is this a mobile, home, or work phone? ");
        NSString *type = ReadString();
        if ([@"mobile" isEqualToString:type]) {
            phoneNumber.type = Person_PhoneType_Mobile;
        } else if ([@"home" isEqualToString:type]) {
            phoneNumber.type = Person_PhoneType_Home;
        } else if ([@"work" isEqualToString:type]) {
            phoneNumber.type = Person_PhoneType_Work;
        } else {
            printf("Unknown phone type.  Using default.\n");
        }
        [person.phoneArray addObject:phoneNumber];
    }

    return person;
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (2 != argc) {
            printf("Usage:  %d %s\n", argc, argv[0]);
            return -1;
        }

        NSString *fileName = [NSString stringWithFormat:@"%s", argv[1]];
        NSData *data = [NSData dataWithContentsOfFile:fileName];
        NSError *error;
        AddressBook *addressBook = [[AddressBook alloc] initWithData:data error:&error];

        if (error) {
            printf("Failed to parse address book.\n");
            return -1;
        }

        Person *person = PromptForAddress();
        [addressBook.personArray addObject:person];

        if (![addressBook.data writeToFile:fileName atomically:YES]) {
            printf("Failed to write address book.\n");
            return -1;
        }
    }
    return 0;
}
