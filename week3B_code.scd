//// SC Workshop 2020.06.17 Taiwan Sound Lab ////
//// Week 3B - Pdef Pbind 循環的排列組合 運用短的聲音  ///////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
// 1. add SynthDef //
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
) // 短的聲音

/////////////////////////////////////////////////////////
// 2. SynthDef in : Pdef, Pbind (Patterns) //

(
Pdef(\pattern_name,
	Pbind(\instrument, \synthDefName,
		\dur, Pseq([1,2,3],inf).next.poll,
		\arg, Pseq([1,2,3],inf)
	)
)
)

Pdef(\pattern_name).play;

/////////////////////////////////////////////////////////

(
Pdef(\p_high,
	Pbind(\instrument, \don,
	\midinote, Pseq([60, 61, 63, 65, 72].scramble,inf).next.poll,
	\dur, Pseq([0.1,0.3,0.1,0.3,0.2,0.2],inf),
	\attack, Pseq([ {rrand(0.01, 0.1)}, {rrand(0.001,0.01)}  ],inf);
)).play;

Pdef(\p_low,
	Pbind(\instrument, \don,
	\midinote, Pseq([57,60,60],inf),
	\dur, Pseq([2,1],inf),
	\attack, Pseq([ {rrand(1, 2)}, {rrand(0.8,1)}  ],inf);
));

Pdef(\p_mid,
	Pbind(\instrument, \sea,
	\density, Prand([4000,2600,4000,5000,3500,4200,2000],inf),
	\pitch, Prand([100,400,200],inf),
	\dur, Pseq([4,5,4.3,3.5,4,5.1],inf),
	\amp, 0.4,
	\panspeed, Prand([-0.1,0.1],inf);
));

Pdef(\buffer,
	~bufferP = Pbind(\instrument, \bufplay,
		\buf, ~b1.bufnum,
		\dur, Prand([0.6,0.2,0.4,0.2],inf),
		\startpos, Prand([0,1,0.3,0.5],inf),
		\rate, Pseq([1,0.96,-1,1.1],inf);
));
)

Pdef(\buffer).play;
Pdef(\p_high).play;
Pdef(\p_mid).play;
Pdef(\p_low).play;

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
//6 Pdef Gui ///////
PdefAllGui(5); // GUI Graphic User Interface 圖像介面

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

Pdef(\buffer).remove;