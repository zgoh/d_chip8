import std.string;
import std.stdio;

class Chip8
{
  // 35 opcodes which are all 2 bytes long
  ushort opcode;

  // 4K memory in total
  char[4096] memory;

  // 16 8-bit data registers, V0 - VF(Flag for some registers)
  char[16] vReg;

  // 16-bit wide Index register (address)
  ushort iReg;

  // 16-bit PC
  ushort pc;

  // 0x000-0x1FF - Chip 8 interpreter (contains font set in emu)
  // 0x050-0x0A0 - Used for the built in 4x5 pixel font set (0-F)
  // 0x200-0xFFF - Program ROM and work RAM

  // Screen size: 64 x 32 = 2048 px
  char[2048] screen;

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

  this()
  {
    // Initialize registers and memory once

    // Basic fontset stored at 0x50 == 80 onwards

    // Application to be loaded at 0x200, pc set to 0x200 == 512
    pc = 0x200;

    opcode = 0; // Reset current opcode
    iReg   = 0; // Reset index register
    sp     = 0; // Reset stack pointer

    // Clear display
    // Clear stack
    vReg[]   = 0; // Clear registers v0-vF
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
          case 0x0004:  // Adds VY to VX. VF is set to 1 when there's a carry, 0 otherwise
          {
            // 0x8XY4 
            // Check for carry first before adding
            const auto X = (opcode >> 2) & 0x000F;
            const auto Y = (opcode >> 1) & 0x000F;

            // Check if Y is larger than the remainder from 255 - X
            vReg[0xF] = (vReg[Y] > (0xFF - vReg[X])) ? 1 : 0;
            vReg[X] += vReg[Y];

            pc += 2;
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
      } break;

      case 0xE000:
      {
      } break;

      case 0xF000:
      {
      } break;

      default:
      {
        writeln("Unknown opcode: ", opcode);
      } break;
    }

    pc += 2;

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
}