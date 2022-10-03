				 ____  _____    _    ____  __  __ _____ 
				|  _ \| ____|  / \  |  _ \|  \/  | ____|
				| |_) |  _|   / _ \ | | | | |\/| |  _|
				|  _ <| |___ / ___ \| |_| | |  | | |___ 
				|_| \_\_____/_/   \_\____/|_|  |_|_____|

					Stroe Teodora 321CA 2021

# TASK 1
- uses a loop to create each element in ciphertext
- retains the i index in EAX and the len - i - 1 index in EBX
- retains plaintext[i] in AL and key[len - i - 1] in BL
- computes xor and stores result in ciphertext[i]

# TASK 2
- computes age for each person
  - if the year's difference is 0, puts 0 in the result vector
  - compares months and days if necessary
  - if the age is not reached, it is decremented
- puts correct age in the result vector and continues iteration through
  the dates vector

# TASK 3
- computes the number of rows of the matrix and stores the value in the 
  corresponding variable
- checks if the position is within the boundaries of the haystack string
  and if so, the correct element is put in ciphertext
- the counters are increased:
  - the row counter is increased and the boundary check is performed
  - if the row counter is greater than the number of rows in the matrix,
    the column counter is increased, the row counter is set to 0, and
    the boundary check is performed

# TASK 4
- computes tag and offset and stores them in the corresponding variables
- iterates through the tags vector
    - if the current tag is found in it, it's a CACHE HIT situation
    - it not, it is a CACHE MISS situation
    - if it is a CACHE MISS:
      - the tag is put in tags[to_replace]
      - the first octet is computed
      - the ESI register is set on the cache[to_replace] address
      - the program loops 8 times to put x octet in cache[to_replace][x]
      - then enters the CACHE HIT situation
    - if it is a CACHE HIT:
      - the correct element is retrieved from cache
      - it is put in reg
