import sys

def main():
    if len(sys.argv) < 2:
        #print("Too few command-line arguments")
        sys.exit("Too few command-line arguments")
    if len(sys.argv) > 2:
        #print("Too many command-line arguments")
        sys.exit("Too many command-line arguments")
    
    file_name = sys.argv[1].split('.')
    count_lines = 0
    with open(sys.argv[1], "r") as file:
            lines = file.readlines()


    if file_name[1] == "py":                  #lines-of-code counter for python
        for line in lines:
            line = line.lstrip()
            if line == "":
                continue
            if line.startswith("#"):
                continue
            count_lines +=1

    elif file_name[1] == "c" or file_name[1] == "h":
        for line in lines:
            line = line.lstrip()
            if line == "":
                continue
            if line.startswith("//"):
                continue
            if line.startswith('}'):
                continue
            #add a condition to skip counting lines between /* and */
            count_lines +=1
    
    else:
        for line in lines:
            line = line.lstrip()
            if line == "":
                continue
            count_lines += 1

    file.close()
    print("Lines:", count_lines)
    return count_lines

main()
