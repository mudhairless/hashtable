''Copyright (c) 2025, Ebben Feagan
''Copyright (c) 2007-2024, FreeBASIC Extended Library Development Group
''
'' All rights reserved.
''
'' Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
''
''  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
''  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
''  * Neither the name of the copyright holders nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
''
'' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
'' "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
'' LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
'' A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
'' CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
'' EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
'' PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
'' PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
'' LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
'' NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
'' SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include once "hashtable/double.bi"
#include once "crt/string.bi"
using fbe

'' :::::
operator HashTableEntry_double.let ( byref x as HashTableEntry_double )
    this.key = x.key
    this.value = x.value
    this.hash = x.hash
end operator

'' :::::
operator HashTable_double.let( byref x as HashTable_double )

    this.m_tableLength = x.m_tableLength : x.m_tableLength = 0
    this.m_entryCount = x.m_entryCount : x.m_entryCount = 0
    this.m_loadLimit = x.m_loadLimit : x.m_loadLimit = 0
    this.m_primeIndex = x.m_primeindex : x.m_primeindex = 0
    this.m_table = x.m_table : x.m_table = null

end operator

'' :::::
property HashTable_double.Count ( ) as uinteger

    return m_entryCount

end property

'' :::::
constructor HashTable_double ( byval minsize as uinteger, byval max_load_factor as single = 0.65f )

    this.m_max_load_factor = max_load_factor

    dim as uinteger pindex = 0, size = m_HTprimes(0)

    if (minsize < (1 shl 30)) then

        while pindex < fbe.prime_table_length
            if (m_HTprimes(pindex) > minsize) then
                size = m_HTprimes(pindex)
                exit while

            end if

        pindex += 1
        wend

    this.m_table = new HashTableEntry_double [size]
    this.m_tablelength = size
    this.m_primeIndex = pindex
    this.m_entryCount = 0
    this.m_loadLimit = cuint(size * max_load_factor)

    end if

end constructor

'' :::::
constructor HashTable_double ( )

    constructor(97)

end constructor

'' :::::
destructor HashTable_double ( )

    for n as uinteger = 0 to m_tablelength - 1

        if m_table[n].value <> null then
            delete m_table[n].value

        end if

    next

    delete[] m_table

end destructor

'' :::::
sub HashTable_double.m_Expand ( )

    if m_primeIndex < (fbe.prime_table_length -1) then

        m_primeIndex += 1
        var newsize = m_HTprimes(m_primeIndex)
        var newtable = new HashTableEntry_double [newsize]

        if newtable <> null then

            var index = 0
            while index < m_tablelength -1
                if m_table[index].hash <> null then
                    var newindex = m_indexFor(m_table[index].hash, newsize)
                    newtable[newindex] = m_table[index]
                end if
            index += 1
            wend

            memcpy( newtable, m_table, m_entryCount * sizeof( HashTableEntry_double ) )
            delete[] m_table
            m_table = newtable
            m_tablelength = newsize
            m_loadLimit = cuint(newsize * m_max_load_factor)
        end if
    end if

end sub

'' :::::
sub HashTable_double.m_Insert( byval thash as ulong, byval index as uinteger, byref key_ as string, byref value as double )

    var cindex = index +1

    while cindex<= m_tablelength

        if m_table[cindex].value = null then
            m_table[cindex].value = new double
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
            m_table[cindex].value = new double
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
sub HashTable_double.Insert ( byref key_ as string, byref value as double )

    if (m_entryCount + 1 > m_loadLimit) then
        m_Expand()
    end if

    var thash = m_HThash(key_)
    var index = m_IndexFor(thash, m_tablelength)

    if m_table[index].value = null then
        m_table[index].value = new double
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

function HashTable_double.Has (byref key_ as string) as boolean
    return this.Find(key_) <> null
end function

Operator HashTable_double.[] (byref key_ as string ) as double ptr
    return this.Find(key_)
end operator

'' :::::
function HashTable_double.Find ( byref key_ as string ) as double ptr

    var shash = m_HThash(key_)
    var index = m_IndexFor(shash, m_tablelength)

    if (shash = m_table[index].hash)  then return m_table[index].value
    if (shash = m_table[index+1].hash)  then return m_table[index+1].value
    if (shash = m_table[index+2].hash)  then return m_table[index+2].value

    return null


end function

'' :::::
function HashTable_double.Find ( byval value as const double ptr ) as string

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
sub HashTable_double.ForEach ( byval iter as HashTableIterator_double )

    for n as uinteger = 0 to m_tablelength -1
        if m_table[n].hash <> 0 then iter(m_table[n].key, m_table[n].value)
    next


end sub

'' :::::
sub HashTable_double.Remove ( byref key_ as string )

    var shash = m_HThash(key_)
    var index = m_IndexFor(shash, m_tablelength)

    while index <= m_tablelength

        if (shash = m_table[index].hash) AND (key_ = m_table[index].key) then
            m_table[index].hash = 0
            m_table[index].key = ""
            m_entryCount -= 1
            delete m_table[index].value
            return

        end if

        index += 1

    wend

    index = m_IndexFor(shash, m_tablelength)
    if (index > 0) then

        for m as uinteger = index to 1 step -1

            if (shash = m_table[m].hash) AND (key_ = m_table[m].key) then
                m_table[m].hash = 0
                m_table[m].key = ""
                m_entryCount -= 1
                delete m_table[m].value
                return

            end if

        next
    end if
    if (shash = m_table[0].hash) AND (key_ = m_table[0].key) then
        m_table[0].hash = 0
        m_table[0].key = ""
        m_entryCount -= 1
        delete m_table[0].value
        return

    end if

end sub