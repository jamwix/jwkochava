#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include <stdio.h>
#include "JWKochava.h"


using namespace jwkochava;

static value jwkochava_init (value options) {
    jwkInit(val_string(options));
	return alloc_null();
}
DEFINE_PRIM (jwkochava_init, 1);

static value jwkochava_identity_link (value options) {
    jwkIdentityLink(val_string(options));
	return alloc_null();
}
DEFINE_PRIM (jwkochava_identity_link, 1);

static value jwkochava_track_event (value title, value sValue) {
    jwkTrackEvent(val_string(title), val_string(sValue));
	return alloc_null();
}
DEFINE_PRIM (jwkochava_track_event, 2);

static value jwkochava_get_kochava_id() 
{
    return alloc_string(jwkKochavaId());
}
DEFINE_PRIM (jwkochava_get_kochava_id, 0);

extern "C" void jwkochava_main () {
	
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (jwkochava_main);

extern "C" int jwkochava_register_prims () { return 0; }
