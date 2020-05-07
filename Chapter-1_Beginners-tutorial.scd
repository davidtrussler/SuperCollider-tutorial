// 1.1 Hello World

// Everyone has to start here
'Hello World!'

// sets the default server to variable s and boots it
Server.default = s = Server.internal.boot;

// Quits the server booted above
s.quit;

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

// Help!

Env // command D

==

// UGen: Phase Modulation Sine Oscillator
{PMOsc.ar(carfreq: 440, modfreq: MouseY.kr(1, 550), pmindex: MouseX.kr(1, 15))}.play;

// UGen: Band Limited Impulse Oscillator
{Blip.ar(freq: 2)}.play;

// UGen: Impulse Oscillator
{Impulse.ar(freq: 5)}.play;

==

// Tutorial examples

// Figure 1.4
Blip.ar(

)

==

got up to p.27, receivers etc.

==

{SinOsc.ar([440, 439])}.play;

SynthDef('sine1', {Out.ar(0, SinOsc.ar(220))}).play
SynthDef('sine2', {Out.ar(0, SinOsc.ar(440))}).play
SynthDef('sine3', {Out.ar(0, SinOsc.ar(660))}).add
(SynthDef('sine4', {
	arg freq = 440;
	Out.ar(0, SinOsc.ar(freq))}
).add)

a = Synth('sine4', ['freq', 220]);
b = Synth('sine4', ['freq', 220]);

a.set('freq', 990);
b.set('freq', 1010);

a.free
b.free

~houston = Buffer.read(s, '../../../System/Library/Sounds/Basso.aiff');
~chooston = Buffer.read(s, '../../../System/Library/Sounds/Blow.aiff');

{PlayBuf.ar(2, ~houston, loop: 1, rate: 0.25)}.play;
{PlayBuf.ar(2, ~chooston, loop: 1, rate: 0.5)}.play;

( // phasing
{
	var rate, trigger, frames;

	rate = [0.7, 0.8];
	trigger = Impulse.kr(rate);
	frames = ~chooston.numFrames;

	PlayBuf.ar(1, ~chooston, 0.5, trigger);
}.play
)

(
~kbus1 = Bus.control;
~kbus2 = Bus.control;
)

({
	var speed, direction;
	speed = In.kr(~kbus1, 1) * 0.2 + 1;
	direction = In.kr(~kbus2);
	PlayBuf.ar(1, ~chooston, (speed * direction), loop: 1);
}.play)

(
{Out.kr(~kbus1, LFNoise0.kr(12))}.play;
{Out.kr(~kbus2, LFClipNoise.kr(1/4))}.play;
)

({
	var speed, direction;
	speed = In.kr(~kbus1, 1) * 0.2 + 1;
	direction = In.kr(~kbus2);
	Out.ar(1, PlayBuf.ar(1, ~houston, (speed * direction), loop: 1));
}.play)

==

~kbus3 = Bus.control;
~kbus4 = Bus.control;

{Out.kr(~kbus3, SinOsc.kr(3).scope('out3') * 100)}.play;
{Out.kr(~kbus4, LFPulse.kr(1/3).scope('out4') * 200)}.play;
{Out.ar(0, SinOsc.ar(In.kr(~kbus3) + In.kr(~kbus4) + 440).scope('left'))}.play;

// arrays and looops and stuff

a = ['C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab', 'A', 'Bb', 'B'];
a.at(8);
do(20, {a.at(7.rand).postln});

loop while for forBy

(
Task({
	do(10, {
		['C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab', 'A', 'Bb', 'B'].at(7.rand).postln;
		0.1.wait;
	});
}).play;
)

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

// syntax for loop
(
do(10, {
	arg i;
	i.postln;
});
)

// syntax for if statement
(
if (
	2 == 3,
	{'thats correct!'},
	{'thats bollocks!'}
);
)

// Boolean operators
3 >= 3;

(
Task({
	do(10, {
		arg i;
		i.postln;
		1.wait;
	});
}).postln
)
