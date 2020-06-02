### SuperCollider Workshop - Basics w/Sounds
2020.06.03 @ 19:00-21:00 | Prepared by Lisa

Week 1 B

1. 製造聲音，啟動 **scsynth** - audio server

   ````
   s.boot; // 啟動 // 或是 Server.local.boot;
   s.quit; // 結束 // 或是 Server.local.quit; 
   ````

   ＊ 另外可以先打開 

   ​			Server > **Show Server Meter**

   ​			Server > **Show Scope**

   ​			Server > **Show FreqScope**

2. UGen: **SinOsc.ar**

   ````
   {SinOsc.ar(440,0,0.2)}.play; 
   
   /* 
   SinOsc 是正弦波振盪器包含4個數值
   arguments：(freq, phase, mul, add) // 也有預設值
   引數: (音高頻率，相位，輸出音量，加輸出數值 offset)
   ar 是 audio rate; 會發出聲音，預設值每秒採樣44100
   kr 是 control rate; 採樣 ar 的1/64，適合拿來 modulate 調變
   */
   ````

3. 變化寫法1 


   ````
   x = {SinOsc.ar(440, mul:0.2)}.play; 
   x.free;
   // 跳位置指定 arg 數值 
   // 加上 variable 
   ````

   變化寫法2  

   ````
   (
   x = {
   	arg freq=440, amp=0.2;
   	var sig;
   	sig = SinOsc.ar(freq)*amp;
   }.play;
   )
   // arg 數值
   x.set(\freq, 220);
   x.set(\freq, 550, \amp, 0.1);
   x.free;
   // 播放中更新 arg 數值
   ````

4. UGen : *noise & oscillator*

   | UGen       |            | Example                                                      |
   | ---------- | ---------- | ------------------------------------------------------------ |
   | LFNoise0   | Step Noise | {LFNoise0.ar([100,10],mul:0.1)}.play;                        |
   | LFNoise1   | Ramp Noise | {LFNoise1.ar([100,200],mul:0.3)}.play;                       |
   | LFTri      | 三角波     | {LFTri.ar(40,mul:0.3)}.play;                                 |
   | LFSaw      | 鋸齒波     | {LFSaw.ar(MouseX.kr(10,440),mul:0.1)}.play;                  |
   | LFPulse    | Pulse波    | {LFPulse.ar(50,width:MouseX.kr(0.01,0.6),mul:0.1)}.play;     |
   | Blip       | 含泛音     | {Blip.ar(440,numharm:MouseX.kr(1,100),mul:0.1)}.play;        |
   | WhiteNoise | 白噪音     | {WhiteNoise.ar(0.1, mul:MouseY.kr(0,0.1))}.play;             |
   | Dust       | 塵         | {Dust.ar(10,mul:0.4)}.play;                                  |
   | Gendy1     | 隨機       | {Gendy1.ar(minfreq:1, maxfreq:100, durscale:0.001, mul:0.4)}.play; |

5. UGen 控制 UGen : **LFNoise.ar**

   ````
   x = {LFNoise0.ar([10,15],0.5,0)}.play;
   x.free;
   // step noise
   
   x = {LFNoise0.ar(XLine.kr(1, 1000, 10), 0.2) }.play;
   x.free;
   // modulate LFNoise freq
   
   x = {SinOsc.ar(LFNoise0.kr(8).range(60,1000).poll, 0, 0.2)}.play;
   x.free;
   // as SinOsc freq modulator
   
   z = {
   	var freq, amp;
   	freq = LFNoise0.kr(8,400,600).poll;
   	amp = LFNoise1.kr(8).range(0.01,0.5);
   	SinOsc.ar(freq, 0, amp);
   }.play;
   z.free;
   
   ````

6. SynthDef 寫入變成聲響樂器 (變化寫法3)

   ````
   // Synth Defination: LFNoise + SinOsc
   
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
   ````

    SynthDef: SinOsc + Envelop

   ````
   //Synth Defination: SinOsc + Envelop
   
   (
   SynthDef(\sine, { arg freq=440,amp=0.1, attack=0.01; //先設定引數預設值
   	var sig, env, out;
   	sig = SinOsc.ar(freq, mul:amp); 
   	env = EnvGen.kr(Env.perc(attack,0.5),doneAction:2); 
   	//聲音開始到結束 Attack, Release (ADSR)
   	out = Out.ar(0,sig*env); 
     //out = Out.ar(0,sig);
   }).add;
   )
   
   x= Synth(\sine);
   x.free;
   ````

7. SC 常用捷徑：

   | 捷徑  | 功能         | 說明                                                |
   | :---- | ------------ | --------------------------------------------------- |
   | ⇧ ↵   | 執行編碼     | 執行選取的那段或滑鼠游標那行 code (Selection, Line) |
   | ⌘↵    | 執行編碼     | 執行游標那段的 code（Selection, Region)             |
   | ⌘ .   | 停止執行     | 正在跑的執行會全部一起停下來                        |
   | ⌘ b   | 起始聲音引擎 | 右下角Server後的數字從灰色變綠色 或是  s.boot;      |
   | ⌘ d   | 說明檔       | 滑鼠選取UGen後才按下                                |
   | ⌘ ⇧ p | 清除回傳視窗 | 清除回傳視窗                                        |

   ⌘ = comand (mac) / ctrl (windows) | ⇧ = shift | ↵ = enter

