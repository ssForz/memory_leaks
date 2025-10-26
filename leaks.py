import time
import numpy as np
import sys

data = []
data_size = sys.getsizeof(data)

while True:
    data.append(np.random.rand(1000, 1000))
    current_alloc = 1000 * 1000 * 8
    data_size += current_alloc
    print(f'Total allocated: ~{(data_size / (1024 * 1024)):.3f} MB')
    time.sleep(2)

