# vhdl-pong

# Introduction
This project implements a simple video game, applying concepts of video-output subsystems and using the Video Graphic Adaptor (VGA) standard. The game created is similar to the classic arcade game pong. The focus is more so on interfacing an FPGA to an external real-time I/O device, that being the VGA monitor, than creating a game. 

# Game Specifications
1. Static Video Frame:
    - Green background
    - White boundaries surrounding the playing area
3. Dynamic Elements:
    Yellow ball that moves around the playing area
    The ball collides with boundaries and paddles
    Two paddles that can move up or down, controlled by the board’s switches
    One paddle is blue, the other paddle is pink
4. Behavior
    When the ball collides with an object, the trajectory of the ball should change 180 degrees of where it was hit
        I.e. if it hits the bottom boundary, it should start moving up
    When the ball enters a goal it should turn red, disappear then reappear as yellow in the middle of the playing field

![Image](https://github.com/muizzkhan0/vhdl-pong/blob/main/readme-images/game%20specification.png?raw=true)

# Device Description/Design
## Symbol Diagram
The system takes inputs from the clock and four switches. Internally the clock gets divided by half as that is what the VGA operates at. The output RGB controls the color that is displayed on the monitor and the Hsync and Vsync handle synchronization between the software and the monitor’s hardware.

![Image](https://github.com/muizzkhan0/vhdl-pong/blob/main/readme-images/symbol%20diagram.png?raw=true)

## VGA Specifications
The monitor operates by scanning horizontally from left to right, controlling what color is set for each pixel. After completing a row, it starts from the beginning of the next row. The machine’s hardware takes a certain amount of time to move from the end of the last row to the beginning of the next row, and this delay should be accounted for. After the monitor scans all the way to the bottom of the screen, it completes a frame and will take a certain amount of time to return to the top of the screen to start the next frame. This delay must once again be accounted for.
Synchronization between the monitor’s hardware and the software is achieved using Hsync and Vsync. When the software wants to signal to the hardware to start a new line, the Hsync is pulsed. When the software wants to signal to the hardware to return to the top of the screen, the Vsync is pulsed.

Table I. VGA Horizontal Parameters

| Parameter | Clock Cycles |
| --- | --- |
| Complete Line | 800 |
| Front Porch | 16 |
| Sync Pulse| 96 |
| Back Porch | 48 |
| Active Image Area | 640 |
