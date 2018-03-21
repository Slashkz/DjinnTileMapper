{******************************************
Параметр TheBit считается в пределах 0..31
******************************************}

unit BitWise;

interface
type
  PByteSet = ^TByteSet;  
  TByteSet = set of Byte;


function IsBitSet(const val: longint; const TheBit: byte): boolean;
function BitOn(const val: longint; const TheBit: byte): LongInt;
function BitOff(const val: longint; const TheBit: byte): LongInt;
function BitToggle(const val: longint; const TheBit: byte): LongInt;
function GetBites(Value , Mask: LongWord): LongWord;
function ShiftBites(Value, Mask: LongWord; Shift: Byte): LongWord;

implementation

function IsBitSet(const val: longint; const TheBit: byte): boolean;
begin
  result := (val and (1 shl TheBit)) <> 0;
end;

function BitOn(const val: longint; const TheBit: byte): LongInt;
asm
  mov ecx, edx;
  mov edx, 1;
  shl edx, cl;
  or eax, edx;
end;

function BitOff(const val: longint; const TheBit: byte): LongInt;
begin
  result := val and ((1 shl TheBit) xor $FFFFFFFF);
end;

function BitToggle(const val: longint; const TheBit: byte): LongInt;
begin
  result := val xor (1 shl TheBit);
end;


function GetBites(Value, Mask: LongWord): LongWord;
asm
  and eax, edx;
end;

function ShiftBites(Value, Mask: LongWord; Shift: Byte): LongWord;
asm
  shr eax, cl;
  and eax, edx;
end;

//var
//  W: Word;
//...
//{ Если бит 3 в слове W установлен, тогда ... }
//  if 3 in PByteSet(@W)^ then ...

end.
 