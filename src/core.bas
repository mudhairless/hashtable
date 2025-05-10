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

#include once "hashtable/common.bi"

namespace fbe

    '' :::::
    function m_IndexFor ( byval hashvalue as uinteger, byval tablelength as uinteger ) as uinteger

        return (hashvalue mod tablelength) 

    end function

    '' :::::
    function m_HTprimes( byval index as uinteger ) as uinteger

        static as uinteger _primes(0 to 25) = { _
                        53, 97, 193, 389, _
                        769, 1543, 3079, 6151, _
                        12289, 24593, 49157, 98317, _
                        196613, 393241, 786433, 1572869, _
                        3145739, 6291469, 12582917, 25165843, _
                        50331653, 100663319, 201326611, 402653189, _
                        805306457, 1610612741 }
        
        return _primes(index)

    end function

    '' :::::
    function m_HThash( byref key_ as const string ) as ulong

        return joaat("FBE_HASHTABLE" & key_)

    end function

    '' :::::
    function joaat overload ( byref xStr as const string ) as ulong

        return joaat( cast(zstring ptr,strptr(xStr)), len(xStr) )

    end function

    '' :::::
    function joaat overload ( byval src__ as const any ptr, byval len_b as uinteger, byval seed as ulong = 0 ) as ulong

        if (src__ = NULL) or (len_b < 1) then return 0

        var src = cast(const ubyte ptr, src__)
        var hash = seed

        if len_b > 1 then
            for i as uinteger = 0 to (len_b-1)
                hash += src[i]
                hash += (hash shl 10)
                hash xor= (hash shr 6)
            next

        else
            hash += src[0]
            hash += (hash shl 10)
            hash xor= (hash shr 6)

        end if

        hash += (hash shl 3)
        hash xor= (hash shr 11)
        hash += (hash shl 15)

        return hash

    end function

end namespace