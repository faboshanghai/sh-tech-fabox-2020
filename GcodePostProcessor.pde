/*
 GcodePostProcessor.pde
 (C) 2018 lingib
 https://www.instructables.com/
 Last update 6 March 2018
 
 --------
 ABOUT
 --------
 This code requires "Processing 3" from <https://processing.org/download/>.
 
 The program inserts the special gcode sequences that are required 
 when GRBL is modified to control a Z-axis servo.
 
 (GRBL is an ardino program for controlling the stepping motors on 
 three-axis machines such as 3D-printers and milling-machines. See 
 <https://www.instructables.com/id/GRBL-Servo-Control/> for more details.)
 
 Copy the contents of this file into a "Processing 3" sketch and save as 
 "GcodePostProcessor" (without the quotes). Click the run arrow then follow 
 the on-screen instructions.
 
 Absolute and relative addressing may be used when entering the source "filename".
 
 When using relative addressing precede each DOS path symbol (\) 
 with an escape character (\). Examples:
 
 "filename" means the file is inside the Processing folder.
 ".\\filename" also means the file is inside the Processing folder.
 "..\\filename" means the file is one level up.
 "..\\folder1\\filename means file is in folder1 which is one level up.
 
 ----------
 COPYRIGHT
 ----------
 This is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This software is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License. If 
 not, see <http://www.gnu.org/licenses/>.
 */

// ---------------------------------------------------
// DEFINITIONS
// ---------------------------------------------------

// ----- PrintWriter
PrintWriter Output;                                //create an "Output" port for PrintWriter

// ----- source file
String Input_filename;                             //source filename
String Output_filename;                            //output filename
/* The routine for creating the "Output_filename" is located within the keyPressed() routine */

// ----- commands
String[] Command_array;                            //array of g-code commands
String Command_line = "";                          //holds one line of g-code
int Number_commands;                               //number of g-code commands

// ----- user interface
String Message = "";                               //used for on-screen instructions
String Keyboard = "";                              //keyboard buffer

// ----- flags
boolean Pen_up = true;
boolean Pen_down_S90 = false;
boolean Input_filename_valid = false; 
boolean Suppress_output_flag =false;


// ---------------------------------------------------
// SETUP
// ---------------------------------------------------
void setup() {
  // ----- create draw window
  size(400, 300);                                   //message window dimensions
  textSize(18);                                     //set text characters to 18
  textAlign(CENTER);                                //center the text
  background(#EEEEEE);                              //light gray background
  fill(0);                                          //black text


  // ----- get input filename  
  /* The keyPressed() routine intercepts your keypresses and performs this task */
  if (!Input_filename_valid) {
    Message = "This program inserts GRBL compatible servo commands into gcode files.\r\n\r\nThe cursor does not blink.\r\n\r\nClick this box to start.";
    text(Message, 25, 55, 360, 200);                // Text wraps within text box
  }
}

// ---------------------------------------------------
// DRAW (main loop)
// ---------------------------------------------------
void draw() {

  // ----- check for mouse click
  if (mousePressed) {
    delay(100);                                      //debounce delay
    background(#EEEEEE);
    textAlign(CENTER);
    text("Enter the \"source\" filename", width/2, height/4);
  }

  if (Input_filename_valid) {

    // ----- process the file contents
    for (int i=0; i<Number_commands; i++) {
      process(Command_array[i]);
    }

    // ----- close the output file
    Output.println("M3");                             //pen up
    Output.println("G4 P1");                          //1mS dwell
    Pen_up = true;
    Output.println("G00 X0.000000 Y0.000000");        //home
    Output.flush();                                   //write the remaining data to the file
    Output.close();                                   //close the file

    // ----- display the output file location
    background(#EEFFEE);                              //clear the window
    fill(0, 0, 0);                                  //black text
    Message = "A modified plotter file\r\n " + "\"" + Output_filename + "\"" + "\r\nhas been created.\r\n\r\nThis file requires a servo version of GRBL.\r\n\r\nExit or click this box to continue.";
    text(Message, 20, 35, 360, 300);                  // Text wraps within window

    // ----- housekeeping
    Input_filename_valid = false;
  }
}

// ---------------------------------------------------
// KEY PRESSED (called each key press)
// ---------------------------------------------------
void keyPressed() {  

  // ----- validate each keypress. Also prevents control characters from showing.
  switch (key) {
  case 'a': 
  case 'b': 
  case 'c':
  case 'd': 
  case 'e': 
  case 'f': 
  case 'g': 
  case 'h': 
  case 'i': 
  case 'j': 
  case 'k': 
  case 'l': 
  case 'm': 
  case 'n': 
  case 'o': 
  case 'p': 
  case 'q': 
  case 'r': 
  case 's': 
  case 't': 
  case 'u': 
  case 'v': 
  case 'w': 
  case 'x': 
  case 'y': 
  case 'z':
  case 'A': 
  case 'B': 
  case 'C': 
  case 'D': 
  case 'E': 
  case 'F': 
  case 'G': 
  case 'H': 
  case 'I': 
  case 'J': 
  case 'K': 
  case 'L': 
  case 'M': 
  case 'N': 
  case 'O': 
  case 'P': 
  case 'Q': 
  case 'R': 
  case 'S': 
  case 'T': 
  case 'U': 
  case 'V': 
  case 'W': 
  case 'X': 
  case 'Y': 
  case 'Z':  
  case '1': 
  case '2': 
  case '3': 
  case '4': 
  case '5': 
  case '6': 
  case '7': 
  case '8': 
  case '9': 
  case '0': 
  case ' ':
  case '.':
  case ':': 
  case '_': 
  case '&': 
  case '\\': 
  case '\r':
  case '\n':
    {
      // ----- build the input filename
      if (!Input_filename_valid) {

        // ----- get keystroke
        Keyboard += key;

        // ----- display keystrokes
        background(#EEEEEE);
        textAlign(CENTER);
        text(Keyboard, width/2, height/2);

        // ----- get file
        if ((key == '\r')||(key=='\n')) {                   //has the "enter" key been pressed?

          // ----- read the INPUT file
          Input_filename = Keyboard.trim();                 //remove white space including \r\n

          // ----- validate filename
          boolean valid = fileExists(Input_filename);       //code not ideal but it works

          // ----- file found action
          if (valid) {
            Command_array = loadStrings(Input_filename);    //create an array of command strings
            Number_commands = Command_array.length;         //find number of command strings

            // ----- create/open an OUTPUT file
            /* adding a .GRBL file extension to the original filename will keep them together */
            Output_filename = Input_filename + ".gcode";
            Output = createWriter(Output_filename);

            // ----- initialise the pen
            Output.println("M3 S90");                       //pen up
            Output.println("G4 P1");                        //1mS dwell
            Pen_up = true;

            // ----- housekeeping
            Keyboard = "";
            Input_filename_valid = true;
          }
        }
      }
    }
  default: 
    {
      break;
    }
  }
}

// ---------------------------------------------------
// PROCESS (called once per command line)
// ---------------------------------------------------
void process(String original_command) {

  // ------ locals
  String tokens = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";
  String command = original_command;                     //used for splitting commands into component parts
  String [] items;                                       //component parts
  String substring = "";                                 //scratchpad
  int gcode = 0;
  int num_chars;
  int index;

  // ----- convert everything to uppercase  
  command = command.toUpperCase();

  // ----- compress the command
  command = command.replaceAll("[ ]", "");               //regular expression to remove the spaces

  // ----- strip out all existing "M" commands  
  index = command.indexOf("M");
  if (index==0) {
    Suppress_output_flag = true;
  }

  // ----- insert the required M3(pen_up) and M5(pen_down) code sequences
  index = command.indexOf("G");
  if (index==0) {

    // ---- identify the G-code command
    num_chars = command.length();
    substring = command.substring(index, num_chars);     //keep everything after the "match"
    items = splitTokens(substring, tokens);              //split string at each non-digit character         
    gcode = int(items[0]);                               //item[0] contains the "match" value 

    // ----- G00 (linear move with pen_up)
    if ((gcode==0) && !Pen_up) {
      Output.println("M3");                               //pen up
      Output.println("G4 P1");                            //1mS dwell
      Pen_up = true;
    }

    // ----- G01 (linear move with pen_down)
    if ((gcode == 1) && Pen_up) {
      Output.println("M5");
      Output.println("G4 P1");                            //1mS dwell
      Pen_up = false;
    }

    // ----- G02 (CW arc with pen_down)
    if ((gcode==2) && Pen_up) {
      Output.println("M5");
      Output.println("G4 P1");                            //1mS dwell
      Pen_up = false;
    }

    // ----- G03 (CCW arc with pen_up)
    if ((gcode==3) && Pen_up) {
      Output.println("M5");
      Output.println("G4 P1");                            //1mS dwell
      Pen_up = false;
    }
  }

  // ----- add the original command line to file
  if (Suppress_output_flag) {
    Suppress_output_flag = false;                          //don't write command to file
  } else {
    Output.println(original_command);                      //write command to file
  }
}

// ---------------------------------------------------
// FILE EXISTS (NullPointerException error-handler)
// ---------------------------------------------------
boolean fileExists(String filename) {
  try {
    String [] lines = loadStrings(filename);
    int howMany = lines.length;                            //exception generated if file doesnt exist

    return true;
  } 
  catch (NullPointerException error) {

    // ----- display error message
    background(#FFEEEE);                                  //pale red background
    fill(255, 0, 0);                                      //red text
    Message = "The file\r\n" + "\"" + filename + "\"" + "\r\n could not be found.\r\n\r\n Please click this box and try again.";
    text(Message, 20, 65, 360, 200);                      // Text wraps within window

    // ----- housekeeping
    Keyboard = "";
    Input_filename = "";
    Input_filename_valid = false; 
    fill(0, 0, 0);                                        //change text color for next message

    return false;
  }
}