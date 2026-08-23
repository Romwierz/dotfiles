#!/usr/bin/env python3

# Increment/decrement the index in the filenames passed as arguments.

import argparse
from sys import argv, exit
from subprocess import call
from operator import concat

filename = ''
index = ''
filename_bare = ''
desc = 'Increment/decrement the index in the filenames passed as arguments.'
files = []
exit_code = 0

parser = argparse.ArgumentParser(description=desc) 
parser.add_argument("file", nargs='+') 
parser.add_argument("-d", action="store_true", help="decrement the index") 
parser.add_argument("-g", action="store_true", help="use 'git mv' instead of 'mv'") 
parser.add_argument("-n", "--dry-run", action="store_true", help="print changes without running the move command") 

args = parser.parse_args() 
files = args.file

for filename in files:
    # Get index from filename (number at the beginning of filename's ended with dot)
    # and filename without index (string after dot)
    index = filename.split('.', 1)[0]
    filename_bare = filename.split('.', 1)[1]

    # Increment/decrement index
    if args.d:
        index = int(index) - 1
    else:
        index = int(index) + 1

    # Concatenate incremented index with not-indexed filename and print operation info
    result = concat(f"{index:02d}.", filename_bare)
    print(filename, '->', result)
    if args.dry_run:
        continue

    # Change filename
    if args.g:
        exit_code = call(['git', 'mv', filename, str(result)])
    else:
        exit_code = call(['mv', filename, str(result)])

exit(exit_code)
