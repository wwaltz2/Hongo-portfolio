main: main.c solver.c
	g++ -g -c solver.c -o solver.o
	g++ -g -c main.c -o main.o
	g++ -g main.o solver.o -o main

clean:
	rm *.o main

sudoku:
	./main sudoku.txt