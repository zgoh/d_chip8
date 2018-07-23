import std.stdio;
import std.string : format, fromStringz;

import derelict.glfw3.glfw3;
import derelict.opengl;

void main()
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
  
  auto window = glfwCreateWindow(800, 600, "CHIP-8", null, null);
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

  while (!glfwWindowShouldClose(window))
  {
    glfwSwapBuffers(window);
    glfwPollEvents();
  }

  glfwDestroyWindow(window);
  glfwTerminate();
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