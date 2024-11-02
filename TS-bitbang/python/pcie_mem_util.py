# For ALMA 9 (need to test others)

import os
import mmap
import numpy as np
import sys

class PcieMem:

    def __init__(self, offset, size=0x10000):
        self.offset = offset
        self.size = size
        self.is_little_endian = (sys.byteorder == 'little')  # Detect endianness
        
        try:
            # Open /dev/mem safely
            with os.fdopen(os.open('/dev/mem', os.O_RDWR | os.O_SYNC), 'rb+') as f:
                self.mem = mmap.mmap(f.fileno(), self.size, 
                                     mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE, 
                                     offset=self.offset)
        except OSError as e:
            raise RuntimeError(f"Failed to open /dev/mem: {e}")
        
        # Create read and write arrays with appropriate byte order
        dtype = '>u4' if self.is_little_endian else '<u4'
        # Still working on this part, need to test on other systems
        
        self.readarray = np.frombuffer(self.mem, dtype=dtype)
        self.writearray = np.frombuffer(self.mem, np.uint32, self.size >> 2)

    def wread(self, address):
        idx = address >> 2
        value = self.readarray[idx]
        return value

    def wwrite(self, address, data):
        idx = address >> 2
        arr = np.array([data], dtype=np.uint32)
        
        # Perform byteswap only if the system endianness differs from expected
        if self.is_little_endian:
            arr = arr.byteswap()
        
        self.writearray[idx] = arr[0]

    def close(self):
        """Ensure the memory map is closed properly."""
        # Release references to any arrays that use the memory map
        del self.readarray
        del self.writearray
        
        # Optional: Force garbage collection (if other references are lingering)
        import gc
        gc.collect()
        """Ensure the memory map is closed properly."""
        self.mem.close()
