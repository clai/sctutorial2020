



1-1: 複習 SynthDef  - 涵蓋: name、arg、var、Out.ar()

````
// Synth
(
SynthDef(\giveName, { arg ;
	var ;
	Out.ar( );
}).add;
)  
````

1-2: 複習 SynthDef: SinOsc

````
//arg = argument = ()括號外呼叫與更新的值
//var = variable = 不能在括號外()呼叫，只是函式裡代號

(
SynthDef(\sine, {arg freq=440 ;
	Out.ar(0, SinOsc.ar(freq,0,0.1));
}).add;
) 
````

````
// 沒有 var 函式會變成一行不間斷
// 比較以下

(
SynthDef(\sine, {arg freq=440 ;
	var sig;
	sig = SinOsc.ar(freq, 0, 0.1);
	Out.ar(0, sig);
}).add;
) // 加入函式當 code 變長比較好閱讀

x = Synth(\sine, [\freq, 400]); // arg 在 SynthDef 有設定 freq, 這邊才能更新
x.set(\freq,500);
````

1-3: 複習 SynthDef: Blip

````
(
SynthDef(\blip, {arg  pitch=60, speed=6;
	var sig, amp, freq;
	amp = LFNoise0.kr(2).range(0.1,0.5);
	freq = LFNoise0.kr(speed).exprange(1,15);
	sig = Blip.ar(pitch.midicps, freq.round(1).poll, amp);
	Out.ar(0, sig);
}).add;
)

x = Synth(\blip, [\pitch, exprand(40,70)]); //
x.set(\pitch,[57,60,55,61].choose); // 選擇其一 []
x.set(\speed,10);
````



2-1: 聲音開始與結束 ADSR: Envelope : EnvGen.kr

![ADSR - Envelop](https://www.arthurcarabott.com/assets/projects/mui-envelope/img/curve-adsr.png)

````
(
SynthDef(\sineEnv, { arg freq=440,amp=0.5, attack=0.01; //先設定引數預設值
	var sig, env, out;
	sig = SinOsc.ar(freq, mul:amp);
	env = EnvGen.kr(Env.perc(attack,0.5),doneAction:2);
	//聲音開始到結束 Attack, Delay, Sustain, Release (ADSR)
	out = Out.ar(0,sig*env); //一定要有 Output UGen 聲音才會撥出 (0=Left, 1=Right)
}).add;
)

x = Synth(\sineEnv);
x.free;
Pbind(\instrument, \sineEnv, \dur, 0.25, \freq, 500).play; //晚點多解釋 Sequence

````

2-2: 聲音開始與結束 XLine.kr(), Env.new, Env.perc, 

![Env.new](https://www.arthurcarabott.com/assets/projects/mui-envelope/img/supercollider-env.png)

````
//XLine
{XLine.kr(0.1,0.8,5, doneAction:2)}.plot;
{XLine.kr(1,0.01,2, doneAction:2)}.plot;
````

````
//Env
Env.perc(0.01,1,1,4).plot; //plot = 圖示
Env.perc(0.01,1,1,-4).plot; //curve = 彎曲面
Env.perc(1,0.1,1,4).plot;
Env.new(levels:[0, 0.3, 0],times:[1, 1]).plot;
Env.new(levels:[0, 0.3, 0.3, 0],times:[1, 1, 2]).plot;
Env.new(levels:[0, 0.3, 0.6, 0],times:[1, 1, 2]).plot;
Env.new(levels:[0.01, 0.6, 0.2, 0.01], times:[1, 1, 1], curve:\lin).plot;
Env.new(levels:[0.01, 0.6, 0.2, 0.01], times:[1, 1, 1], curve:[0,-3,3]).plot;
````

````
//Apply 應用
(
SynthDef(\sineEnv, { arg freq=440,amp=0.5, attack=0.01, out=0; //先設定引數預設值
	var sig, env;
	sig = SinOsc.ar(freq, mul:amp);
	env = XLine.kr(0.01, 0.7, 5, doneAction:2);
	
	//env = EnvGen.kr(Env.perc(1,0.1,1), doneAction:2);
	//env = EnvGen.kr(Env.new(levels:[0, 0.3, 0],times:[1, 1]), doneAction:0); 
	// 無聲後還在Server上
	//env = EnvGen.kr(Env.new(levels:[0, 0.3, 0.3, 0],times:[1, 1, 2]), doneAction:2); 
	// doneAction:2 無聲後消失
	//env = EnvGen.kr(Env.new(levels:[0, 0.3, 0.6, 0],times:[1, 1, 2]), doneAction:2); 
	//env = EnvGen.kr(Env.new(levels:[0.01, 0.6, 0.2, 0.01], times:[0.01, 1, 0.1], curve:\exp), doneAction:2); 
	//聲音開始到結束 Attack, Delay, Sustain, Release (ADSR)
	
	out = Out.ar(out,sig*env);
}).play;
)

x = Synth(\sineEnv);
s.plotTree; // 查看是否還有東西在 Server

````

3-1: 效果器：FreeVerb.ar(mix, room, damp) // 一種 Reverb 殘響

````
(
SynthDef(\blipEnvReverb, {arg speed=6, amp=0.5, pitch=60, out=0 ;
	var sig, env, freq, harmonics;
	env =  EnvGen.kr(Env.new(levels:[0, 0.3, 0.6, 0],times:[1, 3, 2]), doneAction:2);
	harmonics = LFNoise0.kr(speed).exprange(1,15);
	freq = LFNoise0.kr(8).exprange(56,74).round(5);
	//sig = Blip.ar(pitch.midicps, harmonics.round(1).poll, amp);
	sig = Blip.ar(freq.midicps, harmonics.round(1).poll, amp);
	sig = FreeVerb.ar(sig, mix:0.7, room:0.6);
	Out.ar(out, sig*env);
}).add;
)

x = Synth(\blipEnvReverb);
````

3-2: 效果器：CombN.ar(input, maxDelayTime, delayTime, decayTime) // 一種 Delay 延遲

````
(
SynthDef(\blipEnvDelay, {arg speed=8, amp=0.6, pitch=60, out=0 ;
	var sig, env;
	env =  Line.kr(1,0,0.1);
	sig = Blip.ar(440, 5, mul:amp)*env;
	sig = CombN.ar(sig, 1, 0.2, 6);
	sig = FreeVerb.ar(sig, 0.3, 0.8);
	Out.ar(out, sig);
}).add;
)

x = Synth(\blipEnvDelay);
x.free;
````

3.3: 效果器: Resonz.ar(input, freq, Q) //一種 Resonant 諧振

````
(
SynthDef(\blipEnvDelayResonz, {arg speed=8, amp=0.6, pitch=60, out=0 ;
	var sig, env;
	env = Line.kr(1,0,0.1);
	sig = Blip.ar(440, 5, mul:amp)*env;
	sig = CombN.ar(sig, 1, 0.2, 6);
	sig = Resonz.ar(sig, 880, 0.1);
	sig = FreeVerb.ar(sig, 0.3, 0.8);
	Out.ar(out, sig);
}).add;
)

x = Synth(\blipEnvDelayResonz, [\q, 0.01]);
x = Synth(\blipEnvDelayResonz, [\q, 0.4]);
x.free;
````

````
// Reson + WhiteNoise

(
SynthDef(\noiseResonz, {arg out=0, resFreq=880, q=0.1 ;
	var sig, env;
	sig = WhiteNoise.ar(0.5);
	sig = Resonz.ar(sig, resFreq, q);
	Out.ar(out, sig);
}).add;
)

x = Synth(\noiseResonz);
x.set(\resFreq, 1200);
x.set(\q, 0.01);
x.set(\q, 0.3);
x.free;
````

3.4: 效果器: HPF.ar(input, freq) // 過濾

````
(
SynthDef(\noiseHPF, {arg out=0, amp=0.2 ;
	var sig, env, freq;
	freq = MouseX.kr(20,18000);
	sig = WhiteNoise.ar(0.5);
	sig = HPF.ar(sig, freq, amp);
	Out.ar(out, sig);
}).add;
)

x = Synth(\noiseHPF);
x.free;
````

````
(
SynthDef(\blipHPF, {arg speed=8, amp=0.6, pitch=60, out=0 ;
	var sig, env, freq;
	freq = MouseX.kr(100,8000);
	sig = Blip.ar(100, 20, mul:amp);
	sig = HPF.ar(sig, freq, mul:0.5);
	Out.ar(out, sig);
}).add;
)

x = Synth(\blipHPF);
x.free;
````

-----

預習...

----

4.1 Buffer

````
~b1 = Buffer.read(s,"path.wav");
~b1.play;
~b1.bufnum;
~b1.sampleRate;
~b1.numFrames;
~b1.query;
~b1.duration;

~b2 = Buffer.read(s,"path.wav");
~b2.play;
~b2.bufnum;
~b2.sampleRate;
~b2.numFrames;
~b2.query;
~b2.duration;
````

4.2 Buffer 寫入 SynthDef

````
(
SynthDef(\bufplay, {arg out=0, buf=0, rate=1, start=0, loop=0, amp=0.5, done=2, maxdelay = 0, delay=0, decay=0;
	var sig;
	sig = PlayBuf.ar(2,
		buf,
		BufRateScale.kr(buf)*rate,
		1,
		start * 48000,
		loop,
		doneAction:done);
	sig = FreeVerb.ar(sig);
	sig = CombN.ar(sig, maxdelay, delay, decay);
	Out.ar(out, sig*amp);
}).add;
)

//b1
Synth(\bufplay, [\buf, ~b1.bufnum, \rate, 1, \start, 0, \amp, 1]);
Synth(\bufplay, [\buf, ~b1.bufnum, \rate, 1, \start, 7, \amp, 1]);
Synth(\bufplay, [\buf, ~b1.bufnum, \rate, -1, \start, 1]);

//b2
Synth(\bufplay, [\buf, ~b2.bufnum, \rate, 1, \start, 0]);
Synth(\bufplay, [\buf, ~b2.bufnum, \rate, 0.8, \start, 0]);
Synth(\bufplay, [\buf, ~b2.bufnum, \rate, -1, \start, ~b2.duration.round(0.01)]);
Synth(\bufplay, [\buf, ~b2.bufnum, \rate, 1, \start, 0, \done, 0, \maxdelay, 0.1, \delay, 0.5, \decay, 10]);
````

