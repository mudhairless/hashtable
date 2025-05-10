#include once "hashtable/common.bi"

#ifndef HASHTABLE_UDT_BI__
#define HASHTABLE_UDT_BI__

    '' Macro: DECLARE_HASHTABLE
    ''
    # macro DECLARE_HASHTABLE(T_)
    :
        type HashTableEntry_##T_
            as string key
            as T_ ptr value
            as ulong hash

            declare operator let ( byref x as HashTableEntry_##T_ )

        end type

        ''Type: HashTableIterator(type)
        ''This is a prototype for a subroutine for iterating through a hashtable.
        type HashTableIterator_##T_ as sub ( byref key as const string, byval value as T_ ptr )

        '' Class: HashTable(T_)
        '' Simple to use but powerful HashTable overloaded for all built-in numerical types.
        ''
        ''Notes:
        ''This class also supports UDTs.
        ''The requirements for UDTs are:
        ''* A default constructor.
        ''* Operator let.
        ''* Operator = (equality).
        ''If you are experiencing a large number of collisions, you should increase the size of the hashtable.
        ''
        type HashTable_##T_
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
            declare sub Insert ( byref key_ as string, byref value as T_ )

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
            declare operator [] ( byref key_ as string ) as T_ ptr

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
            declare function Find ( byref key_ as string ) as T_ ptr

            ''Function: Find
            ''Searches for a value in the table and returns its key.
            ''
            ''Parameters:
            ''value - the value to search for.
            ''
            ''Returns:
            ''ptr to String containing the key associated with a value or "" if the value was not found.
            ''
            declare function Find ( byval value as const T_ ptr ) as string

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
            declare sub ForEach ( byval iter as HashTableIterator_##T_ )

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
            declare operator let ( byref x as HashTable_##T_ )
        'private:
            declare sub m_Expand ( )
            declare sub m_Insert ( byval thash as uinteger, byval index as uinteger, byref key_ as string, byref value as T_ )

            m_tableLength       as uinteger
            m_entryCount        as uinteger
            m_loadLimit         as uinteger
            m_primeIndex        as uinteger
            m_table             as HashTableEntry_##T_ ptr
            m_max_load_factor   as single

        end type
    :
    # endmacro

    # macro DEFINE_HASHTABLE(T_)
    :
        '' :::::
        operator HashTableEntry_##T_.let ( byref x as HashTableEntry_##T_ )
            this.key = x.key
            this.value = x.value
            this.hash = x.hash
        end operator

        '' :::::
        operator HashTable_##T_.let( byref x as HashTable_##T_ )

            this.m_tableLength = x.m_tableLength : x.m_tableLength = 0
            this.m_entryCount = x.m_entryCount : x.m_entryCount = 0
            this.m_loadLimit = x.m_loadLimit : x.m_loadLimit = 0
            this.m_primeIndex = x.m_primeindex : x.m_primeindex = 0
            this.m_table = x.m_table : x.m_table = null

        end operator

        '' :::::
        property HashTable_##T_.Count ( ) as uinteger

            return m_entryCount

        end property

        '' :::::
        constructor HashTable_##T_ ( byval minsize as uinteger, byval max_load_factor as single = 0.65f )

            m_max_load_factor = max_load_factor
            dim as uinteger pindex = 0, size = fbe.m_HTprimes(0)

            if (minsize < (1 shl 30)) then

                while pindex < fbe.prime_table_length
                    if (fbe.m_HTprimes(pindex) > minsize) then
                        size = fbe.m_HTprimes(pindex)
                        exit while

                    end if

                pindex += 1
                wend

            this.m_table = new HashTableEntry_##T_ [size]
            this.m_tablelength = size
            this.m_primeIndex = pindex
            this.m_entryCount = 0
            this.m_loadLimit = cuint(size * max_load_factor)

            end if

        end constructor

        '' :::::
        constructor HashTable_##T_ ( )

            constructor(97)

        end constructor

        '' :::::
        destructor HashTable_##T_ ( )
            for n as uinteger = 0 to m_tablelength - 1

                if m_table[n].value <> null then
                    delete m_table[n].value
                end if

            next
            
            delete[] m_table
            

        end destructor

        '' :::::
        sub HashTable_##T_.m_Expand ( )

            if m_primeIndex < (fbe.prime_table_length -1) then

                m_primeIndex += 1
                var newsize = fbe.m_HTprimes(m_primeIndex)
                var newtable = new HashTableEntry_##T_ [newsize]

                if newtable <> null then

                    var index = 0
                    while index < m_tablelength -1
                        if m_table[index].hash <> null then
                            var newindex = fbe.m_indexFor(m_table[index].hash, newsize)
                            newtable[newindex] = m_table[index]
                        end if
                    index += 1
                    wend

                    memcpy( newtable, m_table, m_entryCount * sizeof( HashTableEntry_##T_ ) )
                    delete[] m_table
                    m_table = newtable
                    m_tablelength = newsize
                    m_loadLimit = cuint(newsize * m_max_load_factor)
                end if
            end if

        end sub

        '' :::::
        sub HashTable_##T_.m_Insert( byval thash as uinteger, byval index as uinteger, byref key_ as string, byref value as T_ )

            var cindex = index +1

            while cindex<= m_tablelength

                if m_table[cindex].value = null then
            
                    m_table[cindex].value = new T_
            
                end if

                if m_table[cindex].key = "" then
                    m_table[cindex].key = key_
                    *(m_table[cindex].value) = value
                    m_table[cindex].hash = thash
                    m_entryCount += 1
                    return
                end if

            cindex += 1

            wend

            if index >= 2 then
                cindex = index - 2
            else
                return
            end if

            while cindex >= 0

                if m_table[cindex].value = null then
            
                    m_table[cindex].value = new T_
            
                end if

                if m_table[cindex].key = "" then
                    m_table[cindex].key = key_
                    *(m_table[cindex].value) = value
                    m_table[cindex].hash = thash
                    m_entryCount += 1
                end if

                if cindex > 0 then cindex -= 1

            wend

        end sub

        '' :::::
        sub HashTable_##T_.Insert ( byref key_ as string, byref value as T_ )

            if (m_entryCount + 1 > m_loadLimit) then
                m_Expand()
            end if

            var thash = fbe.m_HThash(key_)
            var index = fbe.m_indexFor(thash, m_tablelength)

            if m_table[index].value = null then
        
                m_table[index].value = new T_
        
                m_table[index].key = key_
                *(m_table[index].value) = value
                m_table[index].hash = thash
                m_entryCount += 1
            else
                if m_table[index].key = "" then
                    m_table[index].key = key_
                    *(m_table[index].value) = value
                    m_table[index].hash = thash
                    m_entryCount += 1
                else
                    if m_table[index].key = key_ then
                        return
                    end if

                    m_Insert(thash, index, key_, value)
                end if
            end if


        end sub

        function HashTable_##T_.Has (byref key_ as string) as boolean
            return this.Find(key_) <> null
        end function

        Operator HashTable_##T_.[] (byref key_ as string ) as T_ ptr
            return this.Find(key_)
        end operator

        '' :::::
        function HashTable_##T_.Find ( byref key_ as string ) as T_ ptr

            var shash = fbe.m_HThash(key_)
            var index = fbe.m_indexFor(shash, m_tablelength)

            if (shash = m_table[index].hash)  then return m_table[index].value
            if (shash = m_table[index+1].hash)  then return m_table[index+1].value
            if (shash = m_table[index+2].hash)  then return m_table[index+2].value

            return null


        end function

        '' :::::
        function HashTable_##T_.Find ( byval value as const T_ ptr ) as string

            var retval = ""

            for n as uinteger = 0 to m_tablelength -1

                if m_table[n].value <> null then

                    if *value = *(m_table[n].value) then
                        retval = m_table[n].key
                        exit for
                    end if

                end if

            next

            return retval

        end function

        '' :::::
        sub HashTable_##T_.ForEach ( byval iter as HashTableIterator_##T_ )

            for n as uinteger = 0 to m_tablelength -1
                if m_table[n].hash <> 0 then iter(m_table[n].key, m_table[n].value)
            next


        end sub

        '' :::::
        sub HashTable_##T_.Remove ( byref key_ as string )

            var shash = fbe.m_HThash(key_)
            var index = fbe.m_indexFor(shash, m_tablelength)

            while index <= m_tablelength

                if (shash = m_table[index].hash) AND (key_ = m_table[index].key) then
                    m_table[index].hash = 0
                    m_table[index].key = ""
                    m_entryCount -= 1
            
                    delete m_table[index].value
                    m_table[index].value = null
            
                    return

                end if

                index += 1

            wend

            index = fbe.m_indexFor(shash, m_tablelength)

            if (index > 0) then

                for m as uinteger = index to 1 step -1

                    if (shash = m_table[m].hash) AND (key_ = m_table[m].key) then
                        m_table[m].hash = 0
                        m_table[m].key = ""
                        m_entryCount -= 1
                        delete m_table[m].value
                        m_table[m].value = null
                        return

                    end if

                next
            end if
            if (shash = m_table[0].hash) AND (key_ = m_table[0].key) then
                m_table[0].hash = 0
                m_table[0].key = ""
                m_entryCount -= 1
                delete m_table[0].value
                m_table[0].value = null
                return

            end if

        end sub
    :
    # endmacro

# endif ' include guard
