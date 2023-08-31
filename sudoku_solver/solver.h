#include<stdio.h>
#include<stdlib.h>
#include<memory.h>

void parse(const char fpath[], int sudoku[9][9]);

void print(int sudoku[9][9]);

int row_check(const int val, const int i, const int sudoku[9][9]);

int col_check(const int val, const int j, const int sudoku[9][9]);

int grid_check(const int val, const int i, const int j, const int sudoku[9][9]);

int val_check(const int val, const int i, const int j, const int sudoku[9][9]);

int solve_1(int sudoku[9][9]); //solves sudoku from top left

int solve_2(int sudoku[9][9]); //solves sudoku from the bottom right

int solve_3(int sudoku[9][9]); //solves sudoku from the top right

int solve_4(int sudoku[9][9]); //solves sudoku from the bottom left

//int solve_5(int sudoku[9][9]); //solves sudoku from the center

int same_sudoku(int sudoku[9][9], int _sudoku_[9][9]);