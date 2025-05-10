#include once "hashtable/byte.bi"
#include once "hashtable/ubyte.bi"
#include once "hashtable/short.bi"
#include once "hashtable/ushort.bi"
#include once "hashtable/long.bi"
#include once "hashtable/ulong.bi"
#include once "hashtable/integer.bi"
#include once "hashtable/uinteger.bi"
#include once "hashtable/longint.bi"
#include once "hashtable/ulongint.bi"
#include once "hashtable/single.bi"
#include once "hashtable/double.bi"
#include once "hashtable/string.bi"
#include once "hashtable/udt.bi"

#if __FB_MT__
    #inclib "hashtablemt"
#else
    #inclib "hashtable"
#endif