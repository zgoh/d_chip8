CHIP-8 Interpreter in D
=======================
![alt text](https://raw.githubusercontent.com/zgoh/d_chip8/master/screenshots/Pong.png)

Simple Chip-8 interpreter written in D. It uses the GLFW backend to draw the game screen. It does not have any sound support at the moment.

Currently only supports Chip-8 instructions. Emulation speed is not accurate.

Contents
--------
* [Building](#building)
* [Usage](#usage)
* [Keys](#keys)
* [TODO](#todo)
* [References](#references)

Building
--------
Note: Only tested on Windows

    # Normal mode
    $ dub
    
    # Step mode for debugging, will print opcode by opcode (Press space to advance).
    $ dub --config=StepMode
    
Usage
-----
    d_chip8 [PATH_TO_ROM]
    
Keys
----
Key mapping taken from [here](http://www.multigesture.net/articles/how-to-write-an-emulator-chip-8-interpreter/)

    Keypad                   Keyboard
    +-+-+-+-+                +-+-+-+-+
    |1|2|3|C|                |1|2|3|4|
    +-+-+-+-+                +-+-+-+-+
    |4|5|6|D|                |Q|W|E|R|
    +-+-+-+-+       =>       +-+-+-+-+
    |7|8|9|E|                |A|S|D|F|
    +-+-+-+-+                +-+-+-+-+
    |A|0|B|F|                |Z|X|C|V|
    +-+-+-+-+                +-+-+-+-+
    
    [Space]   => Next Opcode (Only in step mode)
    [Escape]  => Escape the emulator
    
TODO
----
* Pretty debug (Came across this [Chip-8](https://massung.github.io/CHIP-8/) implemented in Go and I wanted something like this)
* Super Chip-8 implementation
* Accurate speed?
* Add beep sound (Probably not high priority)
    
References
----------
* http://www.multigesture.net/articles/how-to-write-an-emulator-chip-8-interpreter/
* http://en.wikipedia.org/wiki/CHIP-8
* http://www.pong-story.com/chip8/
