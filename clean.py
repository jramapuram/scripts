#!/usr/bin/python
import os
import hashlib

def chunk_reader(fobj, chunk_size=1024):
    """Generator that reads a file in chunks of bytes"""
    while True:
        chunk = fobj.read(chunk_size)
        if not chunk:
            return
        yield chunk
        
def check_for_duplicates(paths, hash=hashlib.sha1):
    hashes = {}
    for path in paths:
        for dirpath, dirnames, filenames in os.walk(path):
            for filename in filenames:
                full_path = os.path.join(dirpath, filename)
                hashobj = hash()
                for chunk in chunk_reader(open(full_path, 'rb')):
                    hashobj.update(chunk)
                file_id = (hashobj.digest(), os.path.getsize(full_path))
                duplicate = hashes.get(file_id, None)
                if duplicate:
                    print "Duplicate found: %s and %s --> removing %s" % (full_path, duplicate, full_path)
                    os.remove(full_path)
                else:
                    hashes[file_id] = full_path

# main
check_for_duplicates(".")
for filename in os.listdir(os.getcwd()):
    if any(c.isupper() for c in filename) or '__' in filename or '-' in filename or ' ' in filename:
        new_name = filename.strip().lower().replace('-', '_').replace(' ', '_').replace('__', '_')
        if os.path.isfile(new_name) and new_name != filename.lower():
            os.remove(new_name)
        print 'filename %s to %s' %(filename, new_name)
        os.rename(filename, new_name)
