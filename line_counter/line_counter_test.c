// toudache is a cipher created by Poj E.M. Hammersly 
// It mimics the act of typing on a QWERTY keyboard while typing on a typical iPhone/iPad symbols keyboard.

#include <stdio.h>

char toudache[105] = "E3e3T5t5A-a-I8i8N!n!O9o9S/s/H$h$R4r4D:d:L\"l\"U7u7C,c,M'm'F;f;W2w2Y6y6G(g(P0p0B!b!V?v?K@k@Q1q1J&j&X.x.Z.z."; //this is the list of letters in order of frequency in english

int getLetter(char c){
    int i = 0;
    while(i < 104){
        if(toudache[i]==c) return i;
        i++;
    }
    return 0;
}

int main(){
    //get user input 
    char input[200];
    char output[400];
    printf("Input message to be translated into/from Toudache: \n");
    scanf("%[^\n]s", input);
    printf("%s",input);

    //iterate through each character in the string
    int i,j = 0;
    while(input[i]!='\0'){
        if(input[i] == ' '){
            output[j] = ' ';
            output[j+1] = ' ';
            j+=2;
            i++;
        }
        else{
            int letter = getLetter(input[i]);
            output[j] = toudache[letter+1];
            i++;
            j++;
        }
    }

    printf("\nTranslated message: %s\n", output);
    return 0;
}
