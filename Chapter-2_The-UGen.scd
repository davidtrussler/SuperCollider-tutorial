Server.default = s = Server.internal;

// Multi-channel expansion of UGen

s.boot;

z = s.scope(4);

// a) Mono output
(
SynthDef(\syndef_a, {
	Out.ar(0, SinOsc.ar(440, 0, 0.1))
}).add;
)

a = Synth(\syndef_a);

a.free;

// b) Multi-channel output
(
SynthDef(\syndef_b, {
	Out.ar(0, SinOsc.ar([440, 550, 660, 770], 0, 0.1))
}).add;
)

a = Synth(\syndef_b);

a.free;

// c) Multi-channel output with mul expressed as array
(
SynthDef(\syndef_c, {
	Out.ar(0, SinOsc.ar([440, 550, 660, 770], 0, [0.1, 0.2, 0.3, 0.4]))
}).add;
)

a = Synth(\syndef_c);

a.free;

// d) Multi-channel output with mul expressed as array, summed together
(
SynthDef(\syndef_d, {
	Out.ar(0, SinOsc.ar([440, 550, 660, 770], 0, [0.1, 0.2, 0.3, 0.4]).sum)
}).add;
)

a = Synth(\syndef_d);

a.free;

s.quit;
