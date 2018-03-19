unit HexUnit;

interface

//***Numbers convertion utilities***//
function IntCheckOut(S: String): Boolean;
//Returns TRUE if S contains the valid integer value
function HexCheckOut(S: String): Boolean;
//Returns TRUE if S contains the valid integer value or hXX style hex value
function UnsCheckOut(S: String): Boolean;
//Returns TRUE if S contains the valud unsigned value or hXX style hex value
function StrToInt(const S: String): Integer;
//Converts decimal String to 32 bit integer value
function HexToInt(const S: String): Integer;
//Converts hex-String to 32 bit integer value
function DecHexToInt(S: String): Integer;
//Converts decimal or hXX style hex-String to 32 bit integer value
function HexToCardinal(const S: String): Cardinal;
//Converts hex-String to 32 bit unsigned value
function GHexToInt(S: String): Integer;
//Converts hex-String of 0XXh style to integer value
function SwapWord(Value: Word): Word;
//Swaps bytes in 16 bit value
function SwapInt(Value: Integer): Integer;
//Swaps bytes in 32 bit value
function SwapInt64(const Value: Int64): Int64;
//Swaps bytes in 64 bit value
function IntToDelphiHex(const Value: Int64; Digits: Byte): String;
//Converts decimal to DELPHI format hex-String (ex: $135ABC)

var
 HexError: Boolean = False;
 IntError: Boolean = False;

implementation

uses SysUtils;

function IntToDelphiHex(const Value: Int64; Digits: Byte): String;
begin
 if Value < 0 then
 begin
  if Value = Low(Int64) then
   Result := '-$8000000000000000' else
   Result := '-$' + IntToHex(-Value, Digits);
 end else Result := '$' + IntToHex(Value, Digits);
end;

function StrToInt(const S: String): Integer;
var
 E: Integer;
begin
 Val(S, Result, E);
 IntError := E <> 0;
end;

function DecHexToInt(S: String): Integer;
begin
 IntError := True;
 if S = '' then
 begin
  Result := 0;
  Exit;
 end;
 if S[1] in ['h', 'H'] then
 begin
  Delete(S, 1, 1);
  if S = '' then
  begin
   Result := 0;
   HexError := True;
   IntError := False;
  end else
  begin
   Result := HexToInt(S);
   IntError := False;
  end;
 end else Result := StrToInt(S);
end;

function GHexToInt(S: String): Integer;
var
 I, LS, J: Integer; PS: PChar; H: Char;
begin
 HexError := True;
 Result := 0;
 LS := Length(S);
 if (LS <= 0) then Exit;
 if Upcase(S[LS]) <> 'H' then
 begin
  HexError := False;
  Result := StrToInt(S);
  Exit;
 end else
 begin
  Dec(LS);
  SetLength(S, LS);
  if (LS > 8) and (S[1] = '0') then Delete(S, 1, 1);
  LS := Length(S);
 end;
 if LS > 8 then Exit;
 HexError := False;
 PS := Pointer(S);
 I := LS - 1;
 J := 0;
 While I >= 0 do
 begin
  H := UpCase(PS^);
  if H in ['0'..'9'] then J := Byte(H) - 48 else
  if H in ['A'..'F'] then J := Byte(H) - 55 else
  begin
   HexError := True;
   Result := 0;
   Exit;
  end;
  Inc(Result, J shl (I shl 2));
  Inc(PS);
  Dec(I);
 end;
end;

function HexToInt(const S: String): Integer;
var
 I, LS, J: Integer; PS: PChar; H: Char;
begin
 HexError := True;
 Result := 0;
 LS := Length(S);
 if (LS <= 0) or (LS > 8) then Exit;
 HexError := False;
 PS := Pointer(S);
 I := LS - 1;
 J := 0;
 While I >= 0 do
 begin
  H := UpCase(PS^);
  if H in ['0'..'9'] then J := Byte(H) - 48 else
  if H in ['A'..'F'] then J := Byte(H) - 55 else
  begin
   HexError := True;
   Result := 0;
   Exit;
  end;
  Inc(Result, J shl (I shl 2));
  Inc(PS);
  Dec(I);
 end;
end;

function HexToCardinal(const S: String): Cardinal;
var
 I, LS: Integer; PS: PChar; H: Char; J: Cardinal;
begin
 HexError := True;
 Result := 0;
 LS := Length(S);
 if (LS <= 0) or (LS > 8) then Exit;
 HexError := False;
 PS := Pointer(S);
 I := LS - 1;
 J := 0;
 While I >= 0 do
 begin
  H := UpCase(PS^);
  if H in ['0'..'9'] then J := Byte(H) - 48 else
  if H in ['A'..'F'] then J := Byte(H) - 55 else
  begin
   HexError := True;
   Result := 0;
   Exit;
  end;
  Inc(Result, J shl (I shl 2));
  Inc(PS);
  Dec(I);
 end;
end;

function IntCheckOut(S: String): Boolean;
var I: Integer;
begin
 if S <> '' then
 begin
  Result := True;
  if S[1] = '-' then Delete(S, 1, 1);
  if (Length(S) > 10) or (S = '') then
  begin
   Result := False;
   Exit;
  end;
  for I := 1 to Length(S) do if not (S[I] in ['0'..'9']) then
  begin
   Result := False;
   Exit;
  end;
 end else Result := False;
end;

function HexCheckOut(S: String): Boolean;
var I: Integer;
begin
 Result := False;
 if S = '' then Exit;
 Result := True;
 if S[1] in ['h', 'H'] then
 begin
  Delete(S, 1, 1);
  if (Length(S) > 8) or (S = '') then
  begin
   Result := False;
   Exit;
  end;
  for I := 1 to Length(S) do
   if not (S[I] in ['0'..'9', 'A'..'F', 'a'..'f']) then
   begin
    Result := False;
    Exit;
   end;
 end else
 begin
  if S[1] = '-' then
   Delete(S, 1, 1);
  if (Length(S) > 10) or (S = '') then
  begin
   Result := False;
   Exit;
  end;
  for I := 1 to Length(S) do
   if not (S[I] in ['0'..'9']) then
   begin
    Result := False;
    Exit;
   end;
 end;
end;

function UnsCheckOut(S: String): Boolean;
var I: integer;
begin
 Result := False;
 if S = '' then Exit;
 Result := True;
 if S[1] in ['h', 'H'] then
 begin
  Delete(S, 1, 1);
  if (Length(S) > 8) or (S = '') then
  begin
   Result := False;
   Exit;
  end;
  for I := 1 to Length(S) do
   if not (S[I] in ['0'..'9', 'A'..'F', 'a'..'f']) then
   begin
    Result := False;
    Exit;
   end;
 end else
 begin
  if (Length(S) > 10) or (S = '') then
  begin
   Result := False;
   Exit;
  end;
  for I := 1 to Length(S) do
   if not (S[I] in ['0'..'9']) then
   begin
    Result := False;
    Exit;
   end;
 end;
end;

function SwapInt(Value: Integer): Integer;
asm
 bswap  eax
end;

function SwapWord(Value: Word): Word;
asm
 xchg   al,ah
end;

function SwapInt64(const Value: Int64): Int64;
type
 TInt64 = packed record
  A: Integer;
  B: Integer;
 end;
var
 Val: TInt64 absolute Value;
 Res: TInt64 absolute Result;
begin
 Res.A := SwapInt(Val.B);
 Res.B := SwapInt(Val.A);
end;

end.
