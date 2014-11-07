
/*
###########
Set up the sounds
Using Granular Synthesis
###########
*/

// Load the sounds
(
 var basePath = thisProcess.nowExecutingPath.dirname;

 var b = Buffer.read(
    Server.default,
	path: basePath +/+ "sounds/KuatroSound1_1_1.wav";,
    bufnum: 0
 );

 b = Buffer.read(
    Server.default,
	path: basePath +/+ "sounds/KuatroSound2_1_2.wav";,
    bufnum: 1
 );

 b = Buffer.read(
    Server.default,
	path: basePath +/+ "sounds/KuatroSound3_1_1.wav";,
    bufnum: 2
 );

// Create new Synth Defs to be controlled by user coordinate
// via incoming OSC messages.
SynthDef(\user1sound, {
	arg userX = 0, userY = 0;
    var buffer = 0, grains;

    grains = TGrains.ar(
        numChannels: 2,
		trigger: Impulse.ar(userX.linexp(0,1000, 5, 100)),
        bufnum: buffer,
        rate: 1,
		centerPos: userY.linlin(0, 1000, 0.0, BufDur.ir(buffer)/3) + WhiteNoise.ar(0.01),
        dur: 0.1,
        pan: WhiteNoise.ar,
        amp: 0.9
    );
    Out.ar(0, grains)
}).add;

SynthDef(\user2sound, {
	arg userX = 0, userY = 0;
    var buffer = 1, grains;

    grains = TGrains.ar(
        numChannels: 2,
		trigger: Impulse.ar(userX.linexp(0,1000, 5, 100)),
        bufnum: buffer,
        rate: 1,
		centerPos: userY.linlin(0, 1000, 0.0, BufDur.ir(buffer)/3) + WhiteNoise.ar(0.01),
        dur: 0.1,
        pan: WhiteNoise.ar,
        amp: 0.9
    );
    Out.ar(0, grains)
}).add;



SynthDef(\user3sound, {
	arg userX = 0, userY = 0;
    var buffer = 2, grains;

    grains = TGrains.ar(
        numChannels: 2,
		trigger: Impulse.ar(userY.linexp(0,1000, 5, 100)),
        bufnum: buffer,
        rate: 1,
		centerPos: userX.linlin(0, 1000, 0.0, BufDur.ir(buffer)/3) + WhiteNoise.ar(0.01),
        dur: 0.1,
        pan: WhiteNoise.ar,
        amp: 0.9
    );
    Out.ar(0, grains)
}).add;

/*
###############
Kuatro Setup
###############
*/


/*
Setup Connection to Kuatro Server
*/

m = NetAddr("localhost", 50505);
m.sendMsg("/kuatro/registerView","localhost", NetAddr.langPort);

/*
User Data
*/
~users = Dictionary.new();                          // data structure to store user number and sound
~sounds = [\user1sound, \user2sound, \user3sound];  // list of synthdefs to be assigned to a new user


/*
Setup OSC Input Functions
*/
~newUserOSC = OSCFunc( { | msg, time, addr, port |

	// Get data from OSC Message
	var user, x, y, z;
	user = msg[1];
	x = msg[2];
	y = msg[3];
	z = msg[4];

	("New User: " + user + " x: " + x + " y: " + y + " z: " +  z  ).postln;
	~users.put(user, Synth(~sounds[user%3]));

}, '/kuatro/newUser' );

~userCoordsOSC = OSCFunc( { | msg, time, addr, port |

	// Get data from OSC Message
	var user, x, y, z;
	user = msg[1];
	x = msg[2];
	y = msg[3];
	z = msg[4];

	("Move User: " + user + " x: " + x + " y: " + y + " z: " +  z  ).postln;

	// Modify the sounds...
	~users.at(user).set(\userX,x, \userY, y);

}, '/kuatro/userCoordinates' );

~lostUserOSC = OSCFunc( { | msg, time, addr, port |

	// Get data from OSC Message
	var userSynth, user;
	user = msg[1];

	("Lost User: " + user ).postln;

	// Stop the sounds...
	g = ~users.removeAt(user);
	g.free;

}, '/kuatro/lostUser' );

)

