PrintWriter journal;
int frame = 0;
int textHeight = 0; //for even vertical spacing out between text boxes
int beg = 0;
//int rectColor1, rectColor2, rectColor3, rectColor4 = 235;
String lastLineText = ""; // only for user
String text = ""; //storage of txt that will be transmitted to the system.
String response = "Welcome to Turtle Shell!"; //computer's response
Boolean compResponding = true;
PFont font, bfont;
PShape textCursor, textBox, leftArc, rightArc, box;
ALStack<String> compResponses = new ALStack<String>();
ALStack<PShape> userTextBoxes = new ALStack<PShape>();
ALStack<PShape> compTextBoxes = new ALStack<PShape>();

void setup() {
  size( 800, 600 ); 
  background( 255 );
  ellipseMode( CORNER );
  //bfont = createFont("fantasy", 15, true);   
  //for font --------------------------------------------------------------------
  font = createFont( "Calibri", 20, true ); //font, size, anti-aliasing(?)
  fill( 255 ); //color text
  textFont( font, 20 ); //font, size( overrides the default size above )
  textLeading( 20 ); //gap between lines
  //-----------------------------------------------------------------------------
  journal = createWriter("journalentry.txt"); // Create a new file in the sketch directory
}


void draw() {
  if ( compResponding == true ) {
    if ( beg < response.length() ) {
      background( 255 );
      beg++;
      delay(50);
      //txtBox -------------------------------------------------------------------------------------
      textBox = createShape( GROUP );
      leftArc = createShape( ARC, 410, 20, 20, (textHeight * 20) + 20, PI / 2, (3 * PI) / 2 );
      if ( textHeight == 0 ) { //first line
        box = createShape( RECT, 420, 20, (textWidth( text ) % 350), 20 );
        rightArc = createShape( ARC, (textWidth( text ) % 350) + 410, 20, 20, 20, - PI / 2, PI / 2 );
      } else {
        box = createShape( RECT, 420, 20, 350, (textHeight * 20) + 20 );
        rightArc = createShape( ARC, 760, 20, 20, (textHeight * 20) + 20, - PI / 2, PI / 2 );
      }
      textBox.addChild( leftArc );
      textBox.addChild( rightArc );
      textBox.addChild( box );
      leftArc.setFill( color(150, 220, 250) ); //For some reason, textBox.setFill and textBox.setStroke doesnt work :(
      rightArc.setFill( color(150, 220, 250) );
      box.setFill( color(150, 220, 250) );
      leftArc.setStroke( color(150, 220, 250) );
      rightArc.setStroke( color(150, 220, 250) );
      box.setStroke( color(150, 220, 250) );
      strokeWeight( 5 );
      shape( textBox );
      //response------------------------------------------------------------------------------------
      text = response.substring(0, beg);
      textHeight = (int)(textWidth( text ) / 350);
      text( text, 420, 20, 350, 600 ); //display computer's response
    }
    else {
      compTextBoxes.push( textBox );
      compResponses.push( text );
      //reset all the vars
      beg = 0;
      text = "";
      textHeight = 0;
      compResponding = false;
    } 
  }
  else {
    background( 255 );
    shape( compTextBoxes.peek() );
    text( compResponses.peek(), 420, 20, 350, 600 );
    //txtBox -----------------------------------------------------------
    textBox = createShape( GROUP );
    leftArc = createShape( ARC, 20, 20, 20, (textHeight * 20) + 20, PI / 2, (3 * PI) / 2 );
    if ( textHeight == 0 ) { //first line
      box = createShape( RECT, 30, 20, (textWidth( lastLineText ) % 350), 20 );
      rightArc = createShape( ARC, (textWidth( lastLineText ) % 350) + 20, 20, 20, 20, - PI / 2, PI / 2 );
    } else {
      box = createShape( RECT, 30, 20, 350, (textHeight * 20) + 20 );
      rightArc = createShape( ARC, 370, 20, 20, (textHeight * 20) + 20, - PI / 2, PI / 2 );
    }
    textBox.addChild( leftArc );
    textBox.addChild( rightArc );
    textBox.addChild( box );
    leftArc.setFill( color(150, 220, 250) ); //For some reason, textBox.setFill and textBox.setStroke doesnt work :(
    rightArc.setFill( color(150, 220, 250) );
    box.setFill( color(150, 220, 250) );
    leftArc.setStroke( color(150, 220, 250) );
    rightArc.setStroke( color(150, 220, 250) );
    box.setStroke( color(150, 220, 250) );
    strokeWeight( 5 );
    shape( textBox );
    //textCursor --------------------------------------------------------
    textCursor = createShape( ELLIPSE, (textWidth( lastLineText ) % 350) + 30, (textHeight * 20) + 30, 5, 5 );
    textCursor.setStroke( false ); //noStroke
    if ( frame % 30 < 15 ) { //blinking every 15 frames
      textCursor.setFill( color(255) ); //white
    } else {
      textCursor.setFill( color(150, 220, 250) ); //blue
    }
    shape( textCursor );
    //-------------------------------------------------------------------
    text( text, 30, 20, 350, 600 );
    text( lastLineText, 30, textHeight * 20 + 20, 350, 600 ); //display text within a box
    frame++;
  }
}


void keyPressed() {
  if ( compResponding == true ) { //If computer is typing don't do anything
  } else {
    if ( key == ENTER || key == RETURN ) { //check both ENTER and RETURN for crossplatform
      textHeight++;
      for ( int i = 0; i < lastLineText.length(); i++ ) {
        if ( lastLineText.charAt(i) != ' ' ) { // if line is not empty
          while ( textWidth( lastLineText ) < 350 ) { // fill up the line with spaces
            lastLineText += " ";
          }
          text += lastLineText;
          lastLineText = "";
          return;
        }
      }
      lastLineText = "|"; //when a line is empty 
      while ( textWidth( lastLineText ) < 350 ) { // fill up a line
        lastLineText += " ";
      }
      text += lastLineText;
      lastLineText = "";
    } else if ( key == BACKSPACE || key == DELETE ) {
      if ( text.length() <= 0 && lastLineText.length() <= 0 ) { // do nothing
      } else if ( lastLineText.length() <= 0 ) {
        textHeight--;
        for ( int i = text.length()-1; i >= 0; i-- ) { //iterate from back 
          if ( textWidth( text.substring(i) ) > 350 ) {
            lastLineText = text.substring(i).trim();
            if ( lastLineText.equals( "|" ) ) {
              lastLineText = ""; // this is when you skipped a line using enter or return
            }
            text = text.substring(0, i);
            break;
          }
        }
      } else { //if not at the front of a line
        lastLineText = lastLineText.substring( 0, lastLineText.length()-1 ); //deletes data
      }
    } else if (key == ESC) { 
        while (text.indexOf("|") >= 0) {
          String data2 = text.substring(0, text.indexOf("|"));
          journal.println(data2.trim());
          text = text.substring(text.indexOf("|")+1);
        }
      journal.println(text);
      journal.println(lastLineText);
      journal.flush(); // Writes the remaining data to the file
      journal.close(); // Finishes the file
      exit(); // Stops the program
    } else if ( key == CODED ) { // do nothing 
    } else {
      if ( textWidth( lastLineText + key ) > 350 ) { //to prevent cursor misplacement
        textHeight++;
        for ( int i = text.length()-1; i >= 0; i-- ) {
          if ( lastLineText.charAt(i) == ' ' ) { //finds the beginning of the last word that will be wrapped around 
            String tmp = "";
            tmp = lastLineText.substring(0, i);
            while ( textWidth( tmp ) < 350 ) { //fills the line with spaces
              tmp += " ";
            }
            text += tmp;
            lastLineText = lastLineText.substring(i+1); //i+1 because of a random space
            lastLineText += key;           
            return;
          }
        }   
        text += lastLineText;
        lastLineText = "";
      }  
      lastLineText += key; //update txt
    }
  }
}