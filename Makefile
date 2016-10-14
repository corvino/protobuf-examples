.PHONY: all cpp clean

SOURCES=$(wildcard objc_runtime/*.m) $(wildcard objc_runtime/google/protobuf/*.m)
#OBJECTS=$(SOURCES:.m=.o)

all: cpp objc

# %.o : %.m
# 	cc -c -Iobjc_runtime -o $@ $^

cpp: add_person_cpp list_people_cpp
objc: GPBProtocolBuffers.o add_person_objc list_people_objc

clean:
	rm -f app_person_cpp list_people_cpp
	rm -f app_person_objc list_people_objc
	rm -f protoc_middleman
	rm -f GPBProtocolBuffers.o

protoc_middleman: addressbook.proto
	protoc --cpp_out=. --objc_out=. --swift_out=. addressbook.proto
	@touch protoc_middleman

GPBProtocolBuffers.o: $(SOURCES)
	clang -c protobuf/objectivec/GPBProtocolBuffers.m -o GPBProtocolBuffers.o -Iprotobuf/objectivec

add_person_cpp: add_person.cc protoc_middleman
	pkg-config --cflags protobuf  # fails if protobuf is not installed
	c++ add_person.cc addressbook.pb.cc -o add_person_cpp `pkg-config --cflags --libs protobuf`

list_people_cpp: list_people.cc protoc_middleman
	pkg-config --cflags protobuf  # fails if protobuf is not installed
	c++ list_people.cc addressbook.pb.cc -o list_people_cpp `pkg-config --cflags --libs protobuf`

add_person_objc: add_person.m GPBProtocolBuffers.o protoc_middleman
	clang -framework Foundation GPBProtocolBuffers.o add_person.m Addressbook.pbobjc.m -o add_person_objc -Iprotobuf/objectivec

list_people_objc: list_people.m GPBProtocolBuffers.o protoc_middleman
	clang -framework Foundation GPBProtocolBuffers.o list_people.m Addressbook.pbobjc.m -o list_people_objc -Iprotobuf/objectivec
