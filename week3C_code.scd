//// SC Workshop 2020.06.17 Taiwan Sound Lab ////
//// Week 3C - Ndef ////////////////////////////
////////////////////////////////////////////////
///////////////////////////////////////////////
// 1. SynthDef
(
SynthDef(\noisey, { arg  out=0, amp=0.5, speed=8 ;
	var source;
	source = Klank.ar(`[90, 0.3, 0.9], Decay.ar(Impulse.ar(speed), XLine.kr(0.1,0.5,0.5), 			 	ClipNoise.ar(XLine.kr(0.1,0.2,0.5)))) ;
	source = source *amp;
	Out.ar(out, source);
}).add; //長的聲音，沒有 release time
)

y =  Synth(\noisey, [\out, [0,1].choose.postln]);
y.free;

///////////////////////////////////////////////
// 2. 長的聲音 轉成 Ndef : SynthDef->Ndef
(
Ndef(\noisey, {arg amp=0.5, speed=8;
	var source;
	source = Klank.ar(`[90, 0.5, 1], Decay.ar(Impulse.ar(speed), XLine.kr(0.1,0.8,0.5), 			 	ClipNoise.ar(XLine.kr(0.1,0.2,0.5)))) ;
	source = source *amp; // Out 拿掉
});
)
//Out.ar(out, source*amp);
//不用加 .add

Ndef(\noisey).play;

///////////////////////////////////////////////
// 3. Ndef Mixer ///

n = NdefMixer.new(s,4);

Spec.add(\amp,  [0.1, 1, \lin, 0.01]);//set range
Spec.add(\speed ,  [0.5, 23, \lin, 0.01]);//set range

Ndef(\noisey).play;
Ndef(\noisey).pause;
Ndef(\noisey).resume;
Ndef(\noisey).clear;
