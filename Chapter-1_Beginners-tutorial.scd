// 1.1 Hello World

// Everyone has to start here
'Hello World!'

// sets the default server to variable s and boots it
Server.default = s = Server.internal.boot;

// Some examples from the Tutorial
play({SinOsc.ar(LFNoise0.kr(12, mul: 600, add: 1000), 0.3)});

// Subtractive synthesis
play({RLPF.ar(Dust.ar([1, 100]), LFNoise0.ar(1/[3, 4], 1500, 1600), 0.02)});

// Additive synthesis
play({
	var sines = 50, speed = 6;
	Mix.fill(sines, {
		arg x;
		Pan2.ar(
			SinOsc.ar(
				x+1*100,
				mul: max(0, LFNoise1.kr(speed) + Line.kr(1, -1, 30))
			), rand2(1.0)
		)
	})/sines
});

==

// 1.2 Messages and  arguments

// generates random values
rand(100.0);
exprand(1.0, 100.0); // exponential

// duplicator
dup('echo', 20);

// rounds to x decimal places
round([3.141, 5.674, 34.657], 0.01);

// sorts an array
sort([34, 2, 467, 23, 2567]);

==

// 1.5 Enclosures

// Functions
{exprand(1.0, 100.0)};
{SinOsc.ar([200, 250])}.play;

==

// 1.9 Synth Definitions

{SinOsc.ar([440, 439])}.play;
// creates a temp__number synth def

SynthDef('sine1', {Out.ar(0, SinOsc.ar(220))}).play
SynthDef('sine2', {Out.ar(0, SinOsc.ar(440))}).play
// creates named synth defs and plays immediately

SynthDef('sine3', {Out.ar(0, SinOsc.ar(660))}).add
(SynthDef('sine4', {
	arg freq = 440;
	Out.ar(0, SinOsc.ar(freq))}
).add)
// creates and stores named synth defs

a = Synth('sine4', ['freq', 220]);
b = Synth('sine4', ['freq', 2200]);
// plays named synth def with given parameter that was set as an argument

a.set('freq', 990);
b.set('freq', 1010);
// sets value for parameter while playing

a.free
b.free

==

// 1.10 Buses, Buffers and Nodes

// useful to get current location
~cuurentLoc = thisProcess.nowExecutingPath.dirname;

// load sounds into Buffers
~houston = Buffer.read(s, '../../../System/Library/Sounds/Basso.aiff');
~chooston = Buffer.read(s, '../../../System/Library/Sounds/Blow.aiff');

{PlayBuf.ar(2, ~houston, loop: 1, rate: 1)}.play;
{PlayBuf.ar(2, ~chooston, loop: 1, rate: 1)}.play;

// phasing example
(
{
	var rate, trigger, frames;

	rate = [0.7, 0.8];
	trigger = Impulse.kr(rate);
	frames = ~chooston.numFrames;

	PlayBuf.ar(1, ~chooston, 0.5, trigger);
}.play
)

// speed and direction change example
(
{
	var speed, direction;
	speed = LFNoise0.kr(12) * 0.2 + 1;
	direction = LFClipNoise.kr(1/3);
	PlayBuf.ar(2, ~chooston, (speed * direction), loop: 1);
}.play
)

// Using buses to connnect controls
(
~kbus1 = Bus.control;
~kbus2 = Bus.control;
)

// our speed and direction change example from above
// the control buses have replaced the hard-coded values
(
{
	var speed, direction;
	speed = LFNoise0.kr(~kbus1, 1) * 0.2 + 1;
	direction = LFClipNoise.kr(~kbus2);
	PlayBuf.ar(1, ~chooston, (speed * direction), loop: 1);
}.play
)

(
// start the controls
{Out.kr(~kbus1, LFNoise0.kr(12))}.play;
{Out.kr(~kbus2, LFClipNoise.kr(1/4))}.play
)

// send the second buffer to the right channel
(
{
	var speed, direction;
	speed = In.kr(~kbus1, 1) * 0.2 + 1;
	direction = In.kr(~kbus2);
	Out.kr(~kbus2, PlayBuf.ar(2, ~houston, (speed * direction), loop: 1));
}.play
)

// this isn't really doing what is expected but I'm not really sure why not

==

~kbus3 = Bus.control;
~kbus4 = Bus.control;

{Out.kr(~kbus3, SinOsc.kr(3).scope('out3') * 100)}.play;
{Out.kr(~kbus4, LFPulse.kr(1/3).scope('out4') * 200)}.play;
{Out.ar(0, SinOsc.ar(In.kr(~kbus3) + In.kr(~kbus4) + 440).scope('left'))}.play;
{Out.ar(1, SinOsc.ar(In.kr(~kbus3) + In.kr(~kbus4) + 880).scope('right'))}.play;

// Hmmm, likewise.
// I'm going to leave this section at this point for now and revisit it later
// It does seem pretty important

==

// 1.11 Arrays, Iteration and Logical Expressions

// Creates an array
a = ['C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab', 'A', 'Bb', 'B'];

// Retrieves an item from the array by index
a.at(8);

// Introduces the do method
// see also: loop, while, for, forBy
do(20, {a.at(7.rand).postln});

// Introduces the Task class
// see Routines & Tasks - https://www.evernote.com/shard/s336/nl/52980809/a1a513c6-6781-4bae-bcd8-a7155cd09ee0/
(
Task({
	do(10, {
		['C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab', 'A', 'Bb', 'B'].at(7.rand).postln;
		0.1.wait;
	});
}).play;
)

// Introduces a number of useful array methods:
// wrapAt
(
Task({
	a = ['C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab', 'A', 'Bb', 'B'];
	"count, midi, pitch, octave".postln;

	do(10, {
		arg count;
		p = rrand(36, 72);
		[count, p, a.wrapAt(p), (p/12).round(1) - 1].postln;
		1.wait;
	});
}).play;
)

// Syntax for do
(
do(10, {
	arg i;
	i.postln;
});
)

// Syntax for if
(
if (
	2 === 3,
	{'thats correct!'},
	{'thats bollocks!'}
);
)

// Syntax for Task
(
Task({
	do(10, {
		arg i;
		i.postln;
		1.wait;
	});
}).postln
)

==

// 1.12 How to "Do" an Array

// Simple "do" of an array that shows the two arguments passed by the do method
(
[0, 2, 4, 5, 7, 9, 11].do({
	arg each, count;
	["count", count, "each", each].postln
});
)

// Takes a 12 tone series of musical notes and prints a matrix of each variation
(
var row, inversion, pitchClass;

// array of numbers, 1 - 11, scrambled, 0 added at first position
row = Array.series(11, 1).scramble.insert(0, 0);

// Converts row to a series of numbers: 12, then 11 - 1 in scrambled order
inversion = 12 - row;

// array of musical notes
pitchClass = ["C ", "C# ", "D ", "Eb ", "E ", "F ", "F# ", "G ", "Ab ", "A ", "Bb ", "B "];

inversion.do({
	arg eachInv;

	var trans;

	trans = (row + eachInv);

	trans.do({
		arg scaleDegree;

		pitchClass.wrapAt(scaleDegree).post
	});

	"".postln;
});
"".postln;
)

// Use array for additive synthesis

// a. Generate random amplitude with LFNoise1
{max(0, LFNoise1.ar(5000))}.plot;
{max(0, LFNoise1.kr(12))}.plot;
(
{
	var ampCont = {max(0, LFNoise1.kr(12))};
	SinOsc.ar(440, mul: ampCont)
}. scope
)

// b. Use Mix to mix together an array of UGens
(
{
	Mix.ar(
		Array.fill(20, {
			arg cnt;
			var harm = cnt + 1 * 110;
			SinOsc.ar(
				harm,
				mul: max(
					[0, 0],
					SinOsc.kr(cnt + 1 / 4)
				)
			) * 1 / (cnt + 1)
		});
	) * 0.7
}.scope
)

// c. Creates a collection of bells with Klank
(
{
	var scale, specs, freqs, amps, rings, numRes = 5, bells = 20, pan;

	scale = [60, 62, 64, 67, 69].midicps;

	Mix.fill(bells, {
		freqs = Array.fill(numRes, {rrand(1, 15) * (scale.choose)});
		amps = Array.fill(numRes, {rrand(0.3, 0.9)});
		rings = Array.fill(numRes, {rrand(1.0, 4.0)});
		specs = [freqs, amps, rings].round(0.01);
		specs.postln;
		pan = (LFNoise1.kr(rrand(3, 6)) * 2).softclip;
		Pan2.ar(
			Klank.ar(
				`specs,
				Dust.ar(1 / 6, 0.03)
			),
			pan
		);
	})
}.play
)

==

// Quits the server booted above
s.quit;
