#!/usr/bin/env python3
import sys
import pefile # pip install pefile

IMAGE_DLL_CHARACTERISTICS_DYNAMIC_BASE = 0x40
filename = sys.argv[1]
pe = pefile.PE(filename)
has_aslr = bool(pe.OPTIONAL_HEADER.DllCharacteristics & IMAGE_DLL_CHARACTERISTICS_DYNAMIC_BASE)

print('This file %s ASLR' % ('has' if has_aslr else 'has not'))

if has_aslr:
	pe.OPTIONAL_HEADER.DllCharacteristics ^= IMAGE_DLL_CHARACTERISTICS_DYNAMIC_BASE
	pe.write(filename='%s.noaslr.%s' % (filename[:-4], filename[-3:]))
