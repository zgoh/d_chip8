/*
    Tool to generate a test CHIP-8 rom
*/

#include <stdio.h>

char game[] = {
    // 0xA1, 0x23   // Set I to 291

};

int main(void)
{
    const size_t sz = sizeof(game);

    FILE *file = fopen("../roms/test.ch8", "wb");
    if (file)
    {
        fwrite(game, sizeof(char), sz, file);
    }

    fclose(file);
    return 0;
}