Copyright Teodora Stroe 321CA 2022

## Task1

For each element in the array, the array is traversed from beginning to end, until the
_successor_ of the current element is found and the _next_ of the current element is set.
At the end, the array is traversed again to find the head of the chained list.

## Task 2

### CMMMC

The cmmdc of the two numbers is calculated and then the formula **cmmmc = a * b / cmmdc** is applied.

### Parenthesis

For each element in the string, one of the following actions is executed:

* If the element is an open parenthesis, it is placed on the stack.
* If the element is a closed parenthesis:
    * Checks if the stack is not already empty;
    * Removes the last element from the stack and check if it is an open parenthesis.
    
    Otherwise, the brackets are placed incorrectly.

At the end, it is tested if the stack is empty.

## Task 3

**strtok** is called on the given string and a string of delimiters to split the word into tokens. Each token is inserted into the array of words.

To sort the vector of words, **qsort** is called, having as arguments the vector of words,
the number of words, the size of a word and the comparison function.

The **comparison** function calls **strlen** on two received words to find their lengths.
Compares the words by length and, if they are equal, compares them lexicographically
using **strcmp**.

## Task 4

* word1 -- the part of the string located **before** the separator
* word2 -- the part of the string located **after** the separator

To check if a separator is inside the parentheses a *counter* is used,
which is incremented when it meets "(" and is decremented when it meets ")". If the counter
is 0 when the separator is encountered, it is not inside the brackets.

**strlen** is used to compute the length of strings.

### Expression

In the given string, from end to beginning, the first + or - that is not between parentheses is searched for. Then
**expression(word1)** and **term(word2)** are called. If there is no separator, it is called
**term(string)**.

### Term

In the but string, the first * or / that is not between parentheses is searched for, from the end to the beginning. Then
**term(word1)** and **factor(word2)** are called. If there is no separator, it is called
**factor(string)**.

### Factor

If the given string starts with an open parenthesis, it means that it is an expression, so the string is selected
between the brackets and **expression(new_string)** is called.

Otherwise, the given string is a number and **atoi(string)** is used to return its numeric value.