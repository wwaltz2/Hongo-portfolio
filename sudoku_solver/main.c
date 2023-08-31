#include "solver.h"

int main(){
    int sudoku_1[9][9];
    int sudoku_2[9][9];
    int sudoku_3[9][9];
    int sudoku_4[9][9];
    int sudoku_5[9][9];;


    parse("sudoku.txt",sudoku_1);
    solve_1(sudoku_1);
    printf("One possible solution:\n");
    print(sudoku_1);

    parse("sudoku.txt",sudoku_2);
    solve_2(sudoku_2);

    parse("sudoku.txt",sudoku_3);
    solve_3(sudoku_3);

    parse("sudoku.txt",sudoku_4);
    solve_4(sudoku_4);

    /*parse("sudoku.txt",sudoku_5);
    printf("One other possible sudoku solve:\n");
    solve_5(sudoku_5);
    print(sudoku_5);*/

    if(same_sudoku(sudoku_1,sudoku_2) == 0){
        printf("One other possible sudoku solve:\n");
        print(sudoku_2);
    }

    if((same_sudoku(sudoku_1,sudoku_3)==0) && (same_sudoku(sudoku_2,sudoku_3)==0)){
        printf("One other possible sudoku solve:\n");
        print(sudoku_3);
    }
    if((same_sudoku(sudoku_1,sudoku_4)==0) && (same_sudoku(sudoku_2,sudoku_4)==0) && (same_sudoku(sudoku_3,sudoku_4)==0)){
        printf("One other possible sudoku solve:\n");
        print(sudoku_4);
    }
    return 0;
}