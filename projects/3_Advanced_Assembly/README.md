Copyright Teodora Stroe 321CA 2022

# README

## Task1

Pentru fiecare element din array, se parcurge array-ul de la inceput pana la sfarsit, pana se gaseste
succesorul elementului curent si se seteaza next-ul. La final, se parcurge din nou array-ul pentru a
se gasi capul listei inlantuite.

## Task 2

### CMMMC

Se calculeaza cmmdc al celor doua numere si apoi se aplica formula **cmmmc = a * b / cmmdc**.

### Paranteze

Pentru fiecare element din string se executa una din urmatoarele actiuni:

* Daca elementul este o paranteza deschisa, se pune pe stiva.
* Daca elementul este o paranteza inchisa:
    * Se verifica daca stiva nu este deja goala;
    * Se scoate ultimul element de pe stiva si se verifica daca acesta este o paranteza deschisa.
    
    In caz contrar, parantezele sunt puse gresit.

La final se testeaza daca stiva este goala.

## Task 3

Se apeleaza **strtok** pe string-ul dat si un string de delimitatori pentru a desparti cuvantul in
tokeni. Fiecare token se introduce in array-ul de cuvinte.

Pentru a sorta vectorul de cuvinte, se apeleaza **qsort**, avand ca argumente vectorul de cuvinte,
numarul de cuvinte, dimensiunea unui cuvant si functia de comparare.

**Functia de comparare** apeleaza **strlen** pe doua cuvinte primite pentru a le afla lungimile.
Compara cuvintele dupa lungime si, in cazul in care acestea sunt egale, le compara lexicografic
utilizand **strcmp**.

## Task 4

* cuvant1 -- partea de string situata **inaintea** separatorului
* cuvant2 -- partea din string situata **dupa** separator

Pentru a se verifica daca un separator se afla in interiorul parantezelor se foloseste un *counter*,
care este incrementat cand se intalneste "(" si este decrementat la intalnirea ")". Daca counter-ul
este 0 in momentul intalnirii separatorului, acesta nu se afla in interiorul parantezelor.

Pentru calcularea lungimii sirurilor se utilizeaza **strlen**.

### Expresie

In sirul dat, se cauta, de la sfarsit spre inceput, primul + sau - care nu este intre paranteze. Apoi
se apeleaza **expression(cuvant1)** si **term(cuvant2)**. Daca nu exista niciun separator, se apeleaza
**term(string)**.

### Termen

In sirul dar, se cauta, de la sfarsit spre inceput, primul * sau / care nu este intre paranteze. Apoi
se apeleaza **term(cuvant1)** si **factor(cuvant2)**. Daca nu exista niciun separator, se apeleaza
**factor(string)**.

### Factor

Daca sirul dat incepe cu o paranteza deschisa inseamna ca este o expresie, deci se selecteaza string-ul
dintre paranteze si se apeleaza **expression(noul_string)**.

Altfel, sirul dat este un numar si se foloseste **atoi(string)** pentru a returna valoarea numerica a 
cestuia.