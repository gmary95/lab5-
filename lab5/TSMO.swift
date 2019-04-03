class TSMO {
    unit SystService; interface
    uses Generator;
    Type
    TSMO=class //об’єкт «система масового обслуговування»
    private
    NumChannel, MaxQueue: integer; //кількість пристроїв обслуговування TimeFinServ: Array of Double; //
    StateChannel: Array of integer; //поточний стан пристроїв
    StateQueue: integer; //поточний стан черги
    Serv: double;
    Entry: boolean;
    Exit: boolean;
    tmin:double;
    minChannel:integer;
    block: boolean;
    public
    Constructor Create(aNum:integer;aMax:integer;aTimeMod:double;aServ:double);
    // в конструкторі об’єкта «система масового обслуговування» задаються // значення кількості пристроїв обслуговування aNum,
    // обмеження на довжину черги aMax,
    // середня тривалість обслуговування aServ,
    // значення часу моделювання aTimeMod procedure Seize(at:double);
    // зайняти СМО
    procedure Releize(aChannel:integer;aTimeMod:double;at:double);
    //звільнити СМО
    function GetStateQue:integer;
    procedure SeizeChannel(aChannel:integer;at:double);
    //зайняти пристрій з номером aChannel
    procedure ReleizeChannel(aChannel:integer;aTimeMod:double);
    //звільнити пристрій з номером aChannel
    procedure NextTime; //запам’ятати найближчу події у СМО
    function GetStateChannel(aNum:integer):integer;
    procedure SetExit(aEnt:boolean);
    procedure SetEntry(aEx:boolean);
    function GetMinTime:double;
    function GetMinChannel:integer;
    function GetNumChannel:integer;
    function GetAverLoadChannel:double; //підрахувати середню кількість зайнятих
    пристроїв
    function GetBlock:boolean; //повідомити про стан блокування
    end; implementation
    182
    Constructor TSMO.Create; var i: integer;
    begin
    inherited Create;
    StateQueue:=0; //початковий стан черги
    MaxQueue:=aMax;
    NumChannel:=aNum;
    Serv:=aServ;
    Entry:=False;
    Exit:=False;
    block:=false; // в початковий момент блокування маршруту відсутнє SetLength(TimeFinServ, NumChannel);
    SetLength(StateChannel, NumChannel);
    for i:=0 to NumChannel-1 do
    end;
    begin TimeFinServ[i]:=aTimeMod; StateChannel[i]:=0;
    end;
    //початковий стан пристроїв - вільний
    NextTime; // формувати найближчу подію в СМО end;
    procedure TSMO.Seize(at:double);
    var j:boolean; i:integer;
    begin
    if Entry=true then begin
    j:= false; i:=1;
    while (i<=NumChannel) and (j=false) do
    if StateChannel[i-1]=0 then
    begin
    j:=true;
    SeizeChannel(i,at);
    NextTime; // змінити найближчу подію в СМО Entry:=false;
    end else i:=i+1;
    end;
    if (j=false) and (MaxQueue>0) then begin
    StateQueue:= StateQueue+1;
    Entry:=false;
    if StateQueue=MaxQueue then block:=true; end;
    procedure TSMO.Releize(aChannel:integer;aTimeMod:double;at:double); begin
    if StateQueue>0 then begin StateQueue:= StateQueue-1;
    183
    
    if block=true then block:=false; SeizeChannel(aChannel,at); NextTime;
    end else begin ReleizeChannel(aChannel,aTimeMod); NextTime;
    end;
    Exit:=true; end;
    function TSMO.GetStateQue:integer; begin
    result:=StateQueue;
    end;
    procedure TSMO.SeizeChannel(aChannel:integer;at:double); begin
    StateChannel[aChannel-1]:=1; TimeFinServ[aChannel-1]:=at+GenExp(Serv);
    end;
    procedure TSMO.ReleizeChannel(aChannel:integer;aTimeMod:double); begin
    StateChannel[aChannel-1]:=0;
    TimeFinServ[aChannel-1]:=aTimeMod;
    end;
    function TSMO.GetStateChannel(aNum:integer):integer; begin
    result:=StateChannel[aNum-1];
    end;
    function TSMO.GetAverLoadChannel:double; var sum,i: integer;
    begin
    sum:=0;
    for i:=1 to GetNumChannel do begin sum:=sum+StateChannel[i-1]; end;
    result:=sum; end;
    function TSMO.GetNumChannel:integer; begin
    result:=NumChannel;
    end;
    184
    
    function TSMO.GetBlock:boolean; begin
    result:=block;
    end;
    procedure TSMO.SetExit(aEnt:boolean); begin
    Exit:=aEnt;
    end;
    procedure TSMO.SetEntry(aEx:boolean); begin
    Entry:=aEx;
    end;
    procedure TSMO.NextTime; var i: integer;
    begin tmin:=TimeFinServ[0]; minChannel:=1;
    if NumChannel>1 then begin
    for i:=1 to NumChannel do begin
    if TimeFinServ[i-1]<tmin then begin
    tmin:=TimeFinServ[i-1]; minChannel:=i;
    end;
    end; end;
    end;
    function TSMO.GetMinTime:double; begin
    result:=tmin;
    end;
    function TSMO.GetMinChannel:integer; begin
    result:=minChannel;
    end;
    end.
}
