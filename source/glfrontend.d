/*
  In charge of drawing stuff on the screen using GLFW
*/

import derelict.glfw3.glfw3;
import derelict.opengl;
import chip8;

import std.string : format, fromStringz;

class GLFrontEnd
{
  GLFWwindow *window;
  this()
  {
    // Using Derelict to load openGL/GLFW
    DerelictGL3.load();
    DerelictGLFW3.load("dlls\\glfw3.dll");

    // Setting error callbacks
    glfwSetErrorCallback(&ErrorCallback);

    if (!glfwInit())
    {
      throw new Exception("glfw failed to init");
    }

    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    
    window = glfwCreateWindow(800, 600, "CHIP-8", null, null);
    if (window is null)
    {
      glfwTerminate();
      throw new Exception("glfw failed to create window");
    }

    // Setting key callbacks
    glfwSetKeyCallback(window, &KeyCallback);

    glfwShowWindow(window);
    glfwMakeContextCurrent(window);

    // Turning on vsync
    glfwSwapInterval(1);

    // Reload after making context to use GL 3 core features
    DerelictGL3.reload();
  }

  void Frame()
  {
    Chip8 chip8 = new Chip8();
  
    // This will hook up to external libraries to handle
    //chip8.SetInput();
    //chip8.SetDisplay();

    // Load the designated rom and run the emulator
    // chip8.LoadGame("roms/test.ch8");

    while (!glfwWindowShouldClose(window))
    {
      // chip8.Run();
      glfwSwapBuffers(window);
      glfwPollEvents();
    }
  }

  ~this()
  {
    if (window)
      glfwDestroyWindow(window);
    glfwTerminate();
  }
}


extern(C) nothrow
{
	void ErrorCallback(int error, const(char)* description)
	{
		throw new Error(format("Error: %s : %s", error, fromStringz(description)));
  }

  void KeyCallback(GLFWwindow* window, int key, int scancode, int action, int mods)
  {
    switch(key)
    {
    case GLFW_KEY_ESCAPE:
      // if (action == GLFW_PRESS) 
      //   Game.Stop();
      break;

    case GLFW_KEY_D:
    case GLFW_KEY_RIGHT:
      // if (action == GLFW_PRESS) 
      //   playerDir += 1;
      // else if (action == GLFW_RELEASE) 
      //   playerDir -= 1;
      break;

    case GLFW_KEY_A:
    case GLFW_KEY_LEFT:
      // if (action == GLFW_PRESS) 
      //   playerDir -= 1;
      // else if (action == GLFW_RELEASE) 
      //   playerDir += 1;
      break;
    
    case GLFW_KEY_SPACE:
      //if (action == GLFW_RELEASE) 
        //firePressed = true;
      break;

    default:
      break;
    }
  } 
}