# vhdl-pong

# Introduction
This project implements a simple video game, applying concepts of video-output subsystems and using the Video Graphic Adaptor (VGA) standard. The game created is similar to the classic arcade game pong. The focus is more so on interfacing an FPGA to an external real-time I/O device, that being the VGA monitor, than creating a game.
## Demo
<p align="center">
  <a href="https://www.youtube.com/watch?v=K-_hVV_IY0s">
    <img src="https://img.youtube.com/vi/K-_hVV_IY0s/0.jpg" alt="Watch the video" />
  </a>
</p>

# Game Specifications
1. Static Video Frame:
    - Green background
    - White boundaries surrounding the playing area
3. Dynamic Elements:
    - Yellow ball that moves around the playing area
    - The ball collides with boundaries and paddles
    - Two paddles that can move up or down, controlled by the board’s switches
        - One paddle is blue, the other paddle is pink
4. Behavior
    - When the ball collides with an object, the trajectory of the ball should change 180 degrees of where it was hit
        - I.e. if it hits the bottom boundary, it should start moving up
    - When the ball enters a goal it should turn red, disappear then reappear as yellow in the middle of the playing field

![Image](https://github.com/muizzkhan0/vhdl-pong/blob/main/readme-images/game%20specification.png)

# Device Description/Design
## Symbol Diagram
The system takes inputs from the clock and four switches. Internally the clock gets divided by half as that is what the VGA operates at. The output RGB controls the color that is displayed on the monitor and the Hsync and Vsync handle synchronization between the software and the monitor’s hardware.

![Image](https://github.com/muizzkhan0/vhdl-pong/blob/main/readme-images/symbol%20diagram.png)

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

Table II. VGA Vertical Parameters

| Parameter | Clock Cycles |
| --- | --- |
| Complete Line | 525 |
| Front Porch | 10 |
| Sync Pulse | 2 |
| Back Porch | 33 |
| Active Image Area | 480 |

The horizontal timings are multiples of the VGA pixel clock which is 25 MHz for a 60 Hz refresh rate, and the vertical timings are multiples of VGA lines.  
The front porch is the delay between the end of the video data of a scanline and the initial edge of the sync pulse. The sync pulse is the length of the synchronization pulse. The back porch is the delay between the final edge of the sync pulse and the first piece of data for the next scanline. 

## Block Diagrams
![Image](https://github.com/muizzkhan0/vhdl-pong/blob/main/readme-images/block%20diagram.png)

- The Clock Divider halves the input clock so that it may be used as the VGA’s pixel clock.  
- The Ball Position, Blue Paddle Position and Pink Paddle Position are actually four separate lines for x1, x2, y1 and y2 that make up the coordinates for their respective components.
- Ball Movement, Blue Paddle Movement and Pink Paddle Movement handle positional logic for the ball and paddles. This includes movement and collision logic. The four switches are used to control the two paddles. They send their respective component’s coordinates to the position comparator for drawing.
- Position Comparator checks if the Hcounter/Vcounter land within a component's coordinates and changes the RGB values accordingly.
- Score Checker is used to signal a goal which triggers a color change and positional reset for the ball.
- Hsync and Vsync are used to signal to the hardware to move back to the start of a row or to the top of the screen.

# Results
## Timing Diagram
![Image](https://github.com/muizzkhan0/vhdl-pong/blob/main/readme-images/timing%20diagram.png)  
In the timing diagram, we can see the Hsync pulsing periodically. Each pulse represents the end of a line. The Vsync has a longer pulse that lasts for 2 whole Hsync pulses, which supports the VGA specifications for the vertical parameters. 
