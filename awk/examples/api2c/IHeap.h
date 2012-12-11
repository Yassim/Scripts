
//
// Heap Interface 'c style'
//
#include <stdlib.h>

/////////////////////////////////////////////
// CODE GENORATED BY AN AWK SCRIPT 
// appox
// cmd> awk -f api2c.awf IHeap.api_def
/////////////////////////////////////////////

//
// Macros - if not already defined
//
#ifndef HEADER_CODE
#define HEADER_CODE static
#endif//HEADER_CODE

//
// Types -- Forward declarations
//
typedef struct IHeap_t IHeap_t;
typedef struct IHeapVTable_t IHeapVTable_t;

//
// Types -- Real declarations
//
//
// The Base Type
//
struct IHeap_t {
	IHeapVTable_t * VTable; // Must Be First
};

//
// The VTable
//
struct IHeapVTable_t {
	void  	( * ptm_Destroy )	( IHeap_t * _this_ );
	void *	( * ptm_Alloc )  	( IHeap_t * _this_, size_t numBytes );
	void *	( * ptm_ReAlloc )	( IHeap_t * _this_, void * ptr, size_t numBytes );
	void  	( * ptm_Free )   	( IHeap_t * _this_, void * ptr );
};

//
// Helper comment to Copy N Past
//
/*****************************************
*** START Implimentation base for a 'foo' IHeap
******************************************
typedef struct foo_IHeap_t foo_IHeap_t;

struct foo_IHeap_t {
	IHeapVTable_t * VTable;  // Must Be First
//
// foo's members here
//
};

static void foo_Destroy ( IHeap_t * _this_ )
{
	foo_IHeap_t * this = ( foo_IHeap_t * ) _this_; 
	
}

static void * foo_Alloc ( IHeap_t * _this_, size_t numBytes )
{
	foo_IHeap_t * this = ( foo_IHeap_t * ) _this_; 
	return 0;
}

static void * foo_ReAlloc ( IHeap_t * _this_, void * ptr, size_t numBytes )
{
	foo_IHeap_t * this = ( foo_IHeap_t * ) _this_; 
	return 0;
}

static void foo_Free ( IHeap_t * _this_, void * ptr )
{
	foo_IHeap_t * this = ( foo_IHeap_t * ) _this_; 
	
}

static const IHeapVTable_t imp_foo = {
	foo_Destroy,
	foo_Alloc,
	foo_ReAlloc,
	foo_Free
};

IHeap_t * foo_Init( foo_IHeap_t * this )
{
	this->VTable = &imp_foo;
//
// foo's init here
//
	return ( IHeap_t * ) this;
}

IHeap_t * foo_New() 
{
	return foo_Init( (foo_IHeap_t *) malloc( sizeof( foo_IHeap_t ) ) );
}
*****************************************
*** END Implimentation base for a 'foo' IHeap
******************************************/

//
// Helper functions to use the base, and invoke the vtable
//
HEADER_CODE void IHeap_Destroy ( IHeap_t * _this_ )
{
	( _this_->VTable->ptm_Destroy )	( _this_ );
}

HEADER_CODE void * IHeap_Alloc ( IHeap_t * _this_, size_t numBytes )
{
	return ( _this_->VTable->ptm_Alloc )	( _this_, numBytes );
}

HEADER_CODE void * IHeap_ReAlloc ( IHeap_t * _this_, void * ptr, size_t numBytes )
{
	return ( _this_->VTable->ptm_ReAlloc )	( _this_, ptr, numBytes );
}

HEADER_CODE void IHeap_Free ( IHeap_t * _this_, void * ptr )
{
	( _this_->VTable->ptm_Free )	( _this_, ptr );
}

