import std.string;
import std.stdio;

class Chip8
{
  // 35 opcodes which are all 2 bytes long
  ushort opcode;

  // 4K memory in total
  char[4096] memory;

  // 16 8-bit data registers, V0 - VF(Flag for some registers)
  char[16] V;

  // 16-bit wide Index register (address)
  ushort I;

  // 16-bit PC
  ushort pc;

  // 0x000-0x1FF - Chip 8 interpreter (contains font set in emu)
  // 0x050-0x0A0 - Used for the built in 4x5 pixel font set (0-F)
  // 0x200-0xFFF - Program ROM and work RAM
  
  // Screen size: 64 x 32 = 2048 px
  const size_t screenWidth = 64;
  const size_t screenHeight = 32;
  char[screenWidth * screenHeight] screen;

  // Interrupts and hardware registers, CHIP-8 has none, but there are two timer that count ay 60 Hz,
  // will count down if set above zero.
  char delayTimer;

  // Buzzer will sound when sound timer reaches 0.
  char soundTimer;

  // Stack and stack pointer
  ushort[16] stack;
  ushort sp;

  // Hex based keypad, 0x0 - 0xF
  char[16] keys;

  // Whether to draw
  bool drawFlag;

  // All the required fonts
  char[80] fontset =
  { 
    0xF0, 0x90, 0x90, 0x90, 0xF0, // 0
    0x20, 0x60, 0x20, 0x20, 0x70, // 1
    0xF0, 0x10, 0xF0, 0x80, 0xF0, // 2
    0xF0, 0x10, 0xF0, 0x10, 0xF0, // 3
    0x90, 0x90, 0xF0, 0x10, 0x10, // 4
    0xF0, 0x80, 0xF0, 0x10, 0xF0, // 5
    0xF0, 0x80, 0xF0, 0x90, 0xF0, // 6
    0xF0, 0x10, 0x20, 0x40, 0x40, // 7
    0xF0, 0x90, 0xF0, 0x90, 0xF0, // 8
    0xF0, 0x90, 0xF0, 0x10, 0xF0, // 9
    0xF0, 0x90, 0xF0, 0x90, 0x90, // A
    0xE0, 0x90, 0xE0, 0x90, 0xE0, // B
    0xF0, 0x80, 0x80, 0x80, 0xF0, // C
    0xE0, 0x90, 0x90, 0x90, 0xE0, // D
    0xF0, 0x80, 0xF0, 0x80, 0xF0, // E
    0xF0, 0x80, 0xF0, 0x80, 0x80  // F
  };

  this()
  {
    // Initialize registers and memory once

    // Basic fontset stored at 0x50 == 80 onwards

    // Application to be loaded at 0x200, pc set to 0x200 == 512
    pc = 0x200;

    opcode = 0; // Reset current opcode
    I      = 0; // Reset index register
    sp     = 0; // Reset stack pointer

    // Clear display
    // Clear stack
    V[]      = 0; // Clear registers v0-vF
    memory[] = 0; // Clear memory

    // Load fontset
    //for (int i = 0; i < 80; ++i)
      //memory[i] = chipFontset[i];

    // Reset timers
    delayTimer = 0;
    soundTimer = 0;
  }

  public void LoadGame(const char[] name)
  {
    // size_t bufferSize = 2048;
    
    // // Fopen with binary
    // auto f = File(name);
    // auto buf = f.rawRead(new char[bufferSize]);
    // f.close();

    // // Fill the memory at location 0x200 == 512
    // for(int i = 0; i < buf.length; ++i)
    //   memory[i + 512] = buf[i];
  }

  public void Run()
  {
    // while (true)
    {
      // Emulate one cycle
      EmulateCycle();

      //if (drawFlag)
        // Draw Graphics

      // Store key (Press and Release) state
      SetKeys();
    }
  }

  void EmulateCycle()
  {
    // Fetch Opcode
    opcode = memory[pc] << 8 | memory[pc + 1];

    // Decode Opcode
    // Execute Opcode

    // Check the first bit of the opcode
    switch (opcode & 0xF000)
    {
      case 0x0000:
      {
        switch (opcode & 0x000F)
        {
          case 0x0000: // Clears the screen
          {
          } break;

          case 0x000E: // Return from subroutine
          {
          } break;

          default:
          {
            writeln("Unknown opcode: ", opcode);
          } break;
        }
      } break;

      case 0x1000:
      {
        // Jump to address NNN
        const auto address = opcode & 0x0FFF;

      } break;

      case 0x2000:
      {
        // Calls subroutine at NNN
        const auto address = opcode & 0x0FFF;

        // Push current pc onto the stack
        stack[sp++] = pc;
        pc = address;
      } break;

      case 0x3000:
      {
      } break;

      case 0x4000:
      {
      } break;

      case 0x5000:
      {
      } break;

      case 0x6000:
      {
      } break;

      case 0x7000:
      {
      } break;

      case 0x8000:
      {
        switch (opcode & 0x000F)
        {
          case 0x0004:  // 0x8XY4 
          {
            // Adds VY to VX. VF is set to 1 when there's a carry, 0 otherwise
            
            // Check for carry first before adding
            const auto X = (opcode >> 2) & 0x000F;
            const auto Y = (opcode >> 1) & 0x000F;

            // Check if Y is larger than the remainder from 255 - X
            V[0xF] = (V[Y] > (0xFF - V[X])) ? 1 : 0;
            V[X] += V[Y];

            Next();
          } break;

          default:
          {
          } break;
        }
      } break;

      case 0x9000:
      {
      } break;

      case 0xA000:
      {
      } break;

      case 0xB000:
      {
      } break;

      case 0xC000:
      {
      } break;

      case 0xD000:
      {
        // 0xDXYN
        // Draws a sprite at coordinate (VX, VY) that has a width of 8 pixels and a height of N pixels. 
        // Each row of 8 pixels is read as bit-coded starting from memory location I; 
        // I value doesn’t change after the execution of this instruction. 
        // As described above, VF is set to 1 if any screen pixels are flipped from set to unset 
        // when the sprite is drawn, and to 0 if that doesn’t happen 

        const auto X = (opcode >> 2) & 0x000F;
        const auto Y = (opcode >> 1) & 0x000F;
        const auto height = opcode & 0x000F;

        foreach (cy; 0 .. height)
        {
          const auto data = memory[I + cy];
          
          // Always width of 1 byte
          foreach (cx; 0 .. 8)
          {
            // Only look at non-blank pixels
            if (data & (0x80 >> cx))
            {
              // Check if pixels is flipped from set to unset, if current bit is 1, it will be 0 after xor
              const auto currentID = (cy + Y) * screenWidth + (cx + X);
              if (screen[currentID])
                V[0xF] = 1;
              screen[currentID] ^= 0x01;
            }
          }
        }

        drawFlag = true;
        Next();

      } break;

      case 0xE000:
      {
        const auto X = (opcode >> 2) & 0x000F;
        // Keypad                   Keyboard
        // +-+-+-+-+                +-+-+-+-+
        // |1|2|3|C|                |1|2|3|4|
        // +-+-+-+-+                +-+-+-+-+
        // |4|5|6|D|                |Q|W|E|R|
        // +-+-+-+-+       =>       +-+-+-+-+
        // |7|8|9|E|                |A|S|D|F|
        // +-+-+-+-+                +-+-+-+-+
        // |A|0|B|F|                |Z|X|C|V|
        // +-+-+-+-+                +-+-+-+-+
        switch (opcode & 0x00FF)
        {
          case 0x9E:  // 0xEX9E
          {
            // Skips the next instruction if the key stored in VX is pressed. 
            // (Usually the next instruction is a jump to skip a code block) 
            if (key[V[X]])
              Next();
            Next();
          } break;

          case 0xA1:  // 0xEXA1
          {

          } break;
        }
      } break;

      case 0xF000:
      {
        switch (opcode & 0x00FF)
        {
          case 0x0033:  // 0xFX33
          {
            // Stores the binary-coded decimal representation of VX, with the most significant of three digits at the address in I, 
            // the middle digit at I plus 1, and the least significant digit at I plus 2. 
            // (In other words, take the decimal representation of VX, 
            // place the hundreds digit in memory at location in I, 
            // the tens digit at location I+1, and the ones digit at location I+2.) 
            
            const auto X = (opcode >> 2) & 0x000F;
            
            // Value from 0 - 255, extract the three numbers into different locations of I
            const auto val = V[X];
            memory[I]      = val / 100;
            memory[I + 1]  = (val % 100) / 10;
            memory[I + 2]  = val % 10;

            Next();
          } break;

          default:
          {
          } break;
        }
      } break;

      default:
      {
        writeln("Unknown opcode: ", opcode);
      } break;
    }

    Next();

    // Update timers
    if (delayTimer > 0)
      --delayTimer;
    if (soundTimer > 0)
    {
      if (soundTimer == 1)
        writeln("BEEP!");
      --soundTimer;
    }
  }

  void SetKeys()
  {
  }

  void Next()
  {
    pc += 2;
  }
}