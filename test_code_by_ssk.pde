// Experimental settings
boolean isDebug;
int numTrial;
int fixationDuration;
int itiDuration;
int itiRandomDuration;
int itiTotalDuration;
int judgementDuration;
float beepDuration;
int rewardDuration;
color backgroundColor;
int target_id;
float random_num;
int target_type;
int i;

// Variables
int currentState;
int currentTrial;
int baseTime;
// int response;
int RT;
PFont font;

// added by yoshida
int circle_diam;
PVector center;

int number_of_targets;
PVector[] center_Target;

int number_of_distractors;
PVector[] center_Distractor;

PVector target_deviation;
PVector[] stimulus_deviation;

int touch_margin;
int touch_window;
boolean currentCorrect;
boolean fixCorrect;

boolean column_output;

// data storage
PrintWriter output;

//task the order
int[] get_no_dup_order_numbers(int start_rr, int end_rr) {
  int num_size = (end_rr+1) - start_rr; 
  IntList nums = new IntList(num_size);
  for (int i = end_rr; i >= 0; i--) {
    nums.append(i);};
  nums.shuffle();
  //int[] result = nums.array();
  //return result;}
  return nums.array();}
  
int[] rr = get_no_dup_order_numbers(0, 59);{
println("rr: " + rr);}



int rrr = 0;
int n = 0;
  


void setup(){
  size( 1280, 1024 );
  frameRate( 60 );  // default, may be not necesarry
   
  isDebug = true;
  numTrial = 61;
  fixationDuration = 0;

  itiDuration = 500;
  itiRandomDuration = 0;
  
  judgementDuration = 30000;
  backgroundColor = 255;
  target_type = 1; // 1 for circle, 2 for arc
  
  baseTime = 0;
  font = createFont( "Georgia", 24 );
  textFont( font );

  // 
  circle_diam = 55;
  touch_margin = 0; // permit mistouch
  touch_window = circle_diam/2 + touch_margin;
  
  center = new PVector(width/2, height/2);
  
  // initialize targets
  number_of_targets = 1;
  center_Target = new PVector[number_of_targets];
  println("center_Target:" + center_Target);
  println("center" + center);
  for (int i = 0; i < center_Target.length; i++){
    center_Target[i] = center;
  }

  // initialize distractors
  number_of_distractors = 6;
  center_Distractor = new PVector[number_of_distractors];
  for (int i = 0; i < center_Distractor.length; i++){
    center_Distractor[i] = center;
  }
  
  // initialize stimulus_deviation
  target_deviation = new PVector(300, 150);
  stimulus_deviation = new PVector[number_of_distractors];
  stimulus_deviation[0] = new PVector( 1.5 * target_deviation.x, -1 * target_deviation.y) ;
  stimulus_deviation[1] = new PVector(-1.5 * target_deviation.x, -1 * target_deviation.y) ;
  stimulus_deviation[2] = new PVector(0 * target_deviation.x, -1 * target_deviation.y) ;
  stimulus_deviation[3] = new PVector( 1.5 * target_deviation.x, 1 * target_deviation.y) ;
  stimulus_deviation[4] = new PVector(-1.5 * target_deviation.x, 1 * target_deviation.y) ;
  stimulus_deviation[5] = new PVector(0 * target_deviation.x, 1 * target_deviation.y) ;
  
  beepDuration = 0.5;  // sec
  rewardDuration = 500; // msec
  
   // data storage
  int y = year();   // 2003, 2004, 2005, etc.
  int m = month();  // Values from 1 - 12
  int d = day();    // Values from 1 - 31
  int h = hour();
  int mi = minute();
  int s = second();
  int mil = millis();
  output = createWriter("data/"+nf(y,4)+nf(m,2)+nf(d,2)+nf(h,2)+nf(mi,2)+nf(s,2)+nf(mil,3)+ ".txt");
  
  println("circle_diam:" + circle_diam);
  println("touch_window:" + touch_window);
  println("beepDuration" + beepDuration);
  println("rewardDuration" + rewardDuration);
  println("fixationDuration" + fixationDuration);
  println("currentCorrect" + currentCorrect);
  // save general parameters
    output.println(circle_diam  + "\t" + touch_window  + "\t"
        + beepDuration  + "\t" + rewardDuration  + "\t" + fixationDuration + "\t" + currentCorrect);

   //noCursor();
  
  currentTrial = 0;
  set_NextTrial();
  currentState = 0; // go back to 0 (to wait for return key)
  
  column_output = false;
} 

void draw() {
  background( backgroundColor );
  noStroke();
   
if( currentState == 1 ){
    fixationPhase();
  } else if( currentState == 2 ){
    responsePhase();
  } else if( currentState == 3 ){
    rewardPhase();
  } else if( currentState == 4 ){
    itiPhase();
  } else if( currentState == 5 ){
    endPhase();
  }
 
  if( isDebug ){ drawDebugInfo(); }
}



void fixationPhase(){
  // check elapsed time to transit state
  int elapsedTime = millis() - baseTime;
  if( elapsedTime > fixationDuration ){
    transitState();
  }
}

void responsePhase(){
  drawStimuli();
  // check elapsed time to transit state
  int elapsedTime = millis() - baseTime;
  if( elapsedTime > judgementDuration ){
    transitState();
  }
}

void rewardPhase(){
  // check elapsed time to transit state
  int elapsedTime = millis() - baseTime;
  if( elapsedTime > rewardDuration ){
    //arduino.digitalWrite(ledPin, Arduino.LOW);
      currentState = 4;
      n++;
  }
}

void itiPhase(){
  // check elapsed time to transit state
  int elapsedTime = millis() - baseTime;
  if( elapsedTime > itiTotalDuration & mousePressed == false ){
    transitState();
  }
}

void endPhase(){
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}

void transitState(){
  if( currentState == 1 ){
  //  if ( random_num > 1 ){
                       
  //                 }   
      
  //  else  {
             
  //}
    
    if ( fixCorrect ){ currentState = 2;}
    else { currentState = 2; }// jump into ITI, no targets
    baseTime = millis();
  } else if( currentState == 2 ){
    currentState = 3;
    baseTime = millis();
    if (currentCorrect){
     //arduino.digitalWrite(ledPin, Arduino.HIGH);
     // out.playNote( 0, beepDuration, "A5" );
    }
  }
  else if( currentState == 3 ){
     currentState = 4;
  }
  else if( currentState == 4 ){
    if( currentTrial == numTrial - 1 ){
      currentState = 5;
    }
    else {
      baseTime = millis();
      // move on to next trial
      set_NextTrial();
    }
  }
}


void saveTrialData(){
  // record performance
  output.println( "currentTrial" + "\t" + "rrr" + "\t"
        + "mouseX" + "\t" + "mouseY" + "\t" + "RT");
  if (number_of_targets == 1 ){
    output.println( currentTrial + "\t" + rrr + "\t"
        + mouseX + "\t" + mouseY + "\t" + RT  + "\t");
  }
  else if (number_of_targets == 2 ){
    output.println( "currentTrial" + "\t" + "rrr" + "\t"
    + "mouseX" + "\t" + "mouseY" + "\t" + "RT"  + "\t" +"number_of_targets == 2 ");
  }
  if (!column_output) {
    println( "currentTrial" + "\t" + "rrr" + "\t"
        + "mouseX" + "\t" + "mouseY" + "\t" + "ReactionTime");
    column_output = true;
  }
  println( currentTrial + "\t" + rrr + "\t"
        + mouseX + "\t" + mouseY + "\t" + RT);
}


void keyPressed() {
  if ( key == ENTER || key == RETURN ){
    if( currentState == 0 ){
      currentState = 1;
      baseTime = millis();
    }
  }
  // push ESC key to quit, endPhase() will close the file. 
  else if (key == ESC){
    key=0;
    endPhase();
  }
}

void mousePressed() {
  if( currentState == 2 ){   // target phase 
    RT = millis() - baseTime;
    if (mouseY >= center_Target[0].y- touch_window && mouseY <= center_Target[0].y + touch_window
     && mouseX >= center_Target[0].x- touch_window&& mouseX <= center_Target[0].x+ touch_window  ){
      currentCorrect = true; // correct
      transitState();
    }
    else{
      currentCorrect = false; // incorrect
      transitState();
    }
    saveTrialData();
  
  }
  else if( currentState == 1 ){    // fixation phase
    if (mouseY >= height/2 - touch_window && mouseY <= height/2 + touch_window
     && mouseX >= width/2  - touch_window && mouseX <= width/2  + touch_window){
      fixCorrect = true; // correct
      transitState();
    }
    else{
      fixCorrect = false; // incorrect
    }

  }
}

void drawDebugInfo(){
  fill( 100 ); // set font color
  text("currentState: " + currentState, 20, 30 );
  text("currentTrial: " + currentTrial, 20, 60 );
  text("mouseXY: " + mouseX + " " + mouseY , 20, 90 );
  text("mousePressed: " + mousePressed , 20, 120 );
  text("currentCorrect: " + currentCorrect, 20, 150 );
  float elapsedTime = (millis() - baseTime) / 1000.0;
  text("elapsedTime: " + nf( elapsedTime, 1, 3 ), 20, 180 );
}

void set_NextTrial(){
      currentTrial++;
      currentState = 1;
      currentCorrect = false;
      fixCorrect = false;
      itiTotalDuration = itiDuration + (int)random(itiRandomDuration);
      
      
}

void drawStimuli(){
  rrr = rr[n];{
     if(rrr>=0 && rrr<=9){
      fill( 0,0,255 ); // blue left up
      ellipse(center_Target[i].x-300, center_Target[i].y - 200, circle_diam * 2, circle_diam * 2);
    } else if(rrr>=10 && rrr<=19){
      fill( 255,0,0 ); // red center up
      ellipse(center_Target[i].x, center_Target[i].y - 200, circle_diam * 2, circle_diam * 2);
    } else if(rrr>=20 && rrr<=29){
      fill( 0,0,255 );// blue right up
      ellipse(center_Target[i].x+300, center_Target[i].y - 200, circle_diam * 2, circle_diam * 2);
    } else if(rrr>=30 && rrr<=39){
      fill( 0,255,0 ); // green left down
      ellipse(center_Target[i].x-300, center_Target[i].y + 200, circle_diam * 2, circle_diam * 2);
    } else if(rrr>=40 && rrr<=49){
      fill( 0,255,0 ); // green center down
      ellipse(center_Target[i].x, center_Target[i].y + 200, circle_diam * 2, circle_diam * 2);
    } else if(rrr>=50 && rrr<=59){
      fill( 255,0,0 ); // red right down
      ellipse(center_Target[i].x+300, center_Target[i].y + 200, circle_diam * 2, circle_diam * 2);
    }
}}
