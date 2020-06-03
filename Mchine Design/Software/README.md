# Instructions on installation and usage

## If you are using an Arduino Uno:
1. copy the *grbl-servo-uno* folder inside the *libraries* folder of your Arduino IDE
2. go to file>examples>examples from custom libraries>grbl-servo-uno>grbl-upload
3. upload the code to your arduino uno
4. connect the stepper drivers (make sure the orientation, look for the enable pin), connect the motors, connect a servo motor to any 5V and GND and connect the signal wire to the pin called "END STOPS Z-" (the white one).
5. connect the 12 Volts power using two stripped wires (any 12Volts with 3 to 5 Amps should work).
6. open Universal Gcode Sender, connect it to the machine by selecting the right port and use the machine
7. if in the Gcode the Z level is lower than zero, the servo motor will move down, if the Z level is higher than zero, the servo motor will move down.
7. when you create your Gcode (for example using Inkscape) you will make sure the Z axis move above 0 when moving freely and below 0 when printing

## If you are using an Arduino Nano:
1. copy the *grbl-servo-nano* folder inside the *libraries* folder of your Arduino IDE
2. go to file>examples>examples from custom libraries>grbl-servo-nano>grbl-upload
3. upload the code to your arduino nano
4. connect the stepper drivers (make sure the orientation, look for the enable pin EN), connect the motors, connect a servo motor to any 5V and GND and connect the signal wire to the pin called "Z-".
5. connect the 12 Volts power directly into the black plug.
6. open Universal Gcode Sender, connect it to the machine by selecting the right port and use the machine
7. if in the Gcode the Z level is lower than zero, the servo motor will move down, if the Z level is higher than zero, the servo motor will move down.
7. when you create your Gcode (for example using Inkscape) you will make sure the Z axis move above 0 when moving freely and below 0 when printing

## Step per mm calculator
(https://blog.prusaprinters.org/calculator_3416/)[https://blog.prusaprinters.org/calculator_3416/]
