# include once "hashtable.bi"

var myHT = HashTable_integer(16)

print "Count before insertion: " & myHT.count

print !"Inserting \"One\" as 1"
myHT.insert("One", 1)

print !"Inserting \"Two\" as 2"
myHT.insert("Two", 2)

print !"Inserting \"Three\" as 3"
myHT.insert("Three", 3)

print !"Inserting \"Tacos\" as 4"
myHT.insert("Tacos", 4)

print !"Inserting \"libHashTable\" as 5"
myHT.insert("libHashTable", 5)

print "Count after insertion: " & myHT.count

print "One: " & *(myHT["One"])

print "Removing Tacos"
myHT.remove("Tacos")

print "Two: " & *(myHT["Two"])

print "Removing Three"
myHT.remove("Three")

print "libHashTable: " & *(myHT["libHashTable"])

print "Count after 2 removes: " & myHT.count
