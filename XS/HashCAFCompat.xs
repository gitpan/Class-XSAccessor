#include "ppport.h"

#include "cxsa_util_macros.h"

MODULE = Class::XSAccessor        PACKAGE = Class::XSAccessor
PROTOTYPES: DISABLE


void
array_setter_init(self, ...)
    SV* self;
  ALIAS:
  INIT:
    /* NOTE: This method is for Class::Accessor compatibility only. It's not
     *       part of the normal API! */
    /* Get the const hash key struct from the global storage */
    /* ix is the magic integer variable that is set by the perl guts for us.
     * We uses it to identify the currently running alias of the accessor. Gollum! */
    SV* newvalue = NULL; /* squelch may-be-used-uninitialized warning that doesn't apply */
    SV ** hashAssignRes;
    const autoxs_hashkey readfrom = CXSAccessor_hashkeys[ix];
  PPCODE:
    CXA_CHECK_HASH(self);
    CXAH_OPTIMIZE_ENTERSUB(array_setter);
    if (items == 2) {
      newvalue = newSVsv(ST(1));
    }
    else if (items > 2) {
      I32 i;
      AV* tmp = newAV();
      av_extend(tmp, items-1);
      for (i = 1; i < items; ++i) {
        newvalue = newSVsv(ST(i));
        if (!av_store(tmp, i-1, newvalue)) {
          SvREFCNT_dec(newvalue);
          croak("Failure to store value in array");
        }
      }
      newvalue = newRV_noinc((SV*) tmp);
    }
    else {
      croak_xs_usage(cv, "self, newvalue(s)");
    }

    if ((hashAssignRes = hv_store((HV*)SvRV(self), readfrom.key, readfrom.len, newvalue, readfrom.hash))) {
      PUSHs(*hashAssignRes);
    }
    else {
      SvREFCNT_dec(newvalue);
      croak("Failed to write new value to hash.");
    }

void
array_setter(self, ...)
    SV* self;
  ALIAS:
  INIT:
    /* NOTE: This method is for Class::Accessor compatibility only. It's not
     *       part of the normal API! */
    /* Get the const hash key struct from the global storage */
    /* ix is the magic integer variable that is set by the perl guts for us.
     * We uses it to identify the currently running alias of the accessor. Gollum! */
    SV* newvalue = NULL; /* squelch may-be-used-uninitialized warning that doesn't apply */
    SV ** hashAssignRes;
    const autoxs_hashkey readfrom = CXSAccessor_hashkeys[ix];
  PPCODE:
    CXA_CHECK_HASH(self);
    if (items == 2) {
      newvalue = newSVsv(ST(1));
    }
    else if (items > 2) {
      I32 i;
      AV* tmp = newAV();
      av_extend(tmp, items-1);
      for (i = 1; i < items; ++i) {
        newvalue = newSVsv(ST(i));
        if (!av_store(tmp, i-1, newvalue)) {
          SvREFCNT_dec(newvalue);
          croak("Failure to store value in array");
        }
      }
      newvalue = newRV_noinc((SV*) tmp);
    }
    else {
      croak_xs_usage(cv, "self, newvalue(s)");
    }

    if ((hashAssignRes = hv_store((HV*)SvRV(self), readfrom.key, readfrom.len, newvalue, readfrom.hash))) {
      PUSHs(*hashAssignRes);
    }
    else {
      SvREFCNT_dec(newvalue);
      croak("Failed to write new value to hash.");
    }

void
array_accessor_init(self, ...)
    SV* self;
  ALIAS:
  INIT:
    /* NOTE: This method is for Class::Accessor compatibility only. It's not
     *       part of the normal API! */
    /* Get the const hash key struct from the global storage */
    /* ix is the magic integer variable that is set by the perl guts for us.
     * We uses it to identify the currently running alias of the accessor. Gollum! */
    SV ** hashAssignRes;
    const autoxs_hashkey readfrom = CXSAccessor_hashkeys[ix];
  PPCODE:
    CXA_CHECK_HASH(self);
    CXAH_OPTIMIZE_ENTERSUB(array_accessor);
    if (items == 1) {
      SV** svp;
      if ((svp = CXSA_HASH_FETCH((HV *)SvRV(self), readfrom.key, readfrom.len, readfrom.hash)))
        PUSHs(*svp);
      else
        XSRETURN_UNDEF;
    }
    else { /* writing branch */
      SV* newvalue;
      if (items == 2) {
        newvalue = newSVsv(ST(1));
      }
      else { /* items > 2 */
        I32 i;
        AV* tmp = newAV();
        av_extend(tmp, items-1);
        for (i = 1; i < items; ++i) {
          newvalue = newSVsv(ST(i));
          if (!av_store(tmp, i-1, newvalue)) {
            SvREFCNT_dec(newvalue);
            croak("Failure to store value in array");
          }
        }
        newvalue = newRV_noinc((SV*) tmp);
      }

      if ((hashAssignRes = hv_store((HV*)SvRV(self), readfrom.key, readfrom.len, newvalue, readfrom.hash))) {
        PUSHs(*hashAssignRes);
      }
      else {
        SvREFCNT_dec(newvalue);
        croak("Failed to write new value to hash.");
      }
    } /* end writing branch */

void
array_accessor(self, ...)
    SV* self;
  ALIAS:
  INIT:
    /* NOTE: This method is for Class::Accessor compatibility only. It's not
     *       part of the normal API! */
    /* Get the const hash key struct from the global storage */
    /* ix is the magic integer variable that is set by the perl guts for us.
     * We uses it to identify the currently running alias of the accessor. Gollum! */
    SV ** hashAssignRes;
    const autoxs_hashkey readfrom = CXSAccessor_hashkeys[ix];
  PPCODE:
    CXA_CHECK_HASH(self);
    if (items == 1) {
      SV** svp;
      if ((svp = CXSA_HASH_FETCH((HV *)SvRV(self), readfrom.key, readfrom.len, readfrom.hash)))
        PUSHs(*svp);
      else
        XSRETURN_UNDEF;
    }
    else { /* writing branch */
      SV* newvalue;
      if (items == 2) {
        newvalue = newSVsv(ST(1));
      }
      else { /* items > 2 */
        I32 i;
        AV* tmp = newAV();
        av_extend(tmp, items-1);
        for (i = 1; i < items; ++i) {
          newvalue = newSVsv(ST(i));
          if (!av_store(tmp, i-1, newvalue)) {
            SvREFCNT_dec(newvalue);
            croak("Failure to store value in array");
          }
        }
        newvalue = newRV_noinc((SV*) tmp);
      }

      if ((hashAssignRes = hv_store((HV*)SvRV(self), readfrom.key, readfrom.len, newvalue, readfrom.hash))) {
        PUSHs(*hashAssignRes);
      }
      else {
        SvREFCNT_dec(newvalue);
        croak("Failed to write new value to hash.");
      }
    } /* end writing branch */

void
_newxs_compat_setter(name, key)
  char* name;
  char* key;
  PPCODE:
    /* WARNING: If this is called in your code, you're doing it WRONG! */
    INSTALL_NEW_CV_HASH_OBJ(name, CXAH(array_setter_init), key);

void
_newxs_compat_accessor(name, key)
  char* name;
  char* key;
  PPCODE:
    /* WARNING: If this is called in your code, you're doing it WRONG! */
    INSTALL_NEW_CV_HASH_OBJ(name, CXAH(array_accessor_init), key);

