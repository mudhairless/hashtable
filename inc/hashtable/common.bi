#ifndef null
#define null cast(any ptr, 0)
#endif 

namespace fbe

const as uinteger prime_table_length = 25

declare function m_IndexFor ( byval hashvalue as uinteger, byval tablelength as uinteger ) as uinteger
declare function m_HTprimes( byval index as uinteger ) as uinteger
declare function m_HThash( byref key_ as const string ) as ulong
declare function joaat overload ( byref xStr as const string ) as ulong
declare function joaat overload ( byval src__ as const any ptr, byval len_b as uinteger, byval seed as ulong = 0 ) as ulong

end namespace

#include once "crt/string.bi"