SuperCollider Workshop - Basics
Prepared by Lisa
2020.06.03 @ 19:00-21:00
Week 1 / A+B


* 下載：https://supercollider.github.io/download
* SuperCollider 討論區 https://scsynth.org/
* 打開 SuperCollider (SC)
  編輯碼、說明視窗、執行回傳視窗

![SC_windows](https://lh3.googleusercontent.com/pHPttuynsu9bTX78hxgQwd1zxqWNdpmv0w_zyL1M1QvTuOR7_jZ-1zBjvPpZD0Nt8ToMfYvoEnH_frkjIA-_CIUk9QE946666ncdCnPpghKTVg2JKMkiBL9LxKDA_327cSn6_9ArWxBsZ8Bp9E4MBlTMj0RqaDoBta2DDLXzLxXw0x-ToTkAPcPXiq1OukciX0nf44CqMPFwgDo1ITvg8dRVnUDTcGZHBQQooCGOEnqOVlYSOuvCvRTeg64tJNjQUQS-8DW7Qugxr-Hq4KJWHSV7r0rPdmYlxojy1cyKm_TJhY7VQenu5Rc5bqywzVqwd9fLLGXKNn8_6vYuzbs_I1ZEcKMJs1ZATvDj2GywIDOcv6XEDKvxejT2dvCXJSE-kDfBvKRn3xROjL-X3WxF-UcfGBX3IneOtbEekQkW3FicazEaolYbj4u-s--bryd0kyhrHzeusVqf_QSWKYAKHDMqdUK539DvweBNMVDfZFtSNL59RcfuH0ybzYJPBp7_LTZXjLUVMJMF98lR2ArZz5qCVTQoFY-ihcXTlK6E1dlFF7if-OGscI4SwzsOY9TMlbimBGjoKmGJiJ3ahRgv4h3bYO5rUm3cIKL8iPXnF860k62TVlBS1qNs7FXu4p12c7hSxtO9A337ile4ydUk03vzGnqeiDw1ViU064Y_MpSTgrpXt1M34_PueE971Q=w2352-h1498-no?authuser=0)

1. SC 由兩個部分組成：

   ​	程式語言 **sclang** : client / the language

   ​	聲音引擎 **scsynth** : server application / audio engine

2. [範例 code] 執行與回傳 sclang：

   ```
   "hello sound people".postln;
   ```

   ````
   (
   "what?".postln;
   "meow".postln;
   )
   ````

   也可以算數學

   ```
   1+1;
   2pi; 
   3.cubed; // 立方
   69.midicps; // 轉換 midi 數值到 CPS(Freq) 數值
   440.cpsmidi; // 轉換 CPS(Freq) 到 midi 數值
   ```

    執行常式 Task, Routine

   ````
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
   ````

   

3. 註解、分號、逗號、括號、變數

   ````
   // 註解 comment
   
   /* 
   註解 
   */
   
   ; 一行 code 的最後要加分號
   
   , 分開參數或是陣列組的逗號
   
   [A,B,C] 陣列用的括號
   {Function} 運算式用的括號
   ( ) 劃界用的括號
   | x = 10 | 引數 argument 用 pipe style
   arg x = 10; 引數 argument 
   
   變數 Variable 
   a = 12;         // a 是區域變數 Local variable 
   var aa; aa = 12 // aa 是區域變數 Local variable 
   ~aa = 12;       // ~aa 是全域變數 Global varibale
   ````

4. 應用

   ````
   (
   var value;
   value = 3;
   value = 3.cubed;
   value = value + 1;
   value = value / 2 * 0.5;
   value;
   )
   ````

5. 錯誤訊息 Error

   ````
   3,cubed;
   // 回傳視窗會表示：語法錯誤 syntax error 
   ````

6. Sandwich.make // Object, Message, Arguments

   ```````
   // object.message (method) // 
   
   Sandwich.make(bread, vegArray, meat); // make 是 message, 括號內的引數 arg
   Sandwich.make(toast, [tomato, lettuce], ham); 
   
   Sandwich.cut(angle, number); // cut 是 message, 括號內的引數 arg
   Sandwich.cut(90, 6); 
   
   ```````

7. SC 常用捷徑：

   | 捷徑  | 功能         | 說明                                                |
   | :---- | ------------ | --------------------------------------------------- |
   | ⇧ ↵   | 執行編碼     | 執行選取的那段或滑鼠游標那行 code (Selection, Line) |
   | ⌘↵    | 執行編碼     | 執行游標那段的 code（Selection, Region)             |
   | ⌘ .   | 停止執行     | 正在跑的執行會全部一起停下來                        |
   | ⌘ ⇧ p | 清除回傳視窗 | 清除回傳視窗                                        |

   ⌘ = comand (mac) / ctrl (windows) | ⇧ = shift | ↵ = enter

