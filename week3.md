

Week 3 - SuperCollider Workshop 
// Routine, Pattern, Ndef //



A. **Routine**: 常式 - 進行經常性工作之程式
組織: 以時間和次數組織結構
狀態: 只有寫入 'text'.postln 在 post window 看到執行狀況
Synth: 短音(有EnvGen.kr或doneAction) 或 長音


B. **Pdef**, **Pbind** (Pattern): 時間循環的型態
組織: 以 Sequence 搭配時間循環組織結構
狀態: 有 GUI 圖像介面，可控制 pause / resume（暫停/繼續）
Synth: 短音(有EnvGen.kr或doneAction) 

C. **Ndef**: Node
time: JIT = Just in Time, 即時可透過 GUI 控制參數
狀態: 有 GUI 圖像介面，可控制 pause / resume（暫停/繼續），和有寫入的參數 arg
Synth: 長音



-------

A. Routine

````
(
r = Routine({
	15.do {
		"1st action_ ".post;
		Synth(\dondon, [\midinote, [72,60,64,65,70].choose]);
		0.5.wait;
		
		"2nd action_ ".post;
		Synth(\dondon, [\midinote, [72,60,64,65,70].choose]);
		rrand(0.1, 0.3).wait;
		
		"3rd action_ ".postln;
		Synth(\dondon, [\midinote, [72,60,64,65,70].choose]);
		rrand(0.3,0.5).wait;
	}
}).play;
)
````

B. Pdef(Pbind)

````
PdefAllGui(5); // GUI Graphic User Interface 圖像介面

(
Pdef(\pattern_name,
	Pbind(\instrument, \synthDefName,
		\dur, Pseq([1,2,3],inf).next.poll,
		\arg, Pseq([1,2,3],inf);
	))
)

Pdef(\pattern_name).play;
````

C. Ndef

````
n = NdefMixer.new(s,4); // GUI
Spec.add(\amp,  [0.1, 1, \lin, 0.01]);//set range

(
Ndef(\noisey, {arg amp=0.5, speed=8;
	var source;
	source = Klank.ar(`[90, 0.5, 1], Decay.ar(Impulse.ar(speed), XLine.kr(0.1,0.8,0.5), 			 	ClipNoise.ar(XLine.kr(0.1,0.2,0.5)))) ;
	source = source *amp; 
});
) // 不需要 Out.ar, 也不用.add

Ndef(\noisey).play;
````

