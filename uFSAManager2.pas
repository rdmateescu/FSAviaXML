
//----------------------------------------------------------
//if u like it use it , do not modifiy the code yourself
//send a email at adunatura.de.prosti@gmail.com
//I would be pleased if someone chooses to pay, but there's absolutely no obligation to do so, especially if they feel the code worth it.
//  lgging system very is simple should be replaced with something better , it should be use only for debug purposes
// if an action has the DoNothing it will not be called
//id are optional but recomended
// warning if the action has no name the entire Action xml node will be ignored
//the event OnEnter and OnExit in any state will be executed when enetring or exiting the state
//any type of state can have a superstate, recomandation a superstate should
// not generate a state change
//any state can have 1 -n events
//events can have
//            state change
//           1-n actions
//an action can be called b4 or after state change, recomended after
//an action can auto generate events in function of the result of the function result
//if it is true then the  eventToSendAtEndWithSuccess will be added to the queue of events
//if it is false then the  eventToSendAtEndWithFailure will be added to the queue of events



{  xml example the id can be names
<root>
  <state name="Start" idstate="0" idsuperstate="9">
    <event name="aaaa" idevent="0" idnextstate="1">
      <action name="bbb" idaction="1" callBeforeStateChange="false" />
      <action name="ccc" idaction="2" callBeforeStateChange="false" />
      <action name="ddd" idaction="3" callBeforeStateChange="false"
         />
    </event>
  </state>

  <state name="xxxx" idstate="1" idsuperstate="9">
    <event name="aaaa" idevent="0" idnextstate="9">
      <action name="bbb" idaction="1" callBeforeStateChange="false" />
      <action name="ccc" idaction="2" callBeforeStateChange="false" />
      <action name="ddd" idaction="3" callBeforeStateChange="false"
         />
    </event>
  </state>

  <state name="bbbb" idstate="9" idsuperstate="20">
    <event name="eee" idevent="95" idnextstate="9">
      <action name="fff" idaction="951" callBeforeStateChange="false"  />
      <action name="ggg" idaction="952" callBeforeStateChange="false"
         eventToSendAtEndWithSuccess ="ffff" eventToSendAtEndWithFailure ="nnn" />
    </event>

    <event name="ffff" idevent="96" idnextstate="9">
      <action name="iii" idaction="961" callBeforeStateChange="false" />
      <action name="jjj" idaction="971" callBeforeStateChange="false"/>
      <action name="kkk" idaction="962" callBeforeStateChange="false"
         eventToSendAtEndWithSuccess ="ggg" />
    </event>

    <event name="ggg" idevent="97" idnextstate="9">
      <action name="lll" idaction="971" callBeforeStateChange="false"/>
      <action name="mmm" idaction="972" callBeforeStateChange="false"
        eventToSendAtEndWithSuccess ="ccc" />
    </event>

  </state>
  <state name="ccc" idstate="20">
    <event name="nnn" idevent="201" idnextstate="20">
      <action name="ooo" idaction="2011" callBeforeStateChange="false" />
      <action name="ppp" idaction="2012" callBeforeStateChange="false" />
    </event>
  </state>

</root>

or without ID

<root>
  <state name="Start"  idsuperstate="bbbb">
    <event name="aaaa"  idnextstate="xxxx">
      <action name="bbb" idaction="1" callBeforeStateChange="false" />
      <action name="ccc" idaction="2" callBeforeStateChange="false" />
      <action name="ddd" idaction="3" callBeforeStateChange="false"
         />
    </event>
  </state>

  <state name="xxxx"  idsuperstate="bbbb">
    <event name="aaaa"  idnextstate="bbbb">
      <action name="bbb" callBeforeStateChange="false" />
      <action name="ccc"  callBeforeStateChange="false" />
      <action name="ddd"  callBeforeStateChange="false"
         />
    </event>
  </state>

  <state name="bbbb"  idsuperstate="ttttt">
    <event name="eee"  > //this means the next state is the current state
      <action name="fff"  callBeforeStateChange="false"  />
      <action name="ggg" callBeforeStateChange="false"
         eventToSendAtEndWithSuccess ="ffff" eventToSendAtEndWithFailure ="nnn" />
    </event>

    <event name="ffff">
      <action name="iii"  callBeforeStateChange="false" />
      <action name="jjj"  callBeforeStateChange="false"/>
      <action name="kkk" callBeforeStateChange="false"
         eventToSendAtEndWithSuccess ="ggg" />
    </event>

    <event name="ggg" >
      <action name="lll"  callBeforeStateChange="false"/>
      <action name="mmm" callBeforeStateChange="false"
        eventToSendAtEndWithSuccess ="ccc" />
    </event>

  </state>
  <state name="ccc" idsuperstate="ttttt">
    <event name="nnn" idevent="201" idnextstate="ttttt">
      <action name="ooo" idaction="2011" callBeforeStateChange="false" />
      <action name="ppp" idaction="2012" callBeforeStateChange="false" />
    </event>
  </state>
   <state name="ttttt"  >
    <event name="aaaa" >
      <action name="bbb" callBeforeStateChange="false" />
      <action name="ccc"  callBeforeStateChange="false" />
      <action name="ddd"  callBeforeStateChange="false"
         />
    </event>
  </state>
</root>

how to use
1. create the xml containing the FSA
2.create the procedure that will be tied to the actions by using  the
 CreateListOfProcedures in separate mini project, put the ListWithCode param
 of this procedure in TMemo#
3.Implement the "actions" from ur code
4.Input the event that will start the FSA


problems that might arise
  1. wrong actionname in xml vs code
  2.wrong event name in xml vs code
  3. no more events in fsa so it will stop and wait for the bnext event
  4.if u use as id numbers be carefull not to duplicate them


}


unit uFSAManager2;

interface

uses
  System.SysUtils, System.Classes
  ,Xml.XMLIntf, Xml.XMLDoc,
  System.Generics.Collections
  ,System.Rtti, System.TypInfo
  ,System.SyncObjs
  ;


const
  ParametersNameList : array of string = ['CurrentStateName','NextStateName'
    ,'EventName','ActionName','dummy'];


type

  TCrossPlatformLogger = class
  private

  public
    class var sClassLogFileName:string;
    class var bEnableLogs:boolean;
    class var bLogFailed:boolean;
    class function GetLogFilePath: string;
    class procedure NewLogs;
    class procedure LogAction(const currentstatename,NextSTateNAme, eventname
      ,actionName: string;Const bResult:boolean);//;var sFileName:string);
    class procedure LogNameValue(const name
      ,value: string );//var sFileName:string) ;
    class procedure InitLogs;
  end;


  //will be used in TACtion
  {
  TLogEnterFunctionProcedure = procedure (const sFunctionName:string) of object ;
  TLogExitFunctionProcedure = procedure (const sFunctionName:string) of object ;
  TLogSendNameValue = procedure (const sName,sValue:string) of object ;
  TLogExceptionRaised = procedure (const sExceptionMessage:string) of object ;
  }
  TActionFunction = function (const CurrentStateName,NextStateName,EventName
    ,ActionName:string):boolean of object ;


  //will be used in  Tstatecollection.inputevent if the TAcvtion does not have
  //TActionProcedure
  TActionDispatcherProcedure = procedure (const CurrentStateName,NextStateName
    ,EventName,ActionName,dummy:string) of object ;

  TQueueStrings = class;
  TStateEvent = class;
  //action ; what to do when a event is sent to a state
  TAction = class
  private
    FOwner:TStateEvent;
    FName: string;
    FIdAction: Integer;
    FEventToSendAtEndWithFailure,FEventToSendAtEndWithSuccess :string;
    //will be called
    FActionCallBack : TActionFunction;
    //call  FActionCallBack b4 or after staTWE CHANGE
    FCallBackBefareStateChange:boolean;
  public
    constructor Create(Owner:TStateEvent);
    property Name: string read FName write FName;
    property IdAction: Integer read FIdAction write FIdAction;
    property CallBackBefareStateChange:  boolean
      read FCallBackBefareStateChange write FCallBackBefareStateChange ;
    property ActionCallBack: TActionFunction read FActionCallBack
      write FActionCallBack;
    property EventToSendAtEndWithSuccess :string
      read FEventToSendAtEndWithSuccess
      write FEventToSendAtEndWithSuccess;
    property EventToSendAtEndWithFailure :string
      read FEventToSendAtEndWithFailure
      write FEventToSendAtEndWithFailure;
    function DoActionCallBack(const CurrentStateName,NextStateName,EventName
      ,ActionName:string):boolean;
  end;

  TState = class;

  //event that will be rcvd by a state
  TStateEvent = class
  private
    FOwner:TState;
    FName: string;
    FIdStateEvent: Integer;
    //actions that must be executed for this event
    FActions: TObjectList<TAction>;
    //next state
    FIdNextState:integer;
    function GetIdNextState:integer;
  protected
    FNameNextState:string;
  public
    constructor Create(AOwner: TState);
    destructor Destroy; override;
    property Name: string read FName write FName;
    property IdStateEvent: Integer read FIdStateEvent write FIdStateEvent;
    property IdNextState: Integer read GetIdNextState write FIdNextState;
    property Actions: TObjectList<TAction> read FActions;
  end;

  //state  of the FSA
  TState = class(TCollectionItem)
  private
    FName: string;
    FIdState: Integer;
    fOnEnterEventExists:boolean;
    fOnExitEventExists:boolean;
    //superstate
    FIdSuperState: Integer;

    //list of possible events for this state
    FEvents: TSTringList;

    function RunAllActions(const CurrEvent:TStateEvent
        ; const bLaunchBeforeStateChange:boolean
      ):boolean ;

    function GetIdSuperState:integer;
  protected
    FNameSuperState :string;
  public
    IdEqualTOIdState:boolean;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    property OnEnterEventExists:boolean read fOnEnterEventExists
      write fOnEnterEventExists;
    property OnExitEventExists:boolean read fOnExitEventExists
      write fOnExitEventExists;

    property Name: string read FName write FName;
    property IdState: Integer read FIdState write FIdState;
    property IdSuperState: Integer read GetIdSuperState write FIdSuperState;
    property Events: TStringList read FEvents;
    //return the eventt wtih the given id
    function FindEventName(const sEventName:string): TStateEvent;
    function FindEventByID(const iEventID:integer): TStateEvent;

    function InPutEventInThisState(const sEventName:string
        ;out NextState:TState
      ):boolean;

    function AddEvent(const sEventName:string;const Event:TStateEvent):boolean;


  end;

  TFSAThreaded = class;

  //collection of states actiually a the FSA engine
  TStateCollection = class(TCollection)
  private

    fProcessinEvents:booleaN;
    FSAThread:TFSAThreaded;
    FEventsQueue: TQueueStrings;
    FCurrentState:TState;
    FActionDispatcherCallBack : TActionDispatcherProcedure ;
    FInternalProcedureList: TList<TPair<string, TActionFunction>>;
    function GetState(Index: Integer): TState;
    
    function RunEventsFromQueueUseItemsFunctions(var localCurrentState:TState
        ;const bIsSUperState :boolean
        ;Var HasChangedStates :boolean
      ):boolean; 
      
    procedure SetCurrentState(State :TState);
    procedure RunDispatcherCallBack(Event: TStateEvent; NextState: TState);
    procedure RunOnEnterAndOnExitEventsIfTheyExists
      (var localCurrentState: TState; OldState: TState
        //; const bIsSUperState: Boolean
        );

  public
    LogFileName:String;
    property States[Index: Integer]: TState read GetState; default;
    property   CurentState : TState read FCurrentState write SetCurrentState ;
    property ActionDispatcherCallBack : TActionDispatcherProcedure
      read FActionDispatcherCallBack write FActionDispatcherCallBack ;
    property InternalProcedureList:TList<TPair<string, TActionFunction>>
      read FInternalProcedureList write FInternalProcedureList;
    property  EventsQueue: TQueueStrings read FEventsQueue write FEventsQueue;


    constructor Create(ItemClass: TCollectionItemClass);
    destructor Destroy; override;

    //return a state with the given id
    function GetStateByIdState(const idState:integer):TState;
    function GetStateByName(const sStateName:string):TState;
    //input an event in the FSA
    function InputEvent(const sEventName:string) : boolean; overload;
    // get the list of procedures that could be used in a TACTION
    function GetFunctionNames(const AClass: TComponent):boolean; overload;
    function EnumToString<T>(const EnumValue: T): string;
    function AddState(const sName:string;const idState:integer):TState;
  end;

  TXMLParser = class(TComponent)
  private
    //remembver the biggest id used 
    fMAXStateID:integer;
    fErrorList:TStringList;
    FEnableErrorList:boolean;
    fXML:TXMLDocument;
    bFSALoaded :boolean;
    function HiddenParseXML(const FileName: string
        ;const ComponentWithProceduresForActions:Tcomponent
        ;var ListOfActionsNotAssigned:TStringList
      ):TStateCollection;
    procedure SaveTheProcedureNameThatDoesNotExistsInTheListOfNotAssigned
      (Action: TAction; var ListOfActionsNotAssigned: TStringList);
    procedure FindAndSetActionCallBackWithProcedureFromCode
      (StateCollection: TStateCollection; Action: TAction);
    procedure CheckAndSetTheCallBeforeStateChangeAttribute(ActionNode: IXMLNode
      ; Action: TAction);
    procedure FindAndSaveEventToSendAfterActionSuccess(ActionNode: IXMLNode
      ; var Action: TAction; var sEventToSendAtEndOfACtion: string);
    procedure FindAndSetEvent2SendAfterActionFailure(ActionNode: IXMLNode
      ; var Action: TAction);
    procedure FindOrCalculateTheActionID(EventNode: IXMLNode; sTemp: string
      ; Event: TStateEvent; ActionNode: IXMLNode; var sCalculatedActionID: string);
    procedure FindOrCalculateEventID(State: TState; EventNode: IXMLNode
      ; var sTemp: string; var sCalculatedEventIDid: string);
    procedure FindOrCalculateStateID(StateCollection: TStateCollection
      ; StateNode: IXMLNode; var sCalculatedStateID: string);
    procedure SetTheStartingState(var StateCollection: TStateCollection
      ; State: TState);
    procedure SetStateSuperState(StateNode: IXMLNode; Var State: TState
      ;var TempFSA :TStateCollection);
    procedure SetEventNextSTateIDFromXMLFile(EventNode: IXMLNode
      ; Var State : TState;Var Event: TStateEvent;var TempFSA :TStateCollection);
    procedure AddEventIdErrorToListOfError(iIdForDuplicateCkeck: Integer
      ; sEventNameFoprDuplicateCheck: string; bEventAsIntegerUnique: Boolean
      ; bEventIdAsStringUnique: Boolean);
    procedure AddStateIdErrorToErrorList(iIdForDuplicateCkeck: Integer
      ; sStateNameFoprDuplicateCheck: string; bStateIdAsStringUnique: Boolean
      ; bStateIDAsIntegerUnique: Boolean);
    procedure AddErrorStringToErrorList(const sMessage:string);
    procedure  SetEnableErrorList(const bValue:boolean);
    procedure AddActionFromXMLToCurrentEvent(StateCollection: TStateCollection; EventNode: IXMLNode; sTemp: string; Event: TStateEvent; var Action: TAction; var ListOfActionsNotAssigned: TStringList);
    procedure AddEventsFromXML2CurrentState(StateCollection: TStateCollection; StateNode: IXMLNode; iIdForDuplicateCkeck: Integer; var State: TState; var Event: TStateEvent; Action: TAction; var ListOfActionsNotAssigned: TStringList);
  public

    FSA : TStateCollection ;
    //unused
    property EnableErrorList:boolean read FEnableErrorList
      write SetEnableErrorList;
    property FSALoaded :boolean read bFSALoaded;
    property ErrorList:TStringList read fErrorList;

    constructor Create(AOwner: TComponent); override;
    //constructor to
    //  load xml
    //  create list of procedures present in AOwner that fit
    //    TActionFunction  TActionDispatcherProcedure
    //  create FSA
    //  fit the actions with procedures found in AOwner
    constructor CreateAndBuildFSA(AOwner: TComponent
        ;const FileName: string
        ;Var ComponentWithProceduresForActions:Tcomponent
        ;var ListOfActionsNotAssigned:TStringList
        ;const bEnableLogList:boolean = false
      );
    destructor Destroy; override;
    //load an xml an create the FSA (TStateCollection)
    function BuildFSA(const FileName: string
        ;const ComponentWithProceduresForActions:Tcomponent
        ;var ListOfActionsNotAssigned:TStringList):boolean;
    function BuildFSAAndReturnIT(const FileName: string
        ;const ComponentWithProceduresForActions:Tcomponent
        ;var ListOfActionsNotAssigned:TStringList
      ):TStateCollection;

  end;
//------------------thread-----------------------------------------------------
  TFSAThreaded = class(TThread)
  private
    FFSA:TSTateCollection;
    FFreezeEvent:TEvent;
    procedure KillTimer;
  protected
    procedure Execute; override;
  public
      constructor Create(FSA:TStateCollection);
      destructor Destroy; override;
      function InputEvent(const sEventName:string) : boolean;
  end;

//------------------------venet queue------------------------------------------
  TQueueStrings = class(TComponent)
  private
    FQueue:TThreadList<string>
    ;
    function GetList: System.Generics.Collections.TList<string>;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Enqueue(Value: string);
    function Dequeue: string;
    function Peek: string;
    function Count: integer;
    function IsEmpty: Boolean;
    procedure Clear;
  end;


  function CreateXMLParser(Sender: TComponent) : TXMLParser; overload;
  function CreateXMLParser(AOwner: TComponent
        ;const FileName: string
        ;Var ComponentWithProceduresForActions:Tcomponent
        ;var ListOfActionsNotAssigned:TStringList) : TXMLParser;overload;

  //----------------tools to create code from xml file---------------
  function CreateListOfProcedures(const sFileName:string
    ;const bForImplemenTation:boolean
    ;const bForMainForm:boolean
    ;Var ListWithCode : TStrings):boolean;
  procedure ExtractActionNamesFromTreeXML(const xmlData: string
    ; Var actionNamesList: TStringList
    ; Var eventNamesList: TStringList
    );
  //-------------------------------------------------------------




implementation

//%CLASSGROUP 'Vcl.Controls.TControl'  TBD
//%CLASSGROUP 'FMX.Controls.TControl'  TBD
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

uses System.Variants
  , System.IOUtils
  ,FMX.Types
  {$ifdef DEBUG}
  {$ifdef MSWINDOWS}
  ,Vcl.Dialogs
  {$else}
  ,FMX.Dialogs
  {$endif}
  {$endif}
;

resourcestring
  StrBeginState = 'Start';
  StrEventToSendAtEndWithFailure = 'eventToSendAtEndWithFailure';
  StrEventToSendAtEndWithSuccess = 'eventToSendAtEndWithSuccess';
  StrIdnextstate = 'idnextstate';
  StrState = 'state';
  StrName = 'name';
  StrEvent = 'event';
  StrAction = 'action';
  StrIdevent = 'idevent';
  StrCallBeforeStateChangE = 'callBeforeStateChange';
  StrOnEnter = 'OnEnter';
  StrOnExit = 'OnExit';
  StrActionThatDoesNot = 'DoNothing';
  StrAnActionThatDoesNothing = 'an action that does nothing was called';
  StrDateFormat = 'yyyy_MM_dd_HH_mm_ss';




 //change a variant to string
function VariantToString(const Value: OleVariant): string;
begin
  try
    if VarIsNull(Value) then
      Result := ''
    else
      Result := VarToStr(Value);
  except on E: Exception do
    Result := '';
  end;
end;

//change a vriant to integer
function VariantToInteger(Value: OleVariant;Var iValueOut : integer): boolean;
Var
  sRes:string;
  Res : boolean;
  iRes:integer;
begin
  iRes := 0;
  iValueOut := -1;
  Res := false;
  try
    if VarIsNull(Value) then
    begin
      Res := false;
    end
    else
    begin
      sRes := VarToStr(Value);
      if TryStrtoInt(sRes,iRes) then
      begin
        iValueOut :=  iRes;
      end;

    end;
  except on E: Exception do
    Res := false;
  end;
  Result := Res;
end;

//change a variant to boooelan
function VariantToBoolean(Value: OleVariant;Var bValueOut : boolean): boolean;
Var
  sRes:string;
  Res : boolean;
  iRes:integer;
  bTemp:boolean;
begin
  bValueOut := false;
  Res := false;
  try
    if VarIsNull(Value) then
    begin
      Res := false;
    end
    else
    begin
      sRes := VarToStr(Value);
      if TryStrToBool(sRes, bTemp) then
      begin
        bValueOut := bTemp;
      end
      else if TryStrtoInt(sRes,iRes) then
      begin
        if iRes = 0 then
          bValueOut := false
        else if iRes > 0 then
          bValueOut := true;
      end
    end;
  except on E: Exception do
    Res := false;
  end;
  Result:=Res;
end;


{TACtion}
constructor TACtion.Create(Owner:TStateEvent);
begin
  self.FOwner := Owner;
  self.FEventToSendAtEndWithFailure := '';
  self.FEventToSendAtEndWithSuccess := '';
  self.FActionCallBack := nil;
  self.FIdAction := -1;
end;

//call the action associated with this action
function TACtion.DoActionCallBack(const CurrentStateName,NextStateName,EventName
      ,ActionName:string):boolean;
Var
  bDoNothing:boolean;
begin
  Result := false;
  //lets see if this action an automated event generation
  bDoNothing := SameText(self.Name,uFsamanager2.StrEventToSendAtEndWithSuccess)
    or
    SameText(self.Name,StrEventToSendAtEndWithSuccess)
    ;
  if assigned(FActionCallBack)
    or Not bDoNothing
  then
    Result := FActionCallBack(CurrentStateName,NextStateName,EventName
      ,ActionName);
  if assigned(self.FOwner)
    and assigned(self.FOwner.FOwner)
    and assigned(self.FOwner.FOwner.Collection)
    and  (self.FOwner.FOwner.Collection is TSTateCollection)
  then
  begin
    try
      Log.d('Test only');
      if not bDoNothing then
        TCRossPlatformLogger.LogAction
        (
          CurrentStateName,NextStateName,EventName
          ,ActionName,Result

        )
      else
        TCRossPlatformLogger.LogAction
        (
          CurrentStateName,NextStateName,EventName
          ,StrAnActionThatDoesNothing,Result

        )
    except on E: Exception do
    end;
  end;
end;

{ TEvent }
constructor TStateEvent.Create(AOwner:TState);
begin
  self.FOwner := AOwner;
  //create the list of actions for this event
  FActions := TObjectList<TAction>.Create(true);
  self.IdStateEvent := -1;
  self.FIdNextState := -1;
end;
destructor TStateEvent.Destroy;
begin
  try
    if assigned(FActions) then
      FActions.Free;
  except on E: Exception do
  end;
  inherited;
end;




//get the id of the next state
Function TStateEvent.GetIdNextState:integer;
Var
  FSA:TStateCollection;
  NextState:TState;
begin
  Result:=-1;
  try
    if self.FIdNextState = -1 then
    begin
      //if it has a next state
      if Length(self.FNameNextState)>0 then
      begin
        // if it has a FSA as Owner
        if assigned(FOwner) then
        begin
          //get the FSA
          FSA := (FOwner.Collection as TStateCollection);
          if assigned(FSA) then
          begin
            NextState:= FSA.GetStateByName(self.FNameNextState);
            if assigned(NextState) then
            begin
              self.FIdNextState := NextState.IdState;
            end;
          end;
        end;
      end;
    end  ;
    Result := self.FIdNextState;
  except on E: Exception do
    Result:=-1;
  end;
end;

{ TState }
constructor TState.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  IdEqualTOIdState:=false;
  FEvents := TStringList.Create(true);
  self.FIdState := -1;
  self.fIdSuperState := -1;
  fOnEnterEventExists:=false;
  fOnExitEventExists := false;
end;
destructor TState.Destroy;
begin
  try
    if assigned(FEvents) then
      FEvents.Free;
  except on E: Exception do
  end;

 

  inherited;
end;

//find an event by its ID
function TState.FindEventByID(const iEventID:integer): TStateEvent;
Var
  Res : TStateEvent;
  I: Integer;
  CurrentEvent  :TStateEvent;
begin
  Res:= nil;
  try
    if iEventID>-1 then
      if assigned(self.FEvents) then
      begin
        if self.FEvents.Count>0 then
        begin
          for I := 0 to FEvents.Count-1 do
          begin

            CurrentEvent :=  FEvents.Objects[i] as  TStateEvent
              //FEvents.Items[i]
              ;
            if assigned(CurrentEvent) then
            begin
              if (CurrentEvent.IdStateEvent = iEventID) then
              begin
                Res :=  CurrentEvent;
                break;
              end;
            end;
          end;
        end;
      end;
  except on E: Exception do
    Res := NIL;
  end;
  Result := Res;

end;

//find in this state the event with name
function TState.FindEventName(const sEventName:string): TStateEvent;
Var
  I,iPosInList: Integer;
  CurrentEvent  :TStateEvent;
  sPosInList :string;
  ObjectInList:TObject;
begin
  Result:= nil;
  try
    if Length(sEventName)>0 then
    begin
      if  assigned(self.FEvents) then
      begin
        if self.FEvents.Count>0 then
        begin
          iPosInList:=FEvents.IndexOf(sEventName);
          if iPosInList<>-1 then
          begin
            ObjectInList := FEvents.Objects[iPosInList] ;
            if ObjectInList is TStateEvent then
            begin
              CurrentEvent := ObjectInList as TStateEvent;
              if SameText(CurrentEvent.FName,sEventName) then
                Result :=  CurrentEvent;
            end;
          end;

          //useless ?
          if not assigned(Result)  then
          begin
            CurrentEvent:=nil;
            for I := 0 to FEvents.Count-1 do
            begin
              CurrentEvent :=
                //FEvents.Items[i]
                FEvents.Objects[i] as  TStateEvent
                ;
              if assigned(CurrentEvent) then
              begin
                if SameText(CurrentEvent.Name ,sEventName) then
                begin
                  Result :=  CurrentEvent;
                  break;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  except on E: Exception do
    Result := NIL;
  end;
end;

// for this state search and run the event from parameter and return the next state
// if return == false then event does not exists in current state
function TState.InPutEventInThisState(const sEventName:string
    ;out NextState:TState
  ):boolean;
Var
  Event:TStateEvent;
  localNextSTate:integer;
  FSA : TStateCollection;
  //bResultFromB4,bResultFromAfter:boolean;
begin
  Result:=False;
  NextState := self;
  try
    if Length(sEventName)>0 then
    begin
      Event := self.FindEventName(sEventName);
      FSA:= self.Collection as TStateCollection;
      if assigned(Event) then
      begin
        localNextSTate := Event.IdNextState ;

        //bResultFromB4 :=
        self.RunAllActions(Event,true);

        if localNextSTate<>self.IdState then
          NextState := FSA.GetStateByIdState(localNextSTate);

        //bResultFromAfter:=
        self.RunAllActions(Event,false);

        Result:= True;

      end;
    end;
  except on E: Exception do
  end;
end;

//run all the action for this state givenmt the event in param
function TState.RunAllActions(const CurrEvent:TStateEvent
    ; const bLaunchBeforeStateChange:boolean
  ):boolean ;
Var
  CurrAction:TAction;
  sNextEvent : string;
  Local_I:integer;
  bFunctionResult,bDoNothing : boolean;
  NextState :TState;
  FSA : TStateCollection;
begin
  Result := false;
  try
    //if event has actions
    if assigned(CurrEvent.Actions) and  (CurrEvent.Actions.Count>0) then
    begin
        FSA:= self.Collection as TStateCollection;
        //for each action
        sNextEvent := '';

        NextState :=   FSA.GetStateByIdState(CurrEvent.IdNextState);
        if not assigned(NextState) then 
        begin
          NextState := self;
        end;

        Result :=  CurrEvent.Actions.Count>0;

        //for all action for this event
        for Local_I := 0 to CurrEvent.Actions.Count - 1 do
        begin
          CurrAction := CurrEvent.Actions.Items[Local_I];
          if assigned(CurrAction) then
          begin
            //is it b4 or after state change
            if (CurrAction.CallBackBefareStateChange = bLaunchBeforeStateChange) then
            begin
              //call the procedure associated with this action
              if Assigned(CurrAction.ActionCallBack) then
              begin
                if not assigned(FSA.FSAThread) then
                begin
                  bFunctionResult := CurrAction.DoActionCallBack(self.Name
                    , NextState.Name
                    , CurrEvent.Name
                    , Curraction.Name);
                end
                else
                begin
                  FSA.FSAThread.Queue
                  (
                  procedure
                  begin
                    bFunctionResult := CurrAction.DoActionCallBack(self.Name
                    , NextState.Name
                    , CurrEvent.Name
                    , Curraction.Name);
                  end
                  )
                end;


                //set the next event if functions returns true
                if bFunctionResult then
                    sNextEvent :=  CurrAction.EventToSendAtEndWithSuccess
                //or false
                else
                    sNextEvent :=  CurrAction.EventToSendAtEndWithFailure;

                FSA.FEventsQueue.Enqueue(sNextEvent);
              end
              else
              begin
                //if the name is special then choose EventToSendAtEndWithSuccess
                //justt make sure it tu put the right event
                if SameText(CurrAction.Name,StrActionThatDoesNot)
                then
                begin
                  sNextEvent :=  CurrAction.EventToSendAtEndWithSuccess;
                  FSA.FEventsQueue.Enqueue(sNextEvent);
                end
              end;
            end;
          end;
        end;
    end;
  except on E: Exception do
    Result := false;
  end;
end;

//get SUperState ID
function TState.GetIdSuperState:integer;
Var
  SuperState:TSTate;
begin
  try
    //id SUperState = -1 maybe it has a  name as string
    if FIdSuperState = -1 then
    begin
      //if the name of the superstate exsists
      if Length(self.FNameSuperState)>0 then
      begin
        //get it
        SuperState := (self.Collection as TSTateCollection).
          GetStateByName(FNameSuperState);
        if assigned(SuperState) then
        begin
          //set it for the current state
          FIdSuperState := SuperState.ID
        end;
      end;
    end;

    //return it
    Result := self.FIdSuperState;

  except on E: Exception do
    Result := -1;
  end;
end;

//add event to the current state, used at creation
function TState.AddEvent(const sEventName:string;const Event:TStateEvent):boolean;
Var
  iPos :integer;
begin
  try
    //actual add
    iPos := self.Events.AddObject(Event.Name,Event)
      ;
    Result := true;
  except on E: Exception do
    Result := false;
  end;

end;


{ TStateCollection }

//create the FSA
constructor TStateCollection.Create(ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  LogFileName := TCrossPlatformLogger.GetLogFilePath;
  //event queue creation
  Self.FEventsQueue:=TQueueStrings.Create(nil) ;
  fProcessinEvents := FALSE;
  FSAThread:=nil;
end;

destructor TStateCollection.Destroy;
begin
  try
    if assigned(FEventsQueue) then
      self.FEventsQueue.Free;
    if assigned(FInternalProcedureList) then
      FInternalProcedureList.Free;
  except on E: Exception do
  end;
  inherited Destroy;
end;

//get state by position in collection
function TStateCollection.GetState(Index: Integer): TState;
begin
  if Index>-1 then
    Result := TState(inherited Items[Index])
  else Result := nil;
end;

//retrieve the state with the given id
function TStateCollection.GetStateByIdState(const idState:integer):TState;
Var
  Item :TCollectionItem;
  I,iPos: Integer;
  sPos:string;
begin
  Result := nil;
  try
    if Count > 0 then
    begin
      try
        if (idState>Count) and (idState<Count) then
        begin
          Item := self.Items[idState];
          if assigned(Item) then
          begin
            if (item is TState) and (item as Tstate).IdEqualTOIdState then
              Result:= (item as Tstate)
          end;
        end;
      except on E: Exception do
        Result := nil;
      end;

      // search by ghoing through the entire list
      if not assigned(Result) then
      begin
        if idState>-1 then
          for I := 0 to Count-1 do
          begin
            Item := self.Items[i];
            if assigned(item) and (item is TState) then
            begin
              if (item as Tstate).IdState = idState  then
              begin
                Result :=  (item as Tstate);
                break;
              end;
            end;
          end;
      end;
    end;
  except on E: Exception do
    Result := NIL;
  end;
end;

//retrieve the state with the given name
function TStateCollection.GetStateByName(const sStateName:string):TState;
Var
  Item :TCollectionItem;
  I,iPos: Integer;
  sPos:string;
begin
  Result := nil;
  try

    if Length(sStateName)>0 then
    begin
      for I := 0 to Count-1 do
      begin
        Item := self.Items[i];
        if (item is TState) then
        begin
          if SameText((item as Tstate).Name , sStateName ) then
          begin
            Result :=  (item as Tstate);
            break;
          end;
        end;
      end;
    end;
  except on E: Exception do
    Result := NIL;
  end;
end;



//put an event in the queue of events
function TStateCollection.InputEvent(const sEventName:string) : boolean;
Var
  bFirstOne:boolean;
  bHasChangedState:boolean;
begin
  Result := false;
  bHasChangedState :=false;
  try
    //if event name has something inside
    if Length(Trim(sEventName))>0 then
    begin
      //if its threade then use the thread
      if assigned(self.FSAThread) then
      begin
        FSAThread.InputEvent(sEventName);
      end
      else
      begin
        //check if its the first one
        bFirstOne :=  FEventsQueue.IsEmpty;
        //iof it has queue .it is called robust programming
        if assigned(FEventsQueue) then
        begin
          //add event to the queue
          self.FEventsQueue.Enqueue(sEventName);
          //if its the first then run it
          if bFirstOne OR NOT fProcessinEvents then
            //it will not stop until the event queue is empty
            RunEventsFromQueueUseItemsFunctions( self.FCurrentState,false
              ,bHasChangedState);
            //Result:= RunEventsFromQueue(self.FCurrentState);
        end
        else
          Result := false;
      end;
    end;
  except on E: Exception do
    Result := false;
  end;
end;




//set the current state , for debug purposes
procedure TStateCollection.SetCurrentState( State :TState)  ;
begin
  if assigned(state) then
    self.FCurrentState := State;
end;

//run all the events in the quueue
//, by using each state event treatment functions
function TStateCollection.RunEventsFromQueueUseItemsFunctions(
        var localCurrentState:TState
        ;const bIsSUperState :boolean 
        ;Var HasChangedStates :boolean
      ):boolean;
Var
  sEventName:string;
  Event :TStateEvent;
  NextState,SuperState,OldState:Tstate;
  bCurrStateEventFound:boolean;
begin

  Result := false;
  if not assigned(localCurrentState) then
    localCurrentState := self.CurentState;

  if assigned(localCurrentState) then  //useless ?
  begin

    Event := NIL;
    OldState :=  self.CurentState;
    try
      if assigned(FEventsQueue) then
      repeat
        fProcessinEvents:=TRUE;
        //get the first event
        sEventName := self.FEventsQueue.Peek;

        //run it with the current state functions
        bCurrStateEventFound := localCurrentState.InPutEventInThisState
          (sEventName,NextState);
        Result := bCurrStateEventFound;
        // set the new state
        if bCurrStateEventFound then
        begin          
          if assigned(NextState) and assigned(localCurrentState)
            and   (localCurrentState.IDState<>NextState.IDState) then
          begin
            OldState :=  self.CurentState;
            self.CurentState :=  NextState;
            localCurrentState := self.CurentState ;
            HasChangedStates := true;
          end;
        end;

        // this state does not have this event lets see the superstate
        if not bCurrStateEventFound then
        begin
            //getthe super state
            SuperState := self.GetStateByIdState(localCurrentState.IdSuperState);
            if assigned(SuperState) then
            begin
              //reecursive , there could be superstate with superstate
              Result := self.RunEventsFromQueueUseItemsFunctions
                (SuperState,True,HasChangedStates);
            end;
        end;

        
        
        //if this is a super state no need to look for the next event
        //just a noprmal state can go for the next event
        if bIsSUperState then
           break;
        //run the OnEnter and OnExit events auto
        //only from state not superstate because it muts be run only once
        RunOnEnterAndOnExitEventsIfTheyExists(localCurrentState, OldState
        //, bIsSUperState
        );    
        
        //delete the event if this is a normal state 
        if Not bIsSUperState then
        begin
          //run the  procedure if no other action found
          if not Result then RunDispatcherCallBack(Event, NextState);  
          FEventsQueue.Dequeue;
        end;
      until FEventsQueue.IsEmpty ;
      fProcessinEvents:=FALSE;
    except on E: Exception do
      BEGIN
        Result := False;
        fProcessinEvents:=FALSE;
      END;
    end;
  end;
end;

{
function TStateCollection.RunEventsFromQueue
  (var localCurrentState:TState
  ;const bIsSUperState :boolean
  ):boolean;
Var
  sEventName,sCurrStateName:string;
  Event,EventSuperState :TEvent;
  NextState,SuperState,OldState:Tstate;
  CurrAction :Taction;
  bHasSuperStateWithActions:boolean;
  I: Integer;
begin

    Result := false;
    if assigned(localCurrentState) then
    begin

      Event := NIL;
      OldState :=  self.CurentState;
      bHasSuperStateWithActions := false;
      try
        if assigned(FEventsQueue) then
        repeat
          //get the first event
          sEventName := self.FEventsQueue.GetFirst;

          if assigned(self.CurentState) and (Length(sEventName)>0) then
          begin

            Event := localCurrentState.FindEventName(sEventName) ;
            // if the current state contains the event
            if assigned(Event) then
            begin
              Result := true;

              //get the next state
              NextState := self.GetStateById(Event.IdNextState);
              if not assigned(NextState) then
                NextState := self.CurentState; 

              //--------------run actions 4 those hat must be launched b4 state change-----------
              RunAllActionsForThisEvent(Event, NextState
                , CurrAction,true);
              //-----------------------------------------

              // set the new state
              if localCurrentState.ID<>NextState.ID then
              begin
                self.CurentState :=  NextState;
                localCurrentState := self.CurentState ;
              end;
              //---------------------actions for after state change--------------
              RunAllActionsForThisEvent(Event, NextState
                , CurrAction,false);
              //run the  procedure that will be run for each event
              RunDispatcherCallBack(Event, NextState);
            end
            // this state does not have this event lets see the superstate
            else
            begin
              SuperState := self.GetStateById(localCurrentState.IdSuperState);
              if assigned(SuperState) then
              begin
                self.RunEventsFromQueue(SuperState,True);
              end;
            end;
            //if this is a super state no need to look for the next event
            //just a noprmal state can go for the next event
            if bIsSUperState then
              break;
          end;
          //delete the event if this is a normal state 
          if Not bIsSUperState then
            FEventsQueue.Dequeue;
        until FEventsQueue.IsEmpty ;
      except on E: Exception do
        Result := False;
      end;
    end;
end;


function TStateCollection.RunEventsFromQueueSimple:boolean ;
Var
  sEventName,sCurrStateName:string;
  Res :boolean;
  Event,EventSuperState :TEvent;
  NextState,SuperState,OldState:Tstate;
  CurrAction :Taction;
  bHasSuperStateWithActions:boolean;
  I: Integer;

begin

  Event := NIL;
  Res := false;
  OldState :=  self.CurentState;
  bHasSuperStateWithActions := false;
  try
    if assigned(FEventsQueue) then
    repeat
      //get the first event
      sEventName := self.FEventsQueue.GetFirst;


      if assigned(self.CurentState) and (Length(sEventName)>0) then
      begin

        Event := self.CurentState.FindEventName(sEventName) ;
        // if the current state contains the event
        if assigned(Event) then
        begin

          //get the next state
          NextState := self.GetStateById(Event.IdNextState);
          if not assigned(NextState) then
            NextState := self.CurentState;



          //----------------------

          //-----run actions 4 those hat must be launched b4 state change-----------
          RunAllActionsForThisEvent(Event, NextState
            , CurrAction,true);

          //-----------------------------------------

          // set the new state
          self.CurentState :=  NextState;



          //---------------------actions for after state change--------------
          RunAllActionsForThisEvent(Event, NextState
            , CurrAction,false);
          //run the  procedure that will be run for each event
          RunDispatcherCallBack(Event, NextState);

        end
        // this state does not have this event lets see the superstate
        else
        begin

          NextState := self.CurentState;
          if SetNextStateFromSuperState(sEventName, NextState, SuperState
            , EventSuperState) then
          begin
            RunAllActionsForThisEvent(EventSuperState, NextState
              , CurrAction, true);
            self.CurentState :=  NextState;
            RunAllActionsForThisEvent
              (EventSuperState, NextState
              //, I
              , CurrAction,false);
            RunDispatcherCallBack(EventSuperState, NextState);
          end;

        end;
      end;
      //delete the event
      self.FEventsQueue.Dequeue;
    until FEventsQueue.IsEmpty ;
  except on E: Exception do
    Res := False;
  end;
  Result := res;


end;
}

{ TXMLParser }
constructor TXMLParser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fXML := TXMLDocument.Create(SELF);
  FSA := nil;
  bFSALoaded := false;
  EnableErrorList:=false;
  fMAXStateID := -1;
  TCrossPlatformLogger.bLogFailed :=false;
end;

//constructor to build the XML  parser withh all that it needs to build the FSA
constructor TXMLParser.CreateAndBuildFSA(AOwner: TComponent
        ;const FileName: string
        ;Var ComponentWithProceduresForActions:Tcomponent
        ;var ListOfActionsNotAssigned:TStringList
        ;const bEnableLogList:boolean
      );
begin
  inherited Create(AOwner);
  TCrossPlatformLogger.bLogFailed :=false;
  fMAXStateID := 0;
  fXML := TXMLDocument.Create(SELF);
  self.EnableErrorList := bEnableLogList;
  bFSALoaded := false;
  //build the FSA
  self.BuildFSA(FileName
    ,ComponentWithProceduresForActions
    ,ListOfActionsNotAssigned);
end;

destructor TXMLParser.Destroy;
begin
  try
    if assigned(self.fXML) then
    begin
      fxml.Free;
      fxml := nil
    end;
  except on E: Exception do
  end;

  try
    if assigned(FSA) then
    begin
      FSA.Free;
      FSA := nil;
    end;
  except on E: Exception do
  end;

  try
    if assigned(fErrorList) then
    begin
      fErrorList.Free ;
      fErrorList := nil;
    end;
  except on E: Exception do
  end;

  inherited Destroy;
end;

// build the fsa and return bool for creation siccess
//the fsa is in the xml parser
//not very briliant ideea
function TXMLParser.BuildFSA(const FileName: string
      ;const ComponentWithProceduresForActions:Tcomponent
      ;var ListOfActionsNotAssigned:TStringList):boolean;
begin
  try
    FSA :=  HiddenParseXML(FileName,
      ComponentWithProceduresForActions,ListOfActionsNotAssigned);
    Result := assigned(FSA);
  except on E: Exception do
    Result := false
  end;

end;

//build and retuen the FSA
function TXMLParser.BuildFSAAndReturnIT(const FileName: string
      ;const ComponentWithProceduresForActions:Tcomponent
      ;var ListOfActionsNotAssigned:TStringList):TStateCollection;
begin
  try
    FSA :=  HiddenParseXML(FileName,
      ComponentWithProceduresForActions,ListOfActionsNotAssigned);
    Result := FSA;
  except on E: Exception do
    Result := nil
  end;

end;

//xml parser procedure
//scan for events in xml and add them to the newly created state
procedure TXMLParser.AddEventsFromXML2CurrentState(
  StateCollection: TStateCollection; StateNode: IXMLNode
  ; iIdForDuplicateCkeck: Integer; var State: TState; var Event: TStateEvent
  ; Action: TAction; var ListOfActionsNotAssigned: TStringList);
var
  EventNode: IXMLNode;
  sTemp: string;
  sCalculatedEventID: string;
  sEventNameFoprDuplicateCheck: string;
  bEventAsIntegerUnique: Boolean;
  bEventIdAsStringUnique: Boolean;
  bEventIdIsUnique: Boolean;
begin
  //for all events
  EventNode := StateNode.ChildNodes.FindNode(StrEvent);
  bEventAsIntegerUnique := false;
  bEventIdAsStringUnique := false;
  Action := nil;
  bEventIdIsUnique := false;

  while Assigned(EventNode) do
  begin
    FindOrCalculateEventID(State, EventNode, sTemp, sCalculatedEventID);
    if EventNode.HasAttribute(StrName)
      and TryStrToInt(sCalculatedEventID, iIdForDuplicateCkeck) then
    begin
      sEventNameFoprDuplicateCheck :=
        VariantToString(EventNode.Attributes[StrName]);
      //if event name length is 0 then avoid it
      if Length(sEventNameFoprDuplicateCheck) > 0 then
      begin
        //make sure the id and name of the event is unique
        bEventAsIntegerUnique :=
          assigned(State.FindEventByID(iIdForDuplicateCkeck));
        bEventIdAsStringUnique :=
          assigned(State.FindEventName(sEventNameFoprDuplicateCheck));
        bEventIdIsUnique := not bEventAsIntegerUnique
          and not bEventIdAsStringUnique;
      end
      else
        bEventIdIsUnique := false;
      if bEventIdIsUnique then
      begin
        Event := TStateEvent.Create(State);
        Event.Name := sEventNameFoprDuplicateCheck;
        //lets see  if it has a OnEnter event only if
        //it was not found until now
        if not State.fOnEnterEventExists then
          State.fOnEnterEventExists := SameText(Event.Name, StrOnEnter);
        //lets see  if it has a OnExit event only if
        //it was not found until now
        if not State.fOnExitEventExists then
          State.fOnExitEventExists := SameText(Event.Name, StrOnExit);
        Event.FIdStateEvent := iIdForDuplicateCkeck;
        SetEventNextSTateIDFromXMLFile(EventNode, State, Event, StateCollection);
        AddActionFromXMLToCurrentEvent(StateCollection, EventNode, sTemp, Event, Action, ListOfActionsNotAssigned);
        //State.Events.Add(Event);
        State.AddEvent(Event.Name, Event);
      end
      else
      //id not unique
      begin
        AddEventIdErrorToListOfError(iIdForDuplicateCkeck, sEventNameFoprDuplicateCheck, bEventAsIntegerUnique, bEventIdAsStringUnique);
      end;
    end
    else
    //Event has no name attribute
    begin
      AddErrorStringToErrorList(EventNode.Text + ' event has no name');
    end;
    EventNode := EventNode.NextSibling;
  end;
end;

//scan the xml and add the actions for the current event
procedure TXMLParser.AddActionFromXMLToCurrentEvent(
  StateCollection: TStateCollection; EventNode: IXMLNode; sTemp: string
  ; Event: TStateEvent; var Action: TAction
  ; var ListOfActionsNotAssigned: TStringList);
var
  ActionNode: IXMLNode;
  sActionName: string;
  sCalculatedActionID: string;
  sEventToSendAtEndOfACtion: string;
begin
  //for all actions
  ActionNode := EventNode.ChildNodes.FindNode(StrAction);
  while Assigned(ActionNode) do
  begin
    sActionName := VariantToString(ActionNode.Attributes[StrName]);
    //if action name has length 0 the do nothing
    if Length(sActionName) > 0 then
    begin
      Action := TAction.Create(Event);
      Action.Name := sActionName;
      FindOrCalculateTheActionID(EventNode, sTemp, Event, ActionNode, sCalculatedActionID);
      if TryStrtoInt(sCalculatedActionID, Action.FIdAction) then
      begin
        CheckAndSetTheCallBeforeStateChangeAttribute(ActionNode, Action);
        FindAndSetActionCallBackWithProcedureFromCode(StateCollection, Action);
        SaveTheProcedureNameThatDoesNotExistsInTheListOfNotAssigned(Action, ListOfActionsNotAssigned);
        //add this action to this event list of actions
        Event.Actions.Add(Action);
        FindAndSaveEventToSendAfterActionSuccess(ActionNode, Action, sEventToSendAtEndOfACtion);
        FindAndSetEvent2SendAfterActionFailure(ActionNode, Action);
        ActionNode := ActionNode.NextSibling;
      end
      else
      //it failed the free the action we dont need it
      begin
        Action.Free;
        Action := nil;
      end;
    end;
  end;
end;

procedure TXMLParser.AddStateIdErrorToErrorList(iIdForDuplicateCkeck: Integer
  ; sStateNameFoprDuplicateCheck: string; bStateIdAsStringUnique: Boolean
  ; bStateIDAsIntegerUnique: Boolean);
begin
  if bStateIDAsIntegerUnique then
    AddErrorStringToErrorList(IntToStr(iIdForDuplicateCkeck)
      + ':State id not unique');
  if bStateIdAsStringUnique then
    AddErrorStringToErrorList(sStateNameFoprDuplicateCheck
      + ':State id not unique');
end;

procedure TXMLParser.AddEventIdErrorToListOfError(iIdForDuplicateCkeck: Integer
  ; sEventNameFoprDuplicateCheck: string; bEventAsIntegerUnique: Boolean
  ; bEventIdAsStringUnique: Boolean);
begin
  if bEventAsIntegerUnique then
    AddErrorStringToErrorList(IntToStr(iIdForDuplicateCkeck)
      + ':event id not unique');
  if bEventIdAsStringUnique then
    AddErrorStringToErrorList(sEventNameFoprDuplicateCheck
      + ':event id not unique');
end;

procedure TXMLParser.AddErrorStringToErrorList(const sMessage:string);
begin
  if self.EnableErrorList then
  begin
    if not assigned(fErrorList) then
      fErrorList:=TSTringList.Create;
    fErrorList.Add(sMessage);
  end;
end;

//enable and create the list of errors
procedure  TXMLParser.SetEnableErrorList(const bValue:boolean);
begin
  self.FEnableErrorList :=  bValue;
  if FEnableErrorList then
  begin
    if assigned(self.fErrorList) then
    begin
      fErrorList:=TSTringList.Create;
    end;
  end;
end;

//set the Next State ID
//idnextstate is not an integer then it must be an name of a state
procedure TXMLParser.SetEventNextSTateIDFromXMLFile
  (EventNode: IXMLNode; Var State : TState; Var Event: TStateEvent
  ;var TempFSA :TStateCollection);
Var
  iIDNextState:integer;
  sIDNextState:string;
  NextState:Tstate;
  bEventNodeHasIdNextStateAttribute:boolean;
begin
  try
    bEventNodeHasIdNextStateAttribute := EventNode.HasAttribute(StrIdnextstate) ;
    //if it is a OnEnter Or OnExit eveny it does not have next state
    if SameText(Event.Name,StrOnEnter) or SameText(Event.Name,StrOnExit) then
      bEventNodeHasIdNextStateAttribute :=false ;

    if  assigned(TempFSA) and  assigned(EventNode) and assigned(Event)
      and bEventNodeHasIdNextStateAttribute then
    begin

      sIDNextState := VariantToString( EventNode.Attributes[StrIdnextstate]);
      // if id next state is a number
      if TryStrToInt(sIDNextState,iIDNextState) then
      begin
        //set it
        Event.IdNextState := iIDNextState
      end
      //if its a string
      else
      begin
        //find it
        NextState := TempFSA.GetStateByName(sIDNextState);
        if assigned(NextState) then
          //set it
          Event.IdNextState :=  NextState.IdState
        else
          //not foudn it does not exists for now , save as name
          Event.FNameNextState := sIDNextState;
      end;
    end;
    //maybe the next state for this event it is the state in wich it exists
    if not bEventNodeHasIdNextStateAttribute then
    begin
      if assigned(State) and assigned(Event) then
        Event.IdNextState := State.IdState
    end;
  except on E: Exception do
  end;

end;

//for the current state set its superstate
procedure TXMLParser.SetStateSuperState(StateNode: IXMLNode
    ; Var State: TState
    ; var TempFSA :TStateCollection
  );
Var
  sValue:string;
  iValue:integer;
  SuperState:TState;
begin
  //check state xml node has the attribute
  if StateNode.HasAttribute('idsuperstate') then
  begin
    //get the value
    sValue := VariantToString(StateNode.Attributes['idsuperstate']);
    if length(sValue)>0 then
    begin
      //is this a number then set it
      if TryStrToInt(sValue,iValue) then
      begin
        State.FIdSuperState:= iValue
      end
      //not a number it is a name
      else
      begin
        //find it
        SuperState := TempFSA.GetStateByName(svalue);
        //found it , then set the superstate id to the id of the state found
        if assigned(SuperState) then
        begin
          State.FIdSuperState := SuperState.IDState
        end
        //not found maybe because it does not exists for now
        else
	      begin
          State.FNameSuperState :=  sValue;
          //to be sure that it will search the id later
          State.FIdSuperState:= -1
        end
      end
    end
  end
end;

// see if this is the starting state and set it as tghe current state
procedure TXMLParser.SetTheStartingState(var StateCollection: TStateCollection; State: TState);
begin
  if SameText(State.Name, StrBeginState) then
  begin
    StateCollection.CurentState := State;
  end;
end;

//get from the xml the state id or caluclate a new one from the FSA.States.Counyt+1
procedure TXMLParser.FindOrCalculateStateID(StateCollection: TStateCollection; StateNode: IXMLNode; var sCalculatedStateID: string);

begin
  if not StateNode.HasAttribute('idstate') then
  begin        
    sCalculatedStateID := IntToStr(fMAXStateID +1);
  end
  else
    sCalculatedStateID := VariantToString(StateNode.Attributes['idstate']);
end;

//for this event retrieve the id from xml or if it does not exists
// calculate it = StateId concatenated
//with the [(count of events from the state +1) as string]
procedure TXMLParser.FindOrCalculateEventID(State: TState; EventNode: IXMLNode
; var sTemp: string; var sCalculatedEventIDid: string);
Var
  sIdEventFromXML:string;
  iIdEventFromXML:integer;
  iIDCalculated:integer;
  bResult,bNodeHasAttribute:boolean;
begin
  //if it does not have id calculate it  =
  //StateId + Events.Count
  bResult :=false;
  bNodeHasAttribute := EventNode.HasAttribute(StrIdevent) ;
  if Not bNodeHasAttribute then
  begin
    if assigned(State) then
    begin
      iIDCalculated := State.Events.Count
        //+1
        ;
      sCalculatedEventIDid := IntToStr(iIDCalculated);
      bResult:=true;
    end;      
  end
  else
  //if bNodeHasAttribute   then
  begin
    sIdEventFromXML :=  VariantToString(EventNode.Attributes[StrIdevent]) ;
    try
      if TryStrtoInt(sIdEventFromXML,iIdEventFromXML) then
      begin
        sCalculatedEventIDid := sIdEventFromXML;
        bResult := true;
      end;
    except on E: Exception do
      sCalculatedEventIDid := ''
    end;
  end;

  if not bNodeHasAttribute or  not bResult then
  begin
    if State.FIdState = 0 then
      sTemp := ''
    else
      sTemp := IntToStr(State.FIdState);
    sCalculatedEventIDid := sTemp + IntToStr(State.Events.Count + 1);
  end ;

end;

//for the  current action find in xml the value of the id if it does not
//exists then calculate a new one from the id of he event  concatenated with
//the count pf actions
// from this event
procedure TXMLParser.FindOrCalculateTheActionID(EventNode: IXMLNode
  ; sTemp: string; Event: TStateEvent; ActionNode: IXMLNode
  ; var sCalculatedActionID: string);
Var
  s:string;
begin
  //if it does not have id calculate it by adding to the
  //eventId the Actions.Count
  if not ActionNode.HasAttribute('idaction') then
  begin
    if Event.IdStateEvent = 0 then
      sTemp := ''
    else
      sTemp := IntToStr(Event.IdStateEvent);
    sCalculatedActionID := sTemp + IntToSTr(Event.Actions.Count + 1);
  end
  else
  begin
    s := ActionNode.Attributes['idaction'];
    sCalculatedActionID := VariantToString(ActionNode.Attributes['idaction']);
  end;
end;

//if the function associated to an action returns false then it can send an event
//this function will retrieve from XML the event to send in this case
procedure TXMLParser.FindAndSetEvent2SendAfterActionFailure(
  ActionNode: IXMLNode; var Action: TAction);
var
  sEventToSendAtEndOfACtion: string;
begin
  if ActionNode.HasAttribute(StrEventToSendAtEndWithFailure) then
  begin
    sEventToSendAtEndOfACtion := VariantToString(ActionNode.Attributes[StrEventToSendAtEndWithFailure]);
    if (Length(sEventToSendAtEndOfACtion) > 0) then
    begin
      Action.EventToSendAtEndWithFailure := sEventToSendAtEndOfACtion;
    end;
  end;
end;

//if the function associated to an action retuens true then it can send an event
//this function will retrieve from XML the event to send in this case
procedure TXMLParser.FindAndSaveEventToSendAfterActionSuccess(
  ActionNode: IXMLNode; var Action: TAction
  ; var sEventToSendAtEndOfACtion: string);
begin
  //maybe this action has an event to send at the end of it
  if ActionNode.HasAttribute(StrEventToSendAtEndWithSuccess) then
  begin
    sEventToSendAtEndOfACtion := VariantToString
      (ActionNode.Attributes[StrEventToSendAtEndWithSuccess]);
    if (Length(sEventToSendAtEndOfACtion) > 0) then
    begin
      Action.EventToSendAtEndWithSuccess := sEventToSendAtEndOfACtion;
    end;
  end;
end;

//for teh given action check if exists and set the value in FSA
procedure TXMLParser.CheckAndSetTheCallBeforeStateChangeAttribute
  (ActionNode: IXMLNode; Action: TAction);
begin
  if ActionNode.HasAttribute(StrCallBeforeStateChangE) then
  begin
    VariantToBoolean(ActionNode.Attributes[StrCallBeforeStateChangE]
      , Action.fCallBackBefareStateChange);
  end;
end;

//for an action set the apropriate function , it will be identified by name
//from the   InternalProcedureList
procedure TXMLParser.FindAndSetActionCallBackWithProcedureFromCode
  (StateCollection: TStateCollection; Action: TAction);
var
  I: Integer;
  NameAndProcedure: System.Generics.Collections.TPair<string, TActionFunction>;
begin
  ///see if the are any procedure with a name identical with the procedure name
  Action.FActionCallBack := nil;
  //only if the name is not DoNothing
  if not SameText(Action.Name,StrActionThatDoesNot) then
  begin
    for I := 0 to StateCollection.InternalProcedureList.Count - 1 do
    begin
      NameAndProcedure := StateCollection.InternalProcedureList.Items[i];
      if NameAndProcedure.Key = Action.Name then
      begin
        Action.FActionCallBack := NameAndProcedure.Value;
      end;
    end;
  end;
end;

//in case one of the actions does not have associated function here they will be saved
procedure TXMLParser.SaveTheProcedureNameThatDoesNotExistsInTheListOfNotAssigned
  (Action: TAction; var ListOfActionsNotAssigned: TStringList);
begin
  if not Assigned(Action.FActionCallBack) then
  begin
    if assigned(ListOfActionsNotAssigned) then
      ListOfActionsNotAssigned.Add(Action.Name);
  end;
end;

//parse the xml and
// 1. create the FSA
// 2. create a list of functions that can be used for the actions and
//       then assigne it to each action , assignation will be made by
//       name comparision
function TXMLParser.HiddenParseXML(const FileName: string
  ;const ComponentWithProceduresForActions:TComponent
  ;var ListOfActionsNotAssigned:TStringList
): TStateCollection;
var
  RootNode, StateNode: IXMLNode;
  StateCollection: TStateCollection;
  State: TState;
  Event: TStateEvent;
  Action: TAction;
  iIdForDuplicateCkeck:integer;
  sStateNameFoprDuplicateCheck :string;
  sCalculatedStateID:string;
  bStateIdIsUnique,bStateIDAsIntegerUnique,bStateIdAsStringUnique:boolean;
begin
  Action := nil;
  try
    //load xml
    try
      if FileExists(FileName) then
        fXML.LoadFromFile(FileName)
      else
        fXML.LoadFromXML(FileName);
      RootNode := fXML.DocumentElement;
      //create collection
     StateCollection := TStateCollection.Create(TState);
      //create the list of procedures that should be assigned to each action
      if StateCollection.GetFunctionNames
        (ComponentWithProceduresForActions) then
      begin
        //for all states
        StateNode := RootNode.ChildNodes.FindNode(StrState);
        while Assigned(StateNode) do
        begin
          FindOrCalculateStateID(StateCollection, StateNode, sCalculatedStateID);

          if StateNode.HasAttribute(StrName)
            and TRyStrToInt(sCalculatedStateID,iIdForDuplicateCkeck)
          then
          begin

              sStateNameFoprDuplicateCheck := StateNode.Attributes[StrName];
              //make sure the state id and name is unique
              if Length(sStateNameFoprDuplicateCheck)>0 then
              begin
                bStateIdAsStringUnique  := not assigned(StateCollection.GetStateByName
                    (sStateNameFoprDuplicateCheck));
              end
              else
              begin
                //if the length state name is 0 then avoid it
                bStateIdAsStringUnique := false;
                AddErrorStringToErrorList(StateNode.Text+  ' state has empty string as name ');
              end;

              bStateIDAsIntegerUnique := not assigned(StateCollection.GetStateByIdState
                    (iIdForDuplicateCkeck));
              //if it still not unique the Id then get a new one by incrementing
              // fMAXStateID
              if not bStateIDAsIntegerUnique then
              begin
                iIdForDuplicateCkeck := fMAXStateID +1;
                bStateIDAsIntegerUnique := not assigned(StateCollection.GetStateByIdState
                    (iIdForDuplicateCkeck));                  
              end;              

              ////if the length state name is 0 then avoid it
              if Length(sStateNameFoprDuplicateCheck)>0 then
              begin
                bStateIdIsUnique :=
                  (StateCollection.Count = 0)
                  OR (
                      bStateIDAsIntegerUnique
                      and bStateIdAsStringUnique
                    );
              end
              else bStateIdIsUnique := false;
              if bStateIdIsUnique  then
              begin
                if self.fMAXStateID<iIdForDuplicateCkeck then
                  self.fMAXStateID := iIdForDuplicateCkeck;
                
                //State := TState(StateCollection.Add);
                State := StateCollection.AddState(sStateNameFoprDuplicateCheck
                  ,iIdForDuplicateCkeck);
                
                State.Name := sStateNameFoprDuplicateCheck;
                SetTheStartingState(StateCollection, State);

                State.FIdState := iIdForDuplicateCkeck;
                SetStateSuperState(StateNode, State,StateCollection);
                AddEventsFromXML2CurrentState(StateCollection, StateNode
                  , iIdForDuplicateCkeck, State, Event, Action
                  , ListOfActionsNotAssigned);
              end
              else
              begin
                AddStateIdErrorToErrorList(iIdForDuplicateCkeck
                  , sStateNameFoprDuplicateCheck, bStateIdAsStringUnique
                  , bStateIDAsIntegerUnique);
              end;
          end
          else
          begin
            AddErrorStringToErrorList(StateNode.Text+  ' state has no name');
          end;
          StateNode := StateNode.NextSibling;
        end;
      end
      else
      begin
        AddErrorStringToErrorList('Error while retrieving functions for actions')
      end;
      Result := StateCollection;
      TCRossPlatformLogger.NewLogs;
      bFSALoaded := StateCollection.Count>0;
    except on E: Exception do

      begin
        AddErrorStringToErrorList(E.Message);
        Result := nil;
        //something ko lest free what was alocated not used
        try
          if assigned(StateCollection) then  StateCollection.free;
          if assigned(State) then State.Free;
          if assigned( Event) then   Event.Free;
          if assigned( Action ) then Action.Free;
        except on E: Exception do
        end;
      end;
    end;
  finally
    //clean up xml not needed
    begin
      try
        fXML.Free;
        fxml:=nil; 
      except on E: Exception do
      end;
      
      //cleanup the list of procedure from client we dont nedd 
      try
        if assigned(StateCollection) then
        begin
          StateCollection.FInternalProcedureList.Free;
          StateCollection.FInternalProcedureList := nil;
        end;
      except on E: Exception do
      end;


    end;
  end;

end;


//create the xml class that can read and trasnsform the xml in to a FSA
function CreateXMLParser(Sender: TComponent) : TXMLParser;overload;
begin
  try
    Result := TXMLParser.Create(Sender);
  except on E: Exception do
    Result := NIL;
  end;

end;

//create and build the FSA
function CreateXMLParser(AOwner: TComponent
        ;const FileName: string
        ;Var ComponentWithProceduresForActions:Tcomponent
        ;var ListOfActionsNotAssigned:TStringList) : TXMLParser; overload;
begin
  try
    Result := TXMLParser.CreateAndBuildFSA(AOwner
      ,FileName,ComponentWithProceduresForActions,ListOfActionsNotAssigned) ;
  except on E: Exception do
    Result := NIL;
  end;

end;








// get from componenet in parameter all teh function that look like the
//TActionFunction and add them in a list that contains the name of the function
//and the function
function TStateCollection.GetFunctionNames(const AClass: TComponent):boolean;
var
  Context: TRttiContext;
  RttiType: TRttiType;
  RttiMethod: TRttiMethod;
  Method: TMethod;
  i,j,ParametersCount: Integer;
  s:string;
begin
  Result := False;
  if assigned(FInternalProcedureList) then
    FInternalProcedureList.Free;

  FInternalProcedureList :=
    TList<TPair<string, TActionFunction>>.Create;
  Context := TRttiContext.Create;
  if assigned(FInternalProcedureList) then
  try
    try
      RttiType := Context.GetType(AClass.ClassType);
      if RttiType is TRttiInstanceType then
      begin
        for RttiMethod in TRttiInstanceType(RttiType).GetMethods do
        begin
          //for the functions
          if  (RttiMethod.MethodKind = TMethodKind.mkFunction  )
            and   (Length(RttiMethod.GetParameters) = 4)
          then
          begin
            j := 0;
            ParametersCount :=  Length(RttiMethod.GetParameters);
            for i := 0 to ParametersCount-1 do
            begin

              s := RttiMethod.GetParameters[i].Name;
              if SameText(RttiMethod.GetParameters[i].Name,ParametersNameList[i])
              then
                inc(j);

            end;
            if (j=4) then
            begin
              Method.Code := RttiMethod.CodeAddress;
              Method.Data := AClass;
              FInternalProcedureList.Add(TPair<string, TActionFunction>
                .Create(RttiMethod.Name, TActionFunction(Method)));
            end;

          end
          else
          //for the callback  , wich is a procedure
          if  (RttiMethod.MethodKind = TMethodKind.mkProcedure  )
            and (Length(RttiMethod.GetParameters) = 5)
          then
          begin
            j := 0;
            ParametersCount :=  Length(RttiMethod.GetParameters);
            for i := 0 to ParametersCount-1 do
            begin

              s := RttiMethod.GetParameters[i].Name;
              if SameText(RttiMethod.GetParameters[i].Name,ParametersNameList[i])
              then
                inc(j);

            end;

            if (j=5) then
            begin
              self.FActionDispatcherCallBack:= TActionDispatcherProcedure(Method)
            end;

          end;

        end;
      end;

      if assigned(FInternalProcedureList)  and  (FInternalProcedureList.Count>0)
      then
        Result := true;

    except on E: Exception do
      Result := False;
    end;

  finally
    Context.Free;
  end;
end;

procedure TStateCollection.RunDispatcherCallBack(Event: TStateEvent; NextState: TState);
begin
  //call the Dispatcher in case there must be done at each action
  if Assigned(FActionDispatcherCallBack) then
    self.FActionDispatcherCallBack(self.CurentState.Name, NextState.Name, event.Name, '', 'cucu');
end;

{
// to split in 2 : one to check that supersate has this event and second to
//retuern the new state
function TStateCollection.SetNextStateFromSuperState(const sEventName: string
  ; var NextState: TState; var SuperState: TState
  ; var EventSuperState: TStateEvent):boolean;
var
  NextStateFromSuperState: TState;
  IdSuperState:integer;
begin
  Result := false;
  //see if superstate and this event will change state
  try
    if assigned(CurentState) then
    begin
        IdSuperState :=  self.CurentState.IdSuperState;
        SuperState := self.GetStateById(IdSuperState);
        NextStateFromSuperState := nil;
        //if currrent state has superstate
        if assigned(SuperState) then
        begin
          //if the supewrsate has events ???
          if SuperState.Events.Count > 0 then
          begin
            //does the supersate conatin the event from param
            EventSuperState := SuperState.FindEventName(sEventName);
            if assigned(EventSuperState) then
            begin
              //if the event next state is not the same as the superstate
              //then the next state will change
              if EventSuperState.IdNextState <> IdSuperState then
                NextStateFromSuperState := self.GetStateById(EventSuperState.IdNextState);
              //if the supersate has the event from param then return true so
              //actions can be called
              Result := true;
            end;
          end;
          if assigned(NextStateFromSuperState) then
          begin
            NextState := NextStateFromSuperState;
          end;
        end;
    end;
  except on E: Exception do
    begin
      Result := false;
      EventSuperState := nil;
    end;
  end;
end;
}
{
//run all action for the givenm event
function TStateCollection.RunAllActionsForThisEvent
  (Event: TStateEvent; NextState: TState
  ; var CurrAction: TAction;const bLaunchBeforeStateChange:boolean):boolean;
var
  Local_I: Integer;
  bFunctionResult:boolean;
  sNextEvent:string;
begin
  Result := False;
  try
    //if event has actions
    if assigned(Event.Actions) and  (Event.Actions.Count>0) then
    begin
        //for each action
        sNextEvent := '';
        for Local_I := 0 to Event.Actions.Count - 1 do
        begin
          CurrAction := Event.Actions.Items[Local_I];
          if assigned(CurrAction) then
          begin
            //is it b4 or after state change
            if (CurrAction.CallBackBefareStateChange = bLaunchBeforeStateChange) then
            begin
              //call the procedure associated with this action
              if Assigned(CurrAction.ActionCallBack) then
              begin
                bFunctionResult := CurrAction.ActionCallBack(self.CurentState.Name
                  , NextState.Name
                  , event.Name
                  , Curraction.Name);
                //set the next event if functions returns true
                if bFunctionResult then
                  sNextEvent :=  CurrAction.EventToSendAtEndWithSuccess
                else
                  sNextEvent :=  CurrAction.EventToSendAtEndWithFailure;
                self.FEventsQueue.Enqueue(sNextEvent)
              end;
            end;
          end;
        end;
    end;
  except on E: Exception do
    Result := false;
  end;

end;
}
//chaneg ethe enum to its name , warning they must not have assigned integer
function TStateCollection.EnumToString<T>(const EnumValue: T): string;
var
  EnumType: PTypeInfo;
  EnumData: PTypeData;
begin
  Result := '';
  try
    EnumType := TypeInfo(T);
    if assigned(EnumType) then
    begin
      EnumData := GetTypeData(EnumType);
      Result := GetEnumName(EnumType, PByte(@EnumValue)^);
    end;
  except on E: Exception do
    Result := '';
  end;
end;

//if its the last event and there is a state change cehck to see
//if the old state has an OnExit event and the new state has a OnEnter Event
procedure TStateCollection.RunOnEnterAndOnExitEventsIfTheyExists
  (var localCurrentState: TState; OldState: TState
    //;const bIsSUperState: Boolean
  );
var
  OutStateNotUsed: TState;
begin
  //run the onexit and onenter events if they exists
  //if not bIsSUperState then
  begin
    //last one
    if  true
      //and (FEventsQueue.Count = 1)
      and
        ( //state has changed
          not SameText(OldState.Name, localCurrentState.Name)
        )
    then

    begin
      if (OldState.OnExitEventExists) then
        OldState.InPutEventInThisState('OnExit', OutStateNotUsed);
      if (localCurrentState.OnEnterEventExists) then
        localCurrentState.InPutEventInThisState('OnEnter', OutStateNotUsed);
    end;
  end;
end;

//add a state to the FSA
//used at creation of FSA from XML
function TStateCollection.AddState(const sName:string;const idState:integer):TState;
Var
  iPos :integer;
begin
  try
    Result := TState(self.Add);
    Result.IdEqualTOIdState:=Result.ID=idState;
  except on E: Exception do
    Result := Nil;
  end;
end;



//--------------------------threaded FSA-----------------------------------------

 constructor TFSAThreaded.Create(FSA:TStateCollection);
 begin
  inherited Create(True); // Create suspended
  FFSA := FSA;
  FFreezeEvent := TEvent.Create;
 end;

 destructor TFSAThreaded.Destroy;
 begin
  try
    KillTimer;
  except on E: Exception do
  end;
  try
    FFreezeEvent.Free;
  except on E: Exception do
  end;
   try
    self.FFSA.Free;
  except on E: Exception do
  end;
  inherited;
 end;

//stop the thread in order to be destroyed
procedure TFSAThreaded.KillTimer;
begin
  //clear the event queue
  if assigned(self.FFSA) then
    self.FFSA.EventsQueue.Clear;
  //signal thread to terminate
  sELF.Terminate;
  //set the event that freeze the thread
  SELF.FFreezeEvent.SetEvent;
  WaitFor;

end;

//input an event to the FSA
function TFSAThreaded.InputEvent(const sEventName:string) : boolean;
var
  bFirstOne:boolean;
begin
  Result := false;
  try
    if (Length(Trim(sEventName))>0)
      and assigned(self.FFSA)
    then
    begin
      //check if it is the first one
      bFirstOne :=  FFSA.EventsQueue.IsEmpty;
      if assigned(FFSA.EventsQueue) then
      begin
        FFSA.FEventsQueue.Enqueue(sEventName);
        //if its the first set event so it will work again
        if bFirstOne then
          self.FFreezeEvent.SetEvent;
      end
      else
        Result := false;
    end;
  except on E: Exception do
    Result := false;
  end;
end;

//run tthread
procedure TFSAThreaded.Execute;
Var
  bHasChangedState:boolean;
  localCurrentState:TState;
begin
  localCurrentState := nil;

  while not Terminated do
  begin
    if assigned(self.FFSA) then
    begin
      //do events inm yhhe queue
      FFSA.RunEventsFromQueueUseItemsFunctions(localCurrentState
        ,false,bHasChangedState);
      // if no more eventsthen freeze no need to run it is useless
      if FFSA.EventsQueue.Count=0 then
        SELF.FFreezeEvent.WaitFor(INFINITE);

    end;

  end;
 end;

//-----------------tqueue a TStringList Variatiopn------------------------------------
// multi threaded
constructor TQueueStrings.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FQueue :=  TThreadList<string>.Create;
  FQueue.Duplicates := TDuplicates.dupAccept;
  //FQueue :=  TStringList.Create;
end;

destructor TQueueStrings.Destroy;
begin
  FQueue.Free;
  inherited Destroy;
end;

//ad to queue
procedure TQueueStrings.Enqueue(Value: string);
begin
  if assigned(FQueue) and (Length(Trim(Value))>0)  then
    FQueue.Add(Value);
end;

//remove from queue
function TQueueStrings.Dequeue: string;
var
  List: TList<string>;
begin
  Result := '';
  List := GetList;
  try
    if assigned(List) then
    begin
      if List.Count > 0 then
      begin
        Result := List[0];
        List.Delete(0);
      end
      else
        Result := '';
    end;
  finally
    FQueue.UnlockList;
  end;
end;

//delete all from list
procedure TQueueStrings.Clear;
var
  List: TList<string>;
begin
  List := GetList;
  try
    if List.Count > 0 then
      List.Clear;
  finally
    FQueue.UnlockList;
  end;
end;

//get count of elements in queue
function TQueueStrings.Count: integer;
var
  List: TList<string>;
begin
  Result := 0;
  List := GetList  ;
  try
    if assigned(List) then
    begin
      Result := List.Count;
    end;
  finally
    FQueue.UnlockList;
  end;


end;

//get the first in queue
function TQueueStrings.Peek: string;
var
  List: TList<string>;
begin
  List := GetList;
  if assigned(List) then
  begin
    try
      if List.Count > 0 then
        Result := List[0]
      else
        Result := '';
    finally
      FQueue.UnlockList;
    end;
  end;
end;


// is the queue empty
function TQueueStrings.IsEmpty: Boolean;
var
  List: TList<string>;
begin
  List := GetList;
  try
    if assigned(List) then
      Result := List.Count = 0
    else Result := true;
  finally
    FQueue.UnlockList;
  end;


end;

//for DRY purposes
function TQueueStrings.GetList:System.Generics.Collections.TList<string>;
begin
  Result := Nil;
  if assigned(FQueue) then
    Result := FQueue.LockList
end;

//-----------------------------TLoggingClass- --------------------
{
constructor TLoggingClass.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  self.FLogEnterFunctionProcedure := NIL;
  self.FLogExitFunctionProcedure := nil;
  self.FLogSendNameValue := nil;
  self.FLogExceptionRaised := nil;
end;

procedure TLoggingClass.SetLoggingProcedures(
      FLogEnterFunctionProcedure:TLogEnterFunctionProcedure ;
      FLogExitFunctionProcedure:TLogExitFunctionProcedure;
      FLogSendNameValue:TLogSendNameValue ;
      FLogExceptionRaised :TLogExceptionRaised
    );
begin
  self.FLogEnterFunctionProcedure:=FLogEnterFunctionProcedure ;
  self.FLogExitFunctionProcedure:=FLogExitFunctionProcedure;
  self.FLogSendNameValue:= FLogSendNameValue ;
  self.FLogExceptionRaised :=  FLogExceptionRaised;
end;


procedure TLoggingClass.CallLogEnterFunctionProcedure
(const sFunctionName:string) ;
begin
  try
      if assigned(FLogEnterFunctionProcedure) then
        FLogEnterFunctionProcedure(sFunctionName);
  except on E: Exception do
  end;

end;
procedure TLoggingClass.CallLogExitFunctionProcedure
(const sFunctionName:string) ;
begin
  try
    if assigned(FLogExitFunctionProcedure) then
      FLogExitFunctionProcedure(sFunctionName);
  except on E: Exception do
  end;

end;
procedure TLoggingClass.CallLogSendNameValue (const sName,sValue:string) ;
begin
  try

    if assigned(FLogSendNameValue) then
      FLogSendNameValue(sName,sValue);
  except on E: Exception do
  end;
end;

procedure TLoggingClass.CallLogSendNameValue (const Value:TValue) ;
Var
  sValue,sName:string;
begin
  if assigned(FLogSendNameValue)
  then
  begin
    if Value.TryAsType<string>(sValue) then
    begin
        sName := self.GetVariableName(Value) ;
        self.FLogSendNameValue(sName,sValue);
    end;
  end;
end;

procedure TLoggingClass.CallLogExceptionRaised(const sExceptionMessage:string);
begin
  try
      if assigned(FLogExceptionRaised) then
        FLogExceptionRaised(sExceptionMessage);
  except on E: Exception do
  end;
end;

function TLoggingClass.GetVariableName(const Value: TValue): string;
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  RttiField: TRttiField;
begin
  Result := '';
  RttiContext := TRttiContext.Create;
  try
    RttiType := RttiContext.GetType(Value.TypeInfo);
    if RttiType <> nil then
    begin
      // Check if the value is an object or record
      if (Value.IsObject) or (Value.Kind = tkRecord) then
      begin
        // Get the field that holds the reference to the object/record
        RttiField := RttiType.GetField('FRefCount');
        if RttiField <> nil then
          Result := RttiField.Name;
      end
      else
      begin
        // For other types (e.g., Integer, String, etc.), use the TypeInfo
        Result := RttiType.Name;
      end;
    end;
  finally
    RttiContext.Free;
  end;
end;
}


//-------------------------------tools to create code from xml file-----------------
procedure ExtractActionNamesFromTreeXML(const xmlData: string
    ; Var actionNamesList: TStringList
    ; Var eventNamesList: TStringList
  );

var
  xmlDoc: IXMLDocument;
  rootNode, actionNode,eventNode: IXMLNode;

  procedure ProcessNode(node: IXMLNode);
  var
    childNode: IXMLNode;
    sName:string;
  begin
    // Process "action" nodes at the current level
    if node.NodeName = StrAction then
    begin
      actionNode := node;
      // Extract action name and add it to the list (avoiding duplicates using SameText)
      if (actionNode.HasAttribute(StrName)) then
      begin
        sName:= VartoStr( actionNode.Attributes[StrName]);
        if Length(sName)>0 then
        begin
          if actionNamesList.IndexOf(sName) = -1  then
            actionNamesList.Add(sName);
        end;
      end;
    end;
    if node.NodeName = StrEvent then
    begin
      eventNode := node;
       if (eventNode.HasAttribute(StrName)) then
       begin
        sName:= VartoStrDef( eventNode.Attributes[StrName],'');
        if (Length(sName)>0)  then
        begin
          if eventNamesList.IndexOf(sName) = -1 then
            eventNamesList.Add(sName);
        end;
       end;
    end;
    // Recursively process child nodes
    childNode := node.ChildNodes.First;
    while Assigned(childNode) do
    begin
      ProcessNode(childNode);
      childNode := childNode.NextSibling;
    end;
  end;
begin
  xmlDoc := TXMLDocument.Create(nil);
  try
    if not assigned(actionNamesList) then
      actionNamesList := TstringList.Create(dupIgnore,true,False);
    //xmlDoc.LoadFromXML(xmlData);
    xmlDoc.LoadFromFile(xmlData);
    // Get the root node
    rootNode := xmlDoc.DocumentElement;
    // Traverse the tree and collect action names
    ProcessNode(rootNode);
  finally
    xmlDoc := nil;
  end;
end;

function CreateListOfProcedures(const sFileName:string
  ;const bForImplemenTation:boolean
  ;const bForMainForm:boolean
  ;Var ListWithCode : TStrings):boolean;
var
  actionNamesList,eventNamesList:TStringList;
  i: Integer;
  Res:boolean;
begin
  Res := false;
  actionNamesList := TStringList.Create(dupIgnore,false,false);
  eventNamesList := TStringList.Create(dupIgnore,false,false);
  try
    if  assigned(ListWithCode) and (FileExists(sFileName)) then
    begin
      ExtractActionNamesFromTreeXML(sFileName,actionNamesList,eventNamesList);
      if actionNamesList.count > 0 then
        Res := true;

      if not bForMainForm then
      begin

        if not bForImplemenTation then
        begin
          ListWithCode.Add('TFSAEvents = ('

          );
          ListWithCode.Add('   '+eventNamesList.Strings[0]

                );
          for i := 1 to eventNamesList.Count-1 do
          begin
            ListWithCode.Add(',   '+eventNamesList.Strings[i]

              );
          end;
          ListWithCode.Add(');');
          ListWithCode.Add('TClassName = class(TDataModule)' );
          ListWithCode.Add('    private' );
          ListWithCode.Add('  { Private declarations } ' );
          ListWithCode.Add('public');
          ListWithCode.Add('  { Public declarations } ');
          ListWithCode.Add('XMLParser:TXMLParser; ' );
          ListWithCode.Add('sFSAFileName:string;' );
          ListWithCode.Add('ListOfUnAssignedProcedures:TstringList;' );
          ListWithCode.Add('function InputEvent(const sEventName:string):boolean; overload ;');
          ListWithCode.Add('function InputEvent(const EnumValue:TFSAEvents):boolean; overload  ;');
          ListWithCode.Add('function InitFSA:boolean;' );
          ListWithCode.Add('Procedure startFsa;' );
        end;

        if bForImplemenTation then
        begin
          ListWithCode.Add('uses');
          ListWithCode.Add(' System.TypInfo');
          ListWithCode.Add(';');

        end;


        for i := 0 to actionNamesList.count-1 do
        begin
          if bForImplemenTation then
          begin
            actionNamesList.Strings[i] := 'function '
              + 'TClassName.'
              +  actionNamesList.Strings[i]
              + '(const CurrentStateName,NextStateName,EventName,ActionName:string):boolean; '
              + #13#10
              + 'Var sVValue :string;'
              +  #13#10
              + 'begin' + #13#10
              + '  Result := false;'  + #13#10
              + '  try'    + #13#10
              + '    MainForm.'+ actionNamesList.Strings[i]+'(sVValue);' + #13#10
              + '    Result := TRue;'+ #13#10
              + '  except on E: Exception do'   + #13#10
              + '    Result := false;' + #13#10
              + '  end;' + #13#10
              +'end ;'
          end
          else
          begin
            actionNamesList.Strings[i] := 'function '
              +  actionNamesList.Strings[i]
              + '(const CurrentStateName,NextStateName,EventName,ActionName:string):boolean '
              +';'
              ;
          end;
        end;

        if bForImplemenTation then
        begin
          ListWithCode.Add('//-----------------------input event procedures--------------------- ');
          ListWithCode.Add('function TClassName.InputEvent(const EnumValue:TFSAEvents):boolean;');
          ListWithCode.Add('var  sName:string;');
          ListWithCode.Add('begin');
          ListWithCode.Add(' Result := false;');
          ListWithCode.Add(' if assigned(self.XMLParser) and assigned(self.XMLParser.FSA) then ');
          ListWithCode.Add(' begin ');
          ListWithCode.Add('   sName := GetEnumName(TypeInfo(TFSAEvents), Ord(EnumValue));');
          ListWithCode.Add('   Result := self.XMLParser.FSA.InputEvent(sName);');
          ListWithCode.Add(' end; ');
          ListWithCode.Add('end; ');

          ListWithCode.Add('function TClassName.InputEvent(const sEventName:string):boolean;');
          ListWithCode.Add('begin');
          ListWithCode.Add('  Result := false;');
          ListWithCode.Add('  if assigned(self.XMLParser) and assigned(self.XMLParser.FSA) then');
          ListWithCode.Add('  begin');
          ListWithCode.Add('    Result := self.XMLParser.FSA.InputEvent(sEventName);');
          ListWithCode.Add('  end;');
          ListWithCode.Add('end;');

          ListWithCode.Add('function TClassName.InitFSA:boolean;' );
          ListWithCode.Add('begin');
          ListWithCode.Add('  Result := false;');
          ListWithCode.Add('  if not assigned(self.XMLParser) then XMLParser := TXMLParser.Create(self);');
          ListWithCode.Add('  if assigned(self.XMLParser) and assigned(self.XMLParser.FSA) then');
          ListWithCode.Add('  begin');
          ListWithCode.Add('    self.XMLParser.BuildFSA(self.sFSAFileName,self,ListOfUnAssignedProcedures);');
          ListWithCode.Add('  end;');
          ListWithCode.Add('end;');

          ListWithCode.Add('Procedure TClassName.startFsa;');
          ListWithCode.Add('begin');
          ListWithCode.Add('  if assigned(self.XMLParser) and assigned(self.XMLParser.FSA) then');
          ListWithCode.Add('  begin');
          ListWithCode.Add('    self.XMLParser.FSA.InputEvent(TFSAEvents.Go);');
          ListWithCode.Add('  end;');
          ListWithCode.Add('end;');

          ListWithCode.Add('//-----------------------FSA procedures--------------------- ');

        end;


        ListWithCode.AddStrings(actionNamesList);
      end
      else
      begin
        if not bForImplemenTation then
        begin

          for i := 0 to actionNamesList.count-1 do
          begin
            ListWithCode.Add
            (
              '    function '+ actionNamesList.Strings[i]+'(const sVValue:string):boolean;'
            );
          end;
        end
        else
        begin
          for i := 0 to actionNamesList.count-1 do
          begin

            ListWithCode.Add('function '
              + 'TMainForm.'
              +  actionNamesList.Strings[i]
              + '(const sVValue:string):boolean; '
              + #13#10
              + 'begin' + #13#10
              + '  Result := false;'  + #13#10
              + '  try'    + #13#10
              + '    Result := TRue;'+ #13#10
              + '  except on E: Exception do'   + #13#10
              + '    Result := false;' + #13#10
              + '  end;' + #13#10
              +'end ;' );
          end;
        end;
      end;
    end;
   finally
  end;
  Result := Res;

end;

//-------------------------------------------------------------------------------------
{ TCrossPlatformLogger }

class function TCrossPlatformLogger.GetLogFilePath: string;
begin
  Result := TPath.Combine(
    //TPath.GetDocumentsPath
    TPAth.GetSharedDownloadsPath
    , 'FSAlog_'
    +FormatDateTime(StrDateFormat,Now )
    +'.txt');
  self.sClassLogFileName := Result;
end;
class procedure TCrossPlatformLogger.LogAction(const currentstatename
  ,NextSTateNAme, eventname,actionName: string;Const bResult:boolean);
var

  LogFile: TextFile;
begin
  {$ifdef DEBUG}
  if not bLogFailed and bEnableLogs then
  try
    if Length(sClassLogFileName)=0 then
      sClassLogFileName := GetLogFilePath;
    AssignFile(LogFile,sClassLogFileName);
    if FileExists(sClassLogFileName) then
    begin
      Append(LogFile);
    end
    else
      Rewrite(LogFile);
    Writeln(LogFile, Format('%s - Current State: %s,NextState : %s, Event: %s'+
      ',Action:%s with result = %s'
      , [FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)
        , currentstatename,NextSTateNAme, eventname,actionName
        ,BoolToStr(bResult,true)
        ]));
    CloseFile(LogFile);
  except on E: Exception do
    begin
      bLogFailed := true;
      ShowMessage(e.message);
    end;
  end;
  {$endif}
end;
class procedure TCrossPlatformLogger.LogNameValue(const name
  ,value: string) ;//Var sFileName:string

var
  LogFile: TextFile;
begin
  {$ifdef DEBUG}
  if not bLogFailed and bEnableLogs then
  try
    if Length(self.sClassLogFileName)=0 then
      sClassLogFileName := GetLogFilePath;

    AssignFile(LogFile,sClassLogFileName);
    if FileExists(sClassLogFileName) then
    begin
      Append(LogFile);
    end
    else
      Rewrite(LogFile);
    Writeln(LogFile,'        '+name+' : '+value );
    CloseFile(LogFile);
  except on E: Exception do
    begin
      bLogFailed := true;
      ShowMessage(e.message);
    end;
  end;
  {$endif}
end;
class procedure TCrossPlatformLogger.NewLogs;
var
  LogFile: TextFile;
begin

  if not bLogFailed and bEnableLogs then
  try
    if Length(sClassLogFileName)=0 then
      sClassLogFileName := GetLogFilePath;
    AssignFile(LogFile, sClassLogFileName);
    if FileExists(sClassLogFileName) then
    begin
      Append(LogFile);
    end
    else
      Rewrite(LogFile);
      Writeln(LogFile, Format('%s ----------------NewLog---------------------- '
      , [FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)
      ]));
    CloseFile(LogFile);
  except on E: Exception do
    begin
      bLogFailed := true;
      ShowMessage(e.message + 'at TCrossPlatformLogger');
    end;
  end;

end;

class procedure TCrossPlatformLogger.InitLogs;
begin
   self.bEnableLogs := false;
  {$ifdef DEBUG}
  self.bEnableLogs := true;
  {$endif}
end;

end.



