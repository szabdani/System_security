#include <stdio.h>
#include <string.h>

/**

After GDB analysis the secret password before encoding was found: MMNNQ.
Then with furter analysis of the function verify_key, was discovered that the key itself is modified.
Via reverse engineering of the verify_key function and decryption of the found key I found the correct key: MORTY.

Here is the reverse engineered program crackme.

**/

int verify_key(char * str)
{

  for(int i = 0; i <= 4; i++)
  {
    int code = i + i;
    str[i] -= code;
  }

  char wanted[] = "MMNNQ";

  if(strcmp(str, wanted) == 0) return 1;
  else return 0;

}

int main(void)
{
  char str[6];

  puts("Enter serial (5 capital letters):");

  scanf("%5s", str);

  int value = verify_key(str);

  if(value == 1) puts("Key is valid! Whoop whoop :)");
  else if(value == 0) puts("Key is not valid :(");

  return 0;
}
