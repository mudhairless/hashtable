#include once "hashtable/common.bi"

type HashTableEntry_ushort
    as string key
    as ushort ptr value
    as ulong hash

    declare operator let ( byref x as HashTableEntry_ushort )

end type

''Type: HashTableIterator(type)
''This is a prototype for a subroutine for iterating through a hashtable.
type HashTableIterator_ushort as sub ( byref key as const string, byval value as ushort ptr )

'' Class: HashTable_T
'' Simple to use but powerful HashTable overloaded for all built-in numerical types.
''
type HashTable_ushort
public:

    declare constructor ( )
    ''Sub: constructor
    ''Defines an initial size for the hashtable. When necessary the HashTable will expand itself to ensure enough room for proper operation.
    ''
    ''Parameters:
    ''minsize - the MINIMUM size of table to create, the actual table size could be larger.
    ''
    declare constructor ( byval minsize as uinteger, byval max_load_factor as single = 0.65f )

    ''Sub: Insert
    ''Inserts a value into the hashtable.
    ''
    ''Parameters:
    ''key_ - the string key to associate with the value.
    ''value - the value to insert into the table.
    ''
    ''Usage:
    ''It is very important that you REMOVE a value with a key that would overlap another. If the key is already
    ''located in the table, the value will NOT be overwritten.
    ''
    declare sub Insert ( byref key_ as string, byref value as ushort )

    ''Function: Has
    ''Test if the hashtable contains the specified key.
    ''
    ''Parameters:
    ''key_ - the string key to search the hashtable for
    ''
    ''Returns:
    ''boolean True if the key was found otherwise False
    ''
    declare function Has (byref key_ as string) as boolean

    ''Operator: []
    ''Alias for Find(key)
    declare operator [] ( byref key_ as string ) as ushort ptr

    ''Function: Find
    ''Searches for a key in the table.
    ''
    ''Parameters:
    ''key_ - the key to search for.
    ''
    ''Returns:
    ''A pointer to value associated with the passed key. This value is NOT removed from the table.
    ''If the key is not found then the returned pointer will be null.
    ''
    declare function Find ( byref key_ as string ) as ushort ptr

    ''Function: Find
    ''Searches for a value in the table and returns its key.
    ''
    ''Parameters:
    ''value - the value to search for.
    ''
    ''Returns:
    ''ptr to String containing the key associated with a value or "" if the value was not found.
    ''
    declare function Find ( byval value as const ushort ptr ) as string

    ''Sub: ForEach
    ''Iterates through the table calling the passed subroutine with each key pair.
    ''
    ''Parameters:
    ''iter - the address of the subroutine to call, this subroutine is of the type HashTableIterator(type).
    ''
    ''Notes:
    ''You may freely change the value passed to the subroutine, but you may not change the key.
    ''To change the key you must remove the current key from the table and insert a new one.
    ''
    ''See Also:
    ''<Simple HashTable Iterator example>
    ''
    declare sub ForEach ( byval iter as HashTableIterator_ushort )

    ''Function: Remove
    ''Searches for a key in the table and removes it.
    ''
    ''Parameters:
    ''key_ - the key to search for.
    ''
    declare sub Remove ( byref key_ as string )

    ''Property: Count
    ''Returns the number of key pairs in the table.
    ''
    declare property Count ( ) as uinteger
    declare destructor ( )
    declare operator let ( byref x as HashTable_ushort )
'private:
    declare sub m_Expand ( )
    declare sub m_Insert ( byval thash as ulong, byval index as uinteger, byref key_ as string, byref value as ushort )

    m_tableLength       as uinteger
    m_entryCount        as uinteger
    m_loadLimit         as uinteger
    m_primeIndex        as uinteger
    m_table             as HashTableEntry_ushort ptr
    m_max_load_factor   as single

end type