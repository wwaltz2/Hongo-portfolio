# this short program is an encoder and decoder for a cipher I recieved from a
# UW-Madison student, and I named the program file accordingly
#
# USE RESPONSIBLY!!!

def main():
    inp = input("(E)ncode or (D)ecode? ").lower()
    if inp == 'e':
        encode()
    elif inp == 'd':
        decode()
    else:
        main()
    #quit

def encode():
    inp = input("Enter plaintext: ")
    outp = ''
    vowel_val = ''
    first_const = ''
    ptr_first_vowel = 0
    for c in range(len(inp)):
        if inp[c] == 'a' or inp[c] == 'e' or inp[c] == 'i' or inp[c] == 'o' or inp[c] == 'u' or inp[c] == 'y' or inp[c] == 'A' or inp[c] == 'E' or inp[c] == 'I' or inp[c] == 'O' or inp[c] == 'U' or inp[c] == 'Y': #vowels move to the right by 1 position
            if ptr_first_vowel == 0:
                ptr_first_vowel = c + 1
                vowel_val = inp[c]
                b = c
                while b < len(inp):
                    if inp[b] == 'a' or inp[b] == 'e' or inp[b] == 'i' or inp[b] == 'o' or inp[b] == 'u' or inp[b] == 'y' or inp[b] == 'A' or inp[b] == 'E' or inp[b] == 'I' or inp[b] == 'O' or inp[b] == 'U' or inp[b] == 'Y' :
                        last_vowel_val = inp[b]
                    b += 1
                if inp[c].islower():
                    outp += last_vowel_val.lower()
                else:
                    outp += last_vowel_val.upper()
            else:
                if inp[c].islower():
                    outp += vowel_val.lower()
                else:
                    outp += vowel_val.upper()
                vowel_val = inp[c]
        elif inp[c].isalpha(): #consonants move to the left by 1 position
            if first_const == '':
                first_const = inp[c]
            b = c
            while True:
                b += 1
                if b >= len(inp):
                    if inp[c].islower():
                        outp += first_const.lower()
                    else:
                        outp += first_const.upper()
                    break
                elif inp[b].isalpha() and inp[b] != 'a' and inp[b] != 'e' and inp[b] != 'i' and inp[b] != 'o' and inp[b] != 'u' and inp[b] != 'y' and inp[b] != 'A' and inp[b] != 'E' and inp[b] != 'I' and inp[b] != 'O' and inp[b] != 'U' and inp[b] != 'Y':
                    if inp[c].islower():
                        outp += inp[b].lower()
                    else:
                        outp += inp[b].upper()
                    break
        else:
            outp += inp[c]
    print(outp)
    #quit

def decode():
    inp = input("Enter ciphertext: ")
    outp = ''
    const_val = ''
    first_vowel = ''
    ptr_first_const = 0
    for c in range(len(inp)):
        if inp[c] == 'a' or inp[c] == 'e' or inp[c] == 'i' or inp[c] == 'o' or inp[c] == 'u' or inp[c] == 'y' or inp[c] == 'A' or inp[c] == 'E' or inp[c] == 'I' or inp[c] == 'O' or inp[c] == 'U' or inp[c] == 'Y': #vowels move to the left by 1 position
            if first_vowel == '':
                first_vowel = inp[c]
            b = c
            while True:
                b += 1
                if b >= len(inp):
                    if inp[c].islower():
                        outp += first_vowel.lower()
                    else:
                        outp += first_vowel.upper()
                    break
                elif inp[b] == 'a' or inp[b] == 'e' or inp[b] == 'i' or inp[b] == 'o' or inp[b] == 'u' or inp[b] == 'y' or inp[b] == 'A' or inp[b] == 'E' or inp[b] == 'I' or inp[b] == 'O' or inp[b] == 'U' or inp[b] == 'Y' :
                    if inp[c].islower():
                        outp += inp[b].lower()
                    else:
                        outp += inp[b].upper()
                    break


        elif inp[c].isalpha(): #consonants move to the right by 1 position
            if ptr_first_const == 0:
                ptr_first_const = c + 1
                const_val = inp[c]
                b = c + 1
                while b < len(inp):
                    if inp[b].isalpha() and inp[b] != 'a' and inp[b] != 'e' and inp[b] != 'i' and inp[b] != 'o' and inp[b] != 'u' and inp[b] != 'y' and inp[b] != 'A' and inp[b] != 'E' and inp[b] != 'I' and inp[b] != 'O' and inp[b] != 'U' and inp[b] != 'Y':
                        last_const_value = inp[b]
                    b += 1
                if inp[c].islower():
                    outp += last_const_value.lower()
                else:
                    outp += last_const_value.upper()
            else:
                if inp[c].islower():
                    outp += const_val.lower()
                else:
                    outp += const_val.upper()
                const_val = inp[c]


        else:
            outp += inp[c]
            
    print(outp)
    #quit

main()
