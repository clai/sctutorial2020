//// SC Workshop 2020.06.03 Taiwan Sound Lab ////
//// Week 1-A ///////////////////////////////////


//2. 執行與回傳 //////////////////////////
"hello sound people".postln;

(
"what?".postln;
"meow".postln;
)

1+1;
2pi;
3.cubed; // 立方
69.midicps; // 轉換 midi 數值到 CPS(Freq) 數值
440.cpsmidi; // 轉換 CPS(Freq) 到 midi 數值

/////////////

(
Task({
	3.do({ |i|
		i=i+1;
		i.postln;
		1.wait;
	});
}).start;
)  // Task (執行工作：跑10個增量數值 / 間隔：秒數)

(
t = TempoClock.new;
t.tempo_(120/60).play(
	r = Routine({
	3.do {
		"***".postln; 0.5.wait;
		"_*_".postln; 0.1.wait;
	}});
)
) // Routine（執行工作：跑10個數值 / 間隔：節拍器*秒數關係）

//4. 應用 ///////////////////////////////
(
var value;
value = 3;
value = 3.cubed;
value = value + 1;
value = value / 2 * 0.5;
value;
)

//5. 錯誤 Error //////////////////////////
3,cubed;



