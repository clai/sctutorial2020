
# SuperCollider Tutorial - 1

下載與安裝：[https://supercollider.github.io/download](https://supercollider.github.io/download)

## 1. SuperCollider Environment 
- 編輯工作區 Workspace
- 說明文件 Help Documentation
- 執行視窗 Post Window

| shortcut          | 功能           |  
| ----------------- |:--------------:| 
| cmd+shift+L       | compile library | 
| cmd+d             | 查詢說明檔 - 選關鍵字 |  
| cmd+shift+p       | 清除執行視窗 |  


![sc window](http://2.bp.blogspot.com/-SgA8B9YKk5s/VKwWNWlDONI/AAAAAAAAEMo/LR88wLwBVxs/s480/scwin.jpg)


## 2. (SC) Basics <br>
- sclang 程式語言 Programming Language: variable 參數, comment 註解, array 陣列    
- scsynth 製造聲音 Audio Server: 
    UGen - unit generators: \
    SynthDef 合成發聲器: 包含 SinOsc, Filter, Buffer \
    Message: .boot .play .stop .add .scope .plot 


//=========================================









<br>MAC

- shift+return //  來執行某行或選擇的 code  
- cmd+. //  停止
- cmd+shift+p // 清除 post window (有潔癖的人可能不三時會想 clean 一下）
- cmd+d // 搜尋說明...求救檔（需先選取某個 Class 或是 UGens 再按喔）

<br>

- Help.gui // 說明視窗

Windows 

- 執行 ctrl+enter 
- 停止 ctrl+. 
<br>

//=========================================
