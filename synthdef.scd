////////////////////////////////////////////
//* 短聲音 SynthDef 合成聲音參考: 這些都有 doneAction///
(
SynthDef(\don, { | freq= 150, amp=0.5, gate=1|
		Out.ar([0,1], SinOsc.ar(freq, mul:amp) *
		EnvGen.kr(Env.perc, gate, doneAction: 2))
}).play;
)
(
SynthDef(\dondon,{ | out=0, pitch=2, speed=4, amp=0.5|
	var source, vibrato;
	vibrato = Impulse.kr(speed, 0, 1, 1);
	source = RLPF.ar(FSinOsc.ar([190*pitch, 280*pitch]*vibrato),
		mul: EnvGen.kr(Env.linen(0.1, 0.8, 0.9, 0.1, -4)));
	DetectSilence.ar(source, doneAction:2);
	Out.ar(0,source*amp);
}).play;
)
(
SynthDef(\klankie, { |pitch=1, amp=0.5|
	var source, kl ;
	kl=[800, 1071, 1153, 2023] ;
	source = Klank.ar(`[(kl*1.5), 0.3, [0.5, 1, 2, 0.5]],SinOsc.ar(pitch*400, mul: XLine.ar(0.35, 0.000001, 2)));
	Out.ar([0,1], source*amp);
	DetectSilence.ar(source, doneAction:2);
}).play;
)
(
SynthDef(\sea, { arg freq=1, time=3, density=4000, pitch=100, amp=0.4, panspeed=0.1;
	var env, sig;
	env = EnvGen.kr(Env.linen(1.5, 1, time, 0.2, -4), doneAction:2);
	sig = SinOsc.ar( WhiteNoise.ar(density, pitch))*env;
	Out.ar(0,  LinPan2.ar(sig, FSinOsc.kr(panspeed))*amp);
}).play;
)
(
SynthDef(\telep, { | out=0, pitch=1000, amp=0.3|
	var source;
		source = LFPulse.ar(7, mul:200, add: pitch);
		Out.ar(out, SinOsc.ar(source, mul:XLine.kr(0.1, 0.01, 1.2, doneAction:2)*amp))
}).play;
)
(
SynthDef(\noisey, { |gate = 1, speed=8, amp=0.5|
	var source;
	source = Klank.ar(`[90, 0.3, 0.9],
			 	Decay.ar(Impulse.ar(speed), XLine.kr(0.1,0.5,0.5), 			 	ClipNoise.ar(XLine.kr(0.1,0.2,0.5)))) ;
	source = source * EnvGen.kr(Env.perc(0.4,2,0.5), gate, doneAction: 2)*amp;
	Out.ar([0,1], source;)
}).play;
)