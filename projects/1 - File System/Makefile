run: build
	./tema

build:
	gcc *.c -g -o tema

valgrind: build
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./tema

pack:
	zip -r 321CA_StroeTeodora_Tema1.zip *.c *.h Makefile README

clean:
	rm tema

checker:
	python3 checker.py

.PHONY: build clean