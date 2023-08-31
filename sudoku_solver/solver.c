#include "solver.h"

//3x3 GRID DOES NOT WORK

//scans each character in sudoku.txt into sudoku
void parse(const char fpath[], int sudoku[9][9]){ 
    FILE*reader = fopen(fpath, "r");
    int i,j;
    for(i=0;i<9;i++){
        for(j=0;j<9;j++){
            fscanf(reader, "%d", &sudoku[i][j]);
        }
    }
    fclose(reader);
}

//print the solved sudoku to the command terminal
//PRINT THEM AS DIFFERENT COLORS!!!!!
void print(int sudoku[9][9]){
    int i,j;
    for(i=0;i<9;i++){
        for(j=0;j<9;j++){
            printf("%2d", sudoku[i][j]);
        }
        printf("\n");
    }
}

int row_check(const int val, const int i, const int sudoku[9][9]){
    int x = 0;
    for(int j=0;j<9;j++){
        if(sudoku[i][j]==val){
            return 1; //if the value exists in the row, return true
        }
    }
    return 0; //else, return false
}

int col_check(const int val, const int j, const int sudoku[9][9]){
    int x = 0;
    for(int i=0;i<9;i++){
        if(sudoku[i][j]==val){
            return 1; //if the value exists in the row, return true
        }
    }
    return 0; //else, return false
}

int grid_check(const int val, const int i, const int j, const int sudoku[9][9]){
    int cell,count,x,y = 0;
    if(i>=3 && i<=5){ //if the grid is in the second column
        cell++;
    }
    if(i>=6 && i<=8){ //if the grid is in the third column
        cell+=2;
    }
    if(j>=3 && j<=5){ //if the grid is in the second row
        cell+=3;
    }
    if(j>=6 && j<=8){ //if the grid is in the third row
        cell+=6;
    }
    if(cell==0){
        for(x=0;x<=2;x++){
            for(y=0;y<=2;y++){
                if(sudoku[x][y]==val){
                    return 1;
                }
            }
        }
    }
    if(cell==1){
        for(x=3;x<=5;x++){
            for(y=0;y<=2;y++){
                if(sudoku[x][y]==val){
                    return 1;
                }
            }
        }
    }
    if(cell==2){
        for(x=6;x<=8;x++){
            for(y=0;y<=2;y++){
                if(sudoku[x][y]==val){
                    return 1;
                }
            }
        }
    }
    if(cell==3){
        for(x=0;x<=2;x++){
            for(y=3;y<=5;y++){
                if(sudoku[x][y]==val){
                    return 1;
                }
            }
        }
    }
    if(cell==4){
        for(x=3;x<=5;x++){
            for(y=3;y<=5;y++){
                if(sudoku[x][y]==val){
                    return 1;
                }
            }
        }
    }
    if(cell==5){
        for(x=6;x<=8;x++){
            for(y=3;y<=5;y++){
                if(sudoku[x][y]==val){
                    return 1;
                }
            }
        }
    }
    if(cell==6){
        for(x=0;x<=2;x++){
            for(y=6;y<=8;y++){
                if(sudoku[x][y]==val){
                    return 1;
                }
            }
        }
    }
    if(cell==7){
        for(x=3;x<=5;x++){
            for(y=6;y<=8;y++){
                if(sudoku[x][y]==val){
                    return 1;
                }
            }
        }
    }
    if(cell==8){
        for(x=6;x<=8;x++){
            for(y=6;y<=8;y++){
                if(sudoku[x][y]==val){
                    return 1;
                }
            }
        }
    }
    return 0;
}

int val_check(const int val, const int i, const int j, const int sudoku[9][9]){
    if(row_check(val,i,sudoku)==0 && col_check(val,j,sudoku)==0 && grid_check(val,i,j,sudoku)==0){
        return 1;
    }
    return 0;
}

//solves from the top right of the grid
int solve_1(int sudoku[9][9]){
    int i,j,x,y,count=0;
    for(x=0;x<9;x++){
        for(y=0;y<9;y++){
            if(sudoku[x][y]==0){
                count++;
                i=x;
                j=y;
            }
        }
    }
    if(count==0){
        //print(sudoku);
        return 1;
    }
    for(int val=1;val<=9;val++){
        //printf(" "); //why does it only work when i have a print function in the middle of the solve
        if(val_check(val,i,j,sudoku)==1){
            sudoku[i][j] = val;
            //print(sudoku);
            if(solve_1(sudoku)==1){
                return 1;
            }
            sudoku[i][j] = 0;
            //printf(" "); // this one does NOT fix it
            //print(sudoku); //this one does
        }
    }
    return 0;
}

//solves from the bottom left of the grid
int solve_2(int sudoku[9][9]){
    int i,j,x,y,count=0;
    for(x=8;x>=0;x--){
        for(y=8;y>=0;y--){
            if(sudoku[x][y]==0){
                count++;
                i=x;
                j=y;
            }
        }
    }
    if(count==0){
        //print(sudoku);
        return 1;
    }
    for(int val=1;val<=9;val++){
        //printf(" "); //why does it only work when i have a print function in the middle of the solve
        if(val_check(val,i,j,sudoku)==1){
            sudoku[i][j] = val;
            //print(sudoku);
            if(solve_1(sudoku)==1){
                return 1;
            }
            sudoku[i][j] = 0;
            //printf(" "); // this one does NOT fix it
            //print(sudoku); //this one does
        }
    }
    return 0;
}

//solves from the top right of the grid
int solve_3(int sudoku[9][9]){
    int i,j,x,y,count=0;
    for(x=8;x>=0;x--){
        for(y=0;y<9;y++){
            if(sudoku[x][y]==0){
                count++;
                i=x;
                j=y;
            }
        }
    }
    if(count==0){
        //print(sudoku);
        return 1;
    }
    for(int val=1;val<=9;val++){
        //printf(" "); //why does it only work when i have a print function in the middle of the solve
        if(val_check(val,i,j,sudoku)==1){
            sudoku[i][j] = val;
            //print(sudoku);
            if(solve_1(sudoku)==1){
                return 1;
            }
            sudoku[i][j] = 0;
            //printf(" "); // this one does NOT fix it
            //print(sudoku); //this one does
        }
    }
    return 0;
}

//solves from the bottom left of the grid
int solve_4(int sudoku[9][9]){
    int i,j,x,y,count=0;
    for(x=0;x<9;x++){
        for(y=8;y>=0;y--){
            if(sudoku[x][y]==0){
                count++;
                i=x;
                j=y;
            }
        }
    }
    if(count==0){
        //print(sudoku);
        return 1;
    }
    for(int val=1;val<=9;val++){
        //printf(" "); //why does it only work when i have a print function in the middle of the solve
        if(val_check(val,i,j,sudoku)==1){
            sudoku[i][j] = val;
            //print(sudoku);
            if(solve_1(sudoku)==1){
                return 1;
            }
            sudoku[i][j] = 0;
            //printf(" "); // this one does NOT fix it
            //print(sudoku); //this one does
        }
    }
    return 0;
}

/*//SOLVES FROM THE MIDDLE OF THE GRID!
int solve_5(int sudoku[9][9]){
    int i,j,x,y,count=0;
    for(x=0;x<9;x++){
        for(y=0;y<9;y++){
            if(sudoku[x][y]==0){
                count++;
                i=x;
                j=y;
            }
        }
    }
    if(count==0){
        //print(sudoku);
        return 1;
    }
    for(int val=1;val<=9;val++){
        //printf(" "); //why does it only work when i have a print function in the middle of the solve
        if(val_check(val,i,j,sudoku)==1){
            sudoku[i][j] = val;
            //print(sudoku);
            if(solve_1(sudoku)==1){
                return 1;
            }
            sudoku[i][j] = 0;
            //printf(" "); // this one does NOT fix it
            //print(sudoku); //this one does
        }
    }
    return 0;
}*/

int same_sudoku(int sudoku[9][9], int _sudoku_[9][9]){
    int x = 0;
    for(int i=0;i<9;i++){
        for(int j=0;j<9;j++){
            if(sudoku[i][j] == _sudoku_[i][j]){
                x++;
            }
        }
    }
    if(x==81){
        return 1;
    }
    return 0;
}