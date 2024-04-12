COMP    START   0000            .程式開始
FIRST   JSUB    PRINT           .跳轉到PRINT

PRINT   LDA     COUNTER         .將COUNTER儲存到暫存器A   
        COMP    #0              .暫存器A得值與0比較      
        JEQ     IN0             .相等就跳到IN0
        COMP    #1              .暫存器A得值與1比較
        JEQ     IN1             .相等就跳到IN1
        COMP    #2              .暫存器A得值與2比較
        JEQ     IN2             .相等就跳到IN2
        COMP    #3              .暫存器A得值與3比較
        JEQ     IN3             .相等就跳到IN3
AFTER   LDA     COUNTER         .將COUNTER儲存到暫存器A
        ADD     #1              .將暫存器A的值加1
        COMP    #4              .暫存器A的值與4比較
        JEQ     RESET           .相等就進RESET
        STA     COUNTER         .將暫存器A存入COUNTER
        J       PRINT           .跳轉到PRINT

RESET   LDA     #0              .將0存入暫存器A
        STA     COUNTER         .將暫存器A存入COUNTER
        J       PRINT           .跳轉到PRINT

IN0     LDA     #instr0         .將instr0的值透過直接定址載入A暫存器
        JSUB	echostr         .進入echostr
        JSUB    READ0           .進入READ0
        JSUB    READ3           .進入READ3
        J       AFTER           .跳轉到AFTER

IN1     LDA     #instr1         .將instr1的值透過直接定址載入A暫存器
        JSUB	echostr         .進入echostr
        JSUB    READ1           .進入READ1
        JSUB    READ3           .進入READ3
        J       AFTER           .跳轉到AFTER

IN2     LDA     #instr2         .將instr2的值透過直接定址載入A暫存器 
        JSUB	echostr         .進入echostr
        JSUB    READ2           .進入READ2
        JSUB    READ3           .進入READ3
        JSUB    COUNT           .進入COUNT
        JSUB    CTOTAL          .進入CTOTAL
        J       AFTER           .跳轉到AFTER

IN3     LDA     #instr3         .將instr3的值透過直接定址載入A暫存器 
        JSUB    echostr         .進入echostr
        LDA     T1              .十位數(十進制數值)
        ADD     #48             .ASCII code加48 (0)
        WD	stdout          .將暫存器的值寫入 stdout
        LDA     T2              .個位數(十進制數值)
        ADD     #48             .ASCII code加48 (0)
        WD	stdout          .將暫存器的值寫入 stdout
        LDA     #10             .換行鍵ASCII code
        WD	stdout          .將暫存器的值寫入 stdout
        J       AFTER           .跳轉到AFTER

COUNT   LDA     OP              .載入OP到A暫存器
        COMP    #1              .暫存器A得值與1比較
        JEQ     IS_ADD          .如果成立跳轉到IS_ADD
        COMP    #2              .暫存器A得值與2比較
        JEQ     IS_SUB          .如果成立跳轉到IS_SUB
        COMP    #3              .暫存器A得值與3比較
        JEQ     IS_MUL          .如果成立跳轉到IS_MUL
        COMP    #4              .暫存器A得值與4比較
        JEQ     IS_DIV          .如果成立跳轉到IS_DIV
        JSUB    CTOTAL
        RSUB

IS_ADD  LDA     N               .載入N到A暫存器
        ADD     M               .A暫存器的值減M並存回A
        STA     TOTAL           .將暫存器A存入TOTAL
        RSUB                    .return
        
IS_SUB  LDA     N               .載入N到A暫存器
        SUB     M               .A暫存器的值減M並存回A
        STA     TOTAL           .將暫存器A存入TOTAL
        RSUB                    .return
        
IS_MUL  LDA     N               .載入N到A暫存器
        MUL     M               .A暫存器的值乘上M並存回A
        STA     TOTAL           .將暫存器A存入TOTAL
        RSUB                    .return

IS_DIV  LDA     N               .載入N到A暫存器
        DIV     M               .A暫存器的值除以M並存回A
        STA     TOTAL           .將暫存器A存入TOTAL
        RSUB                    .return

echostr	STA	addr            .將A暫存器內容存入 addr 
char	LDCH	@addr	        .從記憶體位址 addr 讀取一個字元到暫存器
	AND	#255            .將暫存器的值與 255 進行 AND 運算
	COMP	#0              .將暫存器的值與 0 比較
	JEQ	return          .如果暫存器的值等於 0，則跳轉到 return (第92行)
	WD	stdout          .將暫存器的值寫入 stdout
	LDA	addr            .將 addr 的值存入暫存器 A 中
	ADD	#1              .將暫存器A的值加1
	STA	addr            .將暫存器 A 的值存入 addr
	J	char            .跳轉至char(第83行)
return	RSUB                    .返回原先呼叫函式

READ0   CLEAR   A               .清除暫存器 A
        TD      INPUT           .測試輸入設備是否就緒
        JEQ     READ0           .如果尚未就緒，則繼續等待，進入 READ0
        RD      INPUT           .從輸入設備讀取一個字元放入暫存器 A(ASCII code)
        SUB     #48             .減 ASCII code '0' 的值（48），存入暫存器 A
        STA     N               .將暫存器 A 的值存入 N
        RSUB                    .返回原先呼叫函式

READ1   CLEAR   A               .清除暫存器 A
        TD      INPUT           .測試輸入設備是否就緒
        JEQ     READ1           .如果尚未就緒，則繼續等待，進入 READ1
        RD      INPUT           .從輸入設備讀取一個字元放入暫存器 A(ASCII code)
        SUB     #48             .減 ASCII code '0' 的值（48），存入暫存器 A
        STA     OP              .將暫存器 A 的值存入 OP
        RSUB                    .返回原先呼叫函式

READ2   CLEAR   A               .清除暫存器 A
        TD      INPUT           .測試輸入設備是否就緒
        JEQ     READ2           .如果尚未就緒，則繼續等待，進入 READ2
        RD      INPUT           .從輸入設備讀取一個字元放入暫存器 A(ASCII code)
        SUB     #48             .減 ASCII code '0' 的值（48），存入暫存器 A
        STA     M               .將暫存器 A 的值存入 M
        RSUB                    .返回原先呼叫函式


READ3   CLEAR   A               .清除暫存器 A
        TD      INPUT           .測試輸入設備是否就緒
        JEQ     READ3           .如果尚未就緒，則繼續等待，進入 READ3
        RD      INPUT           .從輸入設備讀取一個字元放入暫存器 A(ASCII code)
        SUB     #48             .減 ASCII code '0' 的值（48），存入暫存器 A
        STA     BUFFER          .將暫存器 A 的值存入 BUFFER(用來存放enter鍵)
        RSUB                    .返回原先呼叫函式


CTOTAL  LDA     TOTAL           .將TOTAL的值存入暫存器Ａ
        DIV     #10             .將暫存器 A 的值除10
        STA     T1              .將暫存器 A 的值存入 T1（十位數）
        STA     tmp             .將暫存器 A 的值存入 tmp
        LDA     tmp             .載入 tmp 到暫存器 A 
        MUL     #10             .將暫存器 A 的值乘10
        STA     tmp             .將暫存器 A 的值存入 tmp
        LDA     TOTAL           .載入 TOTAL 到暫存器 A 
        SUB     tmp             .將暫存器 A 的值減 tmp 的值
        STA     T2              .將暫存器 A 的值存入 T2（個位數）
        RSUB                    .返回原先呼叫函式




addr	RESW	1
INPUT   BYTE    X'00'           .INPUT初始16進制為00
LENGTH  RESW    2
N       WORD    20              .第一個數字
OP      WORD    3               .運算子（+:1,-:2,*:3,/:4)
M       WORD    10              .第二個數字
TOTAL   WORD    0               .運算結果
T1      WORD    0               .十
T2      WORD    0               .個
tmp     WORD    0               .暫存
BUFFER  WORD    0               .存放多於的enter鍵
COUNTER WORD    0               .計數器用來判斷執行到哪個步驟

RESULT  BYTE    0
endinstr        BYTE  0
instr0  BYTE    C'please input a number1:'                              .字串宣告方式C
endinstr0       BYTE  0
instr1  BYTE    C'please input a operator(+:1,-:2,*:3,/:4):'            .字串宣告方式C
endinstr1       BYTE  0
instr2  BYTE    C'please input a number2:'                              .字串宣告方式C
endinstr2       BYTE  0
instr3  BYTE    C'result='                                              .字串宣告方式C    
stdout  BYTE    1
