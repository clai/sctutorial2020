//// SC Workshop 2020.06.03 Taiwan Sound Lab ////
//// Week 1-B ///////////////////////////////////


//1. Start Audio Server//////////////////////////
s.boot; // 啟動
//Server.local.boot;
s.quit; // 結束
//Server.local.boot;


//2. UGen: SinOsc///////////////////////////////
{SinOsc.ar(440, 0, 0.1, 0)}.play;
//正弦波 arg：(freq, phase, mul, add)


//3. 變化寫法1 //////////////////////////////////
x = {SinOsc.ar(440, mul:0.2)}.play;
x.free;

//   變化寫法2 //////////////////////////////////
(
x = {
	arg freq=440, amp=0.2;
	var sig;
	sig = SinOsc.ar(freq)*amp;
}.play;
)

x.set(\freq, 220);
x.set(\freq, 550, \amp, 0.1);
x.free;

//4. UGen: Noise and Osc/////////////////////////

n = {LFNoise0.ar([100,10],mul:0.1)}.play;
n.free;

~n1 = {LFNoise1.ar([100,200],mul:0.3)}.play;
~n1.free;

~tri = {LFTri.ar([40,40],mul:0.3)}.play;
~tri.free;

~saw = {LFSaw.ar(MouseX.kr(10,440),mul:0.1)}.play;
~saw.free;

~pulse = {LFPulse.ar(50,width:MouseX.kr(0.01,0.6),mul:0.1)}.play;
~pulse.free;

~blip = {Blip.ar(440,numharm:XLine.kr(1,100,10),mul:0.2)}.play;
~blip.free;

~white = {WhiteNoise.ar(0.1, mul:MouseY.kr(0,0.1))}.play;
~white.free;

~dust = {Dust.ar(10,mul:0.3)}.play;
~dust.free;

~gendy = {Gendy1.ar(minfreq:[1,10], maxfreq:[100,30], durscale:0.001, mul:0.5)}.play;
~gendy.free;

//5. UGen 控制 UGen /////////////////////////

x = {LFNoise0.ar([10,15],0.5,0)}.play;
x.free;
x = {LFNoise0.ar(XLine.kr(1, 1000, 10), 0.2)}.play;
x.free;
x = {LFNoise0.ar(SinOsc.kr(5).range(100,5000).poll, 0.2)}.play;
x.free;
x = {LFNoise0.ar(SinOsc.kr(5).exprange(100,5000).poll, 0.2)}.play;
x.free;
x = {SinOsc.ar(LFNoise0.kr(8).range(60,1000).poll, 0, 0.2)}.play;
x.free;

z = {
	var freq, amp, sig;
	freq = LFNoise0.kr(8,400,600).poll;
	//freq = LFNoise0.kr(8).range(200,1000); //也可以這樣寫
	amp = LFNoise1.kr(8).range(0.01,0.5);
	sig = SinOsc.ar(freq, 0, amp);
}.play;

z.free;

// 6. SynthDef  寫入變成聲響樂器: 變化寫法3 /////////////////////////////
// LFNoise0 + SinOsc
(
SynthDef(\sineTest, { arg noiseFreq=8;
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseFreq,400,600).poll;
	amp = LFNoise1.kr(8).range(0.01,0.5);
	sig = SinOsc.ar(freq, 0, amp);
	Out.ar(0, sig);
}).add;
)

x = Synth(\sineTest);
x.free;
x = Synth(\sineTest,[\noiseFreq, 4]);
x.set(\noiseFreq, 32);
x.free;

// SinOsc + Envelop
(
SynthDef(\sine, { arg freq=440,amp=0.1, attack=0.01; //先設定引數預設值
	var sig, env, out;
	sig = SinOsc.ar(freq, mul:amp);
	env = EnvGen.kr(Env.perc(attack,0.5),doneAction:2);
	//聲音開始到結束 Attack, Release (ADSR)
	out = Out.ar(0,sig*env); //一定要有 Output UGen 聲音才會撥出 (0=Left, 1=Right)
  //out = Out.ar(0,sig);
}).add;
)

Synth(\sine);
Synth(\sine,[\freq, 300, \amp, 0.2, \attack, 1]);
Synth(\sine,[\freq, 300*2]);

////////
