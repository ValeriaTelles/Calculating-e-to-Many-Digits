import numpy as np
import os.path
from os import path

def getFilename():
    # prompt the user for a filename for the output
    fname = input("Enter the filename you wish to store the value of e: ")
     
    # check if the file exists
    if path.exists(fname) == True:
        # if the file exists, ask the user if they would like to overwrite
        ans = input("Warning: This file already exists. Would you like to overwrite? [Y/N] ")
        if ans == 'Y':
            print("Writing to", fname)
        elif ans == 'N':
            fname = getFilename()
        else:
            print("Error: Invalid response.")
            fname = getFilename()
    else:
        print("Writing to", fname)
    
    return fname
        
def keepe(n):
    m = 4
    d = [0] * n
    test = (n+1)*2.30258509

    while m*(np.log(m)-1.0) + 0.5*np.log(6.2831852*m) < test:
        m += 1

    coef = [0] * (m+1)

    # initialize digits
    for i in range(2, m+1):
        coef[i] = 1
    d[0] = 2

    carry = 0
    # calculate n-1 significant digits in e (the first digit was initialized above)
    for j in range(1, n):
        carry = 0
        for k in range(m, 1, -1):
            temp = coef[k] * 10 + carry
            carry = int(temp / k)
            coef[k] = temp - carry * k
        d[j] = carry

    return d

def fileWrite(fname, d):
    if len(d) > 1:
        # insert a decimal point for comparison test purposes
        d.insert(1, '.')

    with open(fname, 'w') as f:
        for digit in d:
            # write the calculated digits of e to the file specified by the user
            f.write("%s" % digit)
        f.write("\n")
    
def main():
    print("CALCULATE e TO MANY DIGITS!")
    sigDig = int(input("Enter the number of significant digits to calculate: "))
    fname = getFilename()
    eulerNum = keepe(sigDig)
    fileWrite(fname, eulerNum)
    print("Program finished!")

if __name__ == "__main__":
    main()