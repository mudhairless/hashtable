# include once "hashtable.bi"

#macro assert_true(x)
    if ((x) = true) then
        print __FUNCTION__ & " " & #x & " is working"
    else 
        print __FUNCTION__ & " " & #x & " is NOT working"
    end if
#endmacro

private sub test_insert_count

	var ht = HashTable_integer(15)

	for n as integer = 1 to 15
		assert_true( ht.count = (n-1) )

		ht.Insert( "Test" & space(n) & n, n )

		assert_true( ht.count = n )
	next

end sub

private sub test_collisions

	var ht = HashTable_integer(15)

	ht.Insert("Testing1", 42)
	ht.Insert("Testing2", 32)

	assert_true( ht.count = 2 )

	assert_true(ht.Has("Testing1"))
	
	ht.Insert("Testing1", 12)

	assert_true( *ht["Testing1"] <> 12 )

	assert_true( ht.count = 2 )

end sub

private sub test_verify_bykey

	var ht = HashTable_integer(15)

	for n as integer = 1 to 15

		ht.Insert( "Test" & space(n) & n, n )

	next

	for n as integer = 1 to 15

		var x = *ht.Find( "Test" & space(n) & n )

		assert_true( n = x )

	next

	assert_true( null = ht.Find("libHashTable Rocks") )

end sub

private sub test_verify_byval

	var ht = HashTable_integer(15)

	for n as integer = 1 to 15

		ht.Insert( "Test" & space(n) & n, n )

	next

	var y = 0

	for n as integer = 1 to 15

		y = n

		dim as string x = ht.Find( @y )

		assert_true( x = "Test" & space(n) & n)

	next

	y = 16

	assert_true( "" = ht.Find(@y) )

end sub

	
test_insert_count()
test_verify_bykey()
test_verify_byval()
test_collisions()


