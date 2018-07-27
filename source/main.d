import std.stdio;

import chip8;
import glfrontend;

void main()
{
  // GLFrontEnd frontend = new GLFrontEnd();
  // frontend.Frame();

  Chip8 chip8 = new Chip8();
  
  // This will hook up to external libraries to handle
  //chip8.SetInput();
  //chip8.SetDisplay();

  // Load the designated rom and run the emulator
  chip8.LoadGame("roms/test.ch8");
  chip8.Run();
}
