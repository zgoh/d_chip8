CHIP-8 Interpreter in D
=======================
Simple Chip8 interpreter written in D. It uses the GLFW backend to draw the game screen. It does not have any sound support at the moment.

Screenshots
-----------
![alt text](https://raw.githubusercontent.com/zgoh/d_chip8/master/screenshots/Pong.png)

Building (Only tested on Windows)
---------------------------------
    # Normal mode
    $ dub
    
    # Step mode for debugging, will print opcode by opcode (Press space to advance).
    $ dub --config=StepMode
    
Usage
-----
    d_chip8 [PATH_TO_ROM]
    
Keys
----
[Taken from](http://www.multigesture.net/articles/how-to-write-an-emulator-chip-8-interpreter/)

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
    
References
----------
- http://www.multigesture.net/articles/how-to-write-an-emulator-chip-8-interpreter/
- http://en.wikipedia.org/wiki/CHIP-8
