# superCollider Kuatro View

The SuperCollider Kuatro View is an OSC client based on the Kuatro Framework (ADD LINK). It implements the OSC messaging contract as described for the Kuatro Framework. 

Running this script will create three SynthDefs that use granular synthesis techniques.  The OSC callback functions will start, manipulate and stop the sounds as users enter, move and leave the tracked Kuatro space.  The grains are modified by users' x and y coordinates in the space.  X modifies the grains' triggers and Y modifies the grains' center positions.


## To use this view:
NOTE: Instructions assume you are familiar with the Kuatro.


1. Launch kuatroBegin.py to start up the Kuatro
2. Open KuatroView.scd in superCollider
3. Launch the superCollider Server
  - cmd-b (or crtl-b on Windows)
4. Run the superCollider script
  - Place your cursor in the text editor
  - cmd-enter (or crtl-enter on Windows)