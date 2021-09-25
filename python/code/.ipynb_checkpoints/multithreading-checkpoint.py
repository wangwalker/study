import math
import timeit
import threading
import multiprocessing
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor

def time_stuff(fn):
    """
    meaures times of executions of a function
    """
    def wrapper(*args, **kwargs):
        t0 = timeit.default_timer()
        fn(*args, **kwargs)
        t1 = timeit.default_timer()
        print("using {} seconds".format(t1-t0))
    return wrapper

def find_primes_in(nmin, nmax):
    """
    Compute a list of prime numbers between the given minimum and maximum arguments
    """
    primes = []

    # Loop from minimum to maximum
    for current in range(nmin, nmax + 1):

        # Take the square root of the current number
        sqrt_n = int(math.sqrt(current))
        found = False

        # Check if the any number from 2 to the square root + 1 divides the current numnber under consideration
        for number in range(2, sqrt_n + 1):

            # If divisible we have found a factor, hence this is not a prime number, lets move to the next one
            if current % number == 0:
                found = True
                break

        # If not divisible, add this number to the list of primes that we have found so far
        if not found:
            primes.append(current)

    # I am merely printing the length of the array containing all the primes, but feel free to do what you want
    # print(len(primes))

@time_stuff
def sequential_prime_finder(nmin, nmax):
    """
    serial execuation
    """
    find_primes_in(nmin, nmax)
    
@time_stuff
def threading_prime_finder(nmin, nmax):
    """
    split the task into 8 subtasks, and each execuated in a Thread
    """
    nrange = nmax - nmin
    threads = []
    for i in range(8):
        start = int(nmin + i * nrange/8)
        end = int(nmin + (i + 1) * nrange/8)
        t = threading.Thread(target=find_primes_in, args=(start, end))
        threads.append(t)
        t.start()
        
    for t in threads:
        t.join()
        
@time_stuff
def processing_prime_finder(nmin, nmax):
    """
    split the task into 8 subtasks, and each execuated in a Process
    """
    nrange = nmax - nmin
    processes = []
    for i in range(8):
        start = int(nmin + i * nrange/8)
        end = int(nmin + (i + 1) * nrange/8)
        p = multiprocessing.Process(target=find_primes_in, args=(start, end))
        processes.append(p)
        p.start()
        
    for p in processes:
        p.join()
        
@time_stuff
def thread_executor_prime_finder(nmin, nmax):
    """
    This way is similar with Thread, but it will be faster than pure Thread.
    Because the ThreadPoolExecutor manage threads more efficiently, and only
    if your machine has multiple cores.
    """
    nrange = nmax - nmin
    with ThreadPoolExecutor(max_workers = 8) as e:
        for i in range(8):
            start = int(nmin + i * nrange/8)
            end = int(nmin + (i + 1) * nrange/8)
            e.submit(find_primes_in, start, end)

@time_stuff
def process_executor_prime_finder(nmin, nmax):
    """
    This way is similar with Process, but it will be faster than pure Process.
    Because the ProcessPoolExecutor manage threads more efficiently, and only
    if your machine has multiple cores.
    """
    nrange = nmax - nmin
    with ProcessPoolExecutor(max_workers = 8) as e:
        for i in range(8):
            start = int(nmin + i * nrange/8)
            end = int(nmin + (i + 1) * nrange/8)
            e.submit(find_primes_in, start, end)

def main():
    nmin = int(1e5)
    nmax = int(1e6)

    print("sequential starting...")
    sequential_prime_finder(nmin, nmax)
    
    print("threading starting...")
    threading_prime_finder(nmin, nmax)
    
    print("process starting...")
    processing_prime_finder(nmin, nmax)

    print("thread executor starting...")
    thread_executor_prime_finder(nmin, nmax)
    
    print("process executor starting...")
    process_executor_prime_finder(nmin, nmax)
    
if __name__ == "__main__":
    main()

"""
results likes:
sequential starting...
using 6.6786787610000005 seconds
threading starting...
using 6.669680029 seconds
process starting...
using 4.066703888000001 seconds
thread executor starting...
using 6.688873083000001 seconds
process executor starting...
using 4.111865375000001 seconds
"""