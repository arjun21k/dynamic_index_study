import os
import sys

def main():
    filename = sys.argv[1]

    with open(filename, "r", errors="ignore") as file:
        prefix = ""
        del_count = 0
        for line in file:
            if prefix == "":
                if "Delete Phase" in line:
                    prefix = "Delete"
                    del_count += 1
                elif "Insert Phase" in line:
                    prefix = "Insert"
                elif "Patch Phase: Start" in line:
                    prefix = "Patch"
            
            if " 100 " in line:
                temp = line.split()
                temp.pop(0)
                temp = ",".join(temp)
                temp = "," + temp
                if prefix == "Delete":
                    print(str(del_count) + "," + prefix + temp)     
                else:
                    print("," + prefix + temp)
                prefix = ""


if __name__ == "__main__":
    main()
