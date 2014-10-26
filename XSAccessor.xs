#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "AutoXS.h"

MODULE = Class::XSAccessor		PACKAGE = Class::XSAccessor

void
getter(self)
    SV* self;
  ALIAS:
  INIT:
    /* Get the const hash key struct from the global storage */
    /* ix is the magic integer variable that is set by the perl guts for us.
     * We uses it to identify the currently running alias of the accessor. Gollum! */
    const autoxs_hashkey readfrom = AutoXS_hashkeys[ix];
    HE* he;
  PPCODE:
    /*if (he = hv_fetch_ent((HV *)SvRV(self), readfrom.key, 0, 0)) {*/
    if (he = hv_fetch_ent((HV *)SvRV(self), readfrom.key, 0, readfrom.hash)) {
      XPUSHs(HeVAL(he));
    }
    else {
      XSRETURN_UNDEF;
    }



void
setter(self, newvalue)
    SV* self;
    SV* newvalue;
  ALIAS:
  INIT:
    /* Get the const hash key struct from the global storage */
    /* ix is the magic integer variable that is set by the perl guts for us.
     * We uses it to identify the currently running alias of the accessor. Gollum! */
    const autoxs_hashkey readfrom = AutoXS_hashkeys[ix];
    HE* he;
  PPCODE:
    SvREFCNT_inc(newvalue);
    if (NULL == hv_store_ent((HV*)SvRV(self), readfrom.key, newvalue, readfrom.hash)) {
      croak("Failed to write new value to hash.");
    }
    XSRETURN_UNDEF;


void
newxs_getter(name, key)
  char* name;
  char* key;
  PPCODE:
    char* file = __FILE__;
    const unsigned int functionIndex = get_next_hashkey();
    {
      CV * cv;
      /* This code is very similar to what you get from using the ALIAS XS syntax.
       * Except I took it from the generated C code. Hic sunt dragones, I suppose... */
      cv = newXS(name, XS_Class__XSAccessor_getter, file);
      if (cv == NULL)
        croak("ARG! SOMETHING WENT REALLY WRONG!");
      XSANY.any_i32 = functionIndex;

      /* Precompute the hash of the key and store it in the global structure */
      autoxs_hashkey hashkey;
      const unsigned int len = strlen(key);
      hashkey.key = newSVpvn(key, len);
      PERL_HASH(hashkey.hash, key, len);
      AutoXS_hashkeys[functionIndex] = hashkey;
    }


void
newxs_setter(name, key)
  char* name;
  char* key;
  PPCODE:
    char* file = __FILE__;
    const unsigned int functionIndex = get_next_hashkey();
    {
      CV * cv;
      /* This code is very similar to what you get from using the ALIAS XS syntax.
       * Except I took it from the generated C code. Hic sunt dragones, I suppose... */
      cv = newXS(name, XS_Class__XSAccessor_setter, file);
      if (cv == NULL)
        croak("ARG! SOMETHING WENT REALLY WRONG!");
      XSANY.any_i32 = functionIndex;

      /* Precompute the hash of the key and store it in the global structure */
      autoxs_hashkey hashkey;
      const unsigned int len = strlen(key);
      hashkey.key = newSVpvn(key, len);
      PERL_HASH(hashkey.hash, key, len);
      AutoXS_hashkeys[functionIndex] = hashkey;
    }

