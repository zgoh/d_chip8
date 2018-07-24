/*
    Tool to generate a test CHIP-8 rom
*/

#include <stdio.h>

char game[] = {
    // Opcode     // Functionality
    // 0x00, 0xEE,   // Return from subroutine
    // 0xA1, 0x23    // Set I to 291
    // 0x21, 0x23,   // Call subroutine at 123
    // 0x31, 0x00,   // Skips the next instruction if V1 equals 23
    // 0x41, 0x00,   // Skips the next instruction if V1 not equals 12
    // 0x51, 0x20,   // Skips the next instruction if V1 equals V2
    0x61, 0xFA,   // Set V1 to FA

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