# include once "hashtable.bi"

type PersonInfo
    ' HashTable element values must be publically default-constructible
    ' and copy-assignable.
    declare constructor
    declare operator let ( byref x as const PersonInfo )

    ' This constructor is not necessary for HashTable usage
    declare constructor ( byref address as const string, byval age as integer )
    
    address as string
    age as integer
end type

constructor PersonInfo ( )
end constructor

operator PersonInfo.let ( byref x as const PersonInfo )
    this.address = x.address
    this.age = x.age
end operator

constructor PersonInfo ( byref address as const string, byval age as integer )
    this.address = address
    this.age = age
end constructor

' ext.HashTable element values must also be publically equality comparable.
operator = ( byref lhs as const PersonInfo, byref rhs as const PersonInfo ) as integer

    return (lhs.age = rhs.age) and (lhs.address = rhs.address)

end operator

' First we declare the HashTable for our custom type, this could be in a header file. 
' The result will be a type named (in this case) HashTable_PersonInfo
DECLARE_HASHTABLE(PersonInfo)

' Create a hashtable with a minimize size of 10 elements.
var people = HashTable_PersonInfo(10)

people.Insert("John Doe", PersonInfo("1234 Lyfindafast Lane", 16))
people.Insert("Jane Doe", PersonInfo("5678 Nofrickin Way", 53))

var p = people.Find("John Doe")
ASSERT( p <> null )
print "John Doe, " & p->age & " of " & p->address & "."

p = people.Find("Waldo")
ASSERT( p = null )

people.Remove("John Doe")
p = people.Find("John Doe")
ASSERT( p = null )

'Lastly we need to define the functions for our custom HashTable
'This will need to see the definition of the HashTable, you can either just include
'the header file you DECLARE_HASHTABLE in or put a DECLARE_HASHTABLE in the same file
DEFINE_HASHTABLE(PersonInfo)