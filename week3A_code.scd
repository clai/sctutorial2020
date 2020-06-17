//// SC Workshop 2020.06.17 Taiwan Sound Lab ////
//// Week 3A- Buffer & Routine  /////////////////
////////////////////////////////////////////////
//1 Buffer 音檔

~b1 = Buffer.read(s,"/Users/LL 1/Documents/Work/工作坊/2020SuperCollider/sounds/motorbike.wav");
~b1.bufnum;
~b1.duration;
~b2.query;

~b2 = Buffer.read(s,"/Users/LL 1/Documents/Work/工作坊/2020SuperCollider/sounds/escalator.wav");
~b2.bufnum;
~b2.duration;
~b2.query;

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
//2 Buffer 寫入 SynthDef
(
SynthDef(\bufplay, {arg out=0, buf=0, rate=1, startpos=0, loop=0, amp=0.7, done=2, maxdelay = 0, delay=0, decay=0, attack=0.1, release=1;
	var sig, env;
	sig = PlayBuf.ar(2,
		buf,
		BufRateScale.kr(buf)*rate,
		1,
		startpos * 48000,
		loop,
		doneAction:0);
	env = EnvGen.kr(Env.perc(attack,release), doneAction:2);
	sig = FreeVerb.ar(sig);
	sig = CombN.ar(sig, maxdelay, delay, decay);
	Out.ar(out, sig*amp*env);
}).add;
) // 短的聲音

x = Synth(\bufplay, [\buf, ~b2.bufnum, \release, 4]);

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
//3 Routine
(
r = Routine({
	3.do {
		"1st action_ ".post;
		1.wait;
		"2nd action_ ".post;
		1.wait;
		"all done : ".post;
		rrand(0.5,1.5).postln.wait;
	}
}).play;
)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
//4 短的聲音 SynthDef(doneAction:2) + Routine
(
r = Routine({
	25.do {
		"1st action_ ".post;
		Synth(\bufplay, [\buf, ~b2.bufnum, \release, 0.01, \startpos, rrand(0.0,2.0)]);
		0.05.wait;
		"2nd action_ ".post;
		Synth(\bufplay, [\buf, ~b2.bufnum, \release, rrand(0.05,0.1), \startpos, rrand(0.0,2.0)]);
		rrand(0.2, 0.3).wait;
		"3rd action_ ".postln;
		Synth(\bufplay, [\buf, ~b2.bufnum, \release, rrand(0.1,0.2), \startpos, rrand(0.0,2.0)]);
		rrand(0.2,0.4).wait;
	}
}).play;
)

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// 其他 SynthDef // // 短的聲音 都有 Envelope 或 doneAction
(
SynthDef(\don, { arg midinote=55, amp=0.5, attack=0.1, release=0.5;
	var sig;
	sig = SinOsc.ar(midinote.midicps) * EnvGen.kr(Env.perc(attack,release), doneAction: 2);
	Out.ar([0,1] , sig*amp);
}).add;

SynthDef(\dondon,{ arg out=0, midinote=73, speed=4, amp=0.3;
	var sig, vibrato, env;
	vibrato = Impulse.kr(speed).range(1, 5);
	env = EnvGen.kr(Env.linen(0.1, 0.5, 0.7, 0.1, 0), doneAction:2);
	sig = RLPF.ar(FSinOsc.ar(midinote.midicps*vibrato))*env;
	Out.ar(out,sig*amp);
}).add;

SynthDef(\sea, { arg freq=1, time=3, density=4000, pitch=100, amp=0.5, panspeed=0.1;
	var env, sig;
	env = EnvGen.kr(Env.linen(1.5, 1, time, 0.2, -4), doneAction:2);
	sig = SinOsc.ar( WhiteNoise.ar(density, pitch))*env;
	Out.ar(0,  LinPan2.ar(sig, FSinOsc.kr(panspeed))*amp);
}).add;
)
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// 其他 SynthDef + Routine
(
o = Routine({
	15.do {
		"1st action_ ".post;
		Synth(\dondon, [\midinote, [72,60,64,65,70].choose, \out, [0,1].choose;]);
		0.5.wait;
		"2nd action_ ".post;
		Synth(\dondon, [\midinote, [72,60,64,65,70].choose, \out, [0,1].choose;]);
		rrand(0.1, 0.3).wait;
		"3rd action_ ".postln;
		Synth(\dondon, [\midinote, [72,60,64,65,70].choose, \out, [0,1].choose;]);
		rrand(0.3,0.5).wait;
	}
}).play;
)
/////
(
y = Routine({
	15.do {
		"1st action_ ".post;
		Synth(\don, [\midinote, rrand(56,72).round(5), \attack, rrand(0.05,0.1)]);
		0.1.wait;
	}; //執行15次後
	0.5.wait;

	2.do {
		Synth(\dondon, [\midinote, [72,60,64,65,70].choose, \out, [1,0].choose]);
		0.5.wait;
	}; //再執行2次
}).play;
)
////////////另一種 Random 用法 //////
(
a = Prand(#[60, 62, 64, 65], inf).asStream;
b = Pseq([60,62,64,65],inf).asStream;

r = Routine({
    100.do({
        //Synth(\don, [\midinote, a.next]);
		Synth(\don, [\midinote, b.next, \release,0.1, \amp, rrand(0.1,0.4).postln]);
        0.2.wait;
    })
}).play;
)

r.stop;
