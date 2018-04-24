unit Spravochnik_1;

interface
uses
  SysUtils, Vcl.Grids, Vcl.Dialogs;

type
TShopInfo = record
  id: integer;
  name: string[30];
  adress: string[30];
  tel: string[30];
end;
PShopList = ^TShopList;
TShopList = record
  Inf: TShopInfo;
  Adr: PShopList;
end;

TSectorInfo = record
  id: integer;
  shopid: integer;
  name: string[30];
  zav: string[30];
  tel: string[30];
end;
PSectorList = ^SectorList;
SectorList = record
  Inf: TSectorInfo;
  Adr: PSectorList;
end;

TProductInfo = record
    shopid: Integer;
    sectid:Integer;
    Date: TDateTime;
    VendorCode: string[10];
    Name: string[40];
    Count: Integer;
    Price: Currency;
end;
PProductList = ^ProductList;
ProductList = record
  Inf: TProductInfo;
  Adr: PProductList;
end;

TSortMode = function(r1, r2: TProductInfo): Boolean;

procedure createShopHead(var head: PShopList);
procedure insertShopList(const head: PShopList; shop: TShopInfo);
procedure editShopList(const head: PShopList; id: integer; shop:TShopInfo);
procedure deleteShopList(const head: PShopList; SectHead: PSectorList; ProdHead: PProductList; id: integer);
procedure writeShopList(Grid:TStringGrid; const head:PShopList);
function isShopIDFound(head: PShopList; id: integer):boolean;
procedure saveShopList(head:PShopList);
function readShopFile(const head:PShopList):integer;
function getShopName(head: PShopList; id: integer):string;
function getShopID(head:PShopList; name:string):integer;

procedure createSectHead(var head: PSectorList);
procedure insertSectList(const head: PSectorList; sect: TSectorInfo);
procedure editSectList(const head: PSectorList; id: integer; sect:TSectorInfo);
procedure deleteSectList(const head: PSectorList; ProdHead: PProductList; id: integer);
procedure deleteSectListKek(const head: PSectorList; ProdHead: PProductList; kek: integer);
procedure writeSectList(Grid:TStringGrid; const head:PSectorList; ShopAdr:  PShopList);
function isSectIDFound(head: PSectorList; id: integer):boolean;
procedure saveSectList(head:PSectorList);
function readSectFile(const head:PSectorList):integer;
function getSectName(head: PSectorList; id: integer):string;

procedure createProdHead(var head: PProductList);
procedure insertProdList(const head: PProductList; prod: TProductInfo);
procedure editProdList(const head: PProductList; id: string; prod: TProductInfo);
procedure deleteProdList(const head: PProductList; id: string);
procedure deleteProdListKek(const head: PProductList; kek: integer);
procedure writeProdList(Grid:TStringGrid; const head:PProductList; ShopHead:PShopList; SectHead: PSectorList);
procedure sortProdList(const head:PProductList; kek: TSortMode);
procedure saveProdList(head:PProductList);
procedure readProdFile(const head:PProductList);
function isProdIDFound(head: PProductList; id: string):boolean;

function ShopIDsort (r1, r2: TProductInfo): Boolean;
function SectIDsort (r1, r2: TProductInfo): Boolean;
function ArtIDsort (r1, r2: TProductInfo): Boolean;

//Nikitos funct
function GetProdCount:Integer;
function GetProdPrice:Currency;
function GetProdDate:TDate;
function GetProdVendor(const producthead:PProductList):string;
function GetProdsectID(const sectorhead:PSectorList):Integer;
function GetProdShopID(const shophead:PShopList):Integer;
function GetSectID(head:PSectorList; name:string):integer;
function top12(r1, r2: TProductInfo): Boolean;
implementation

function top12(r1, r2: TProductInfo): Boolean;
begin
  Result:= r1.Name > r2.Name;
end;

procedure createShopHead(var head: PShopList);
begin
  new(head);
  head.Adr := nil;
end;

procedure createSectHead(var head: PSectorList);
begin
  new(head);
  head.Adr := nil;
end;

procedure createProdHead(var head: PProductList);
begin
  new(head);
  head.Adr := nil;
end;

procedure insertShopList(const head: PShopList; shop: TShopInfo);
var
  temp:PShopList;
begin
  temp := head;
  while temp^.adr <> nil do
  begin
    temp := temp^.adr;
  end;
  new(temp^.adr);
  temp:=temp^.adr;
  temp^.adr:=nil;
  temp^.Inf := shop;
end;

procedure insertSectList(const head: PSectorList; sect: TSectorInfo);
var
  temp:PSectorList;
begin
  temp := head;
  while temp^.adr <> nil do
  begin
    temp := temp^.adr;
  end;
  new(temp^.adr);
  temp:=temp^.adr;
  temp^.adr:=nil;
  temp^.Inf := sect;
end;

procedure insertProdList(const head: PProductList; prod: TProductInfo);
var
  temp:PProductList;
begin
  temp := head;
  while temp^.adr <> nil do
  begin
    temp := temp^.adr;
  end;
  new(temp^.adr);
  temp:=temp^.adr;
  temp^.adr:=nil;
  temp^.Inf := prod;
end;

procedure editShopList(const head: PShopList; id: integer; shop:TShopInfo);
var
  temp: PShopList;
begin
  temp:= head;

  while (temp <> nil)do
  begin
    if temp^.Inf.id = id then
    begin
      temp^.Inf := shop;
      temp^.Inf.id := id;
      exit;
    end;
    temp := temp^.Adr;
  end;
end;

procedure editSectList(const head: PSectorList; id: integer; sect:TSectorInfo);
var
  temp: PSectorList;
begin
  temp:= head;

  while (temp <> nil)do
  begin
    if temp^.Inf.id = id then
    begin
      temp^.Inf := sect;
      temp^.Inf.id := id;
      exit;
    end;
    temp := temp^.Adr;
  end;
end;

procedure editProdList(const head: PProductList; id: string; prod: TProductInfo);
var
  temp: PProductList;
begin
  temp:= head;
  while (temp <> nil)do
  begin
    if temp^.Inf.VendorCode = id then
    begin
      temp^.Inf := prod;
      temp^.Inf.VendorCode := id;
      exit;
    end;
    temp := temp^.Adr;
  end;
end;

procedure deleteProdList(const head: PProductList; id: string);
var
  temp,temp2:PProductList;
begin
  temp := head;
  while temp^.adr <> nil do
  begin
    temp2 := temp^.adr;
    if temp2^.Inf.VendorCode = id then
    begin
      temp^.adr := temp2^.adr;
      dispose(temp2);
    end
    else
      temp:= temp^.adr;
  end;
end;

procedure deleteProdListKek(const head: PProductList; kek: integer);
var
  temp,temp2:PProductList;
begin
  temp := head;
  while temp^.adr <> nil do
  begin
    temp2 := temp^.adr;
    if temp2^.Inf.sectid = kek then
    begin
      temp^.adr := temp2^.adr;
      dispose(temp2);
    end
    else
      temp:= temp^.adr;
  end;
end;



procedure deleteSectList(const head: PSectorList; ProdHead: PProductList; id: integer);
var
  temp,temp2:PSectorList;
begin
  deleteProdListKek(ProdHead, id);
  temp := head;
  while temp^.adr <> nil do
  begin
    temp2 := temp^.adr;
    if temp2^.Inf.id = id then
    begin
      temp^.adr := temp2^.adr;
      dispose(temp2);
    end
    else
      temp:= temp^.adr;
  end;
end;

procedure deleteSectListKek(const head: PSectorList; ProdHead: PProductList; kek: integer);
var
  temp,temp2:PSectorList;
begin
  temp := head;
  while temp^.adr <> nil do
  begin
    temp2 := temp^.adr;
    if temp2^.Inf.shopid = kek then
    begin
      deleteProdListKek(ProdHead, temp2^.Inf.id);
      temp^.adr := temp2^.adr;
      dispose(temp2);
    end
    else
      temp:= temp^.adr;
  end;
end;

procedure deleteShopList(const head: PShopList; SectHead: PSectorList; ProdHead: PProductList; id: integer);
var
  temp,temp2:PShopList;
begin
  deleteSectListKek(SectHead, ProdHead, id);
  temp := head;
  while temp^.adr <> nil do
  begin
    temp2 := temp^.adr;
    if temp2^.Inf.id = id then
    begin
      temp^.adr := temp2^.adr;
      dispose(temp2);
    end
    else
      temp:= temp^.adr;
  end;
end;

function getShopName(head: PShopList; id: integer):string;
var
  tmp: PShopList;
begin
  tmp:= head;
  while tmp <> nil do
  begin
    if tmp^.Inf.id = id then
    begin
      Result:= tmp^.Inf.name;
      exit;
    end;

    tmp:= tmp^.Adr;
  end;
end;

function getSectName(head: PSectorList; id: integer):string;
var
  tmp: PSectorList;
begin
  tmp:= head;
  while tmp <> nil do
  begin
    if tmp^.Inf.id = id then
    begin
      Result:= tmp^.Inf.name;
      exit;
    end;

    tmp:= tmp^.Adr;
  end;
end;

function getShopID(head:PShopList; name:string):integer;
var
  tmp: PShopList;
begin
  tmp:= head;
  while tmp <> nil do
  begin
    if tmp^.Inf.name = name then
    begin
      Result:= tmp^.Inf.id;
      exit;
    end;

    tmp:= tmp^.Adr;
  end;
end;
function getSectID(head:PSectorList; name:string):integer;
var
  tmp: PSectorList;
begin
  tmp:= head;
  while tmp <> nil do
  begin
    if tmp^.Inf.name = name then
    begin
      Result:= tmp^.Inf.id;
      exit;
    end;

    tmp:= tmp^.Adr;
  end;
end;

procedure writeShopList(Grid:TStringGrid; const head:PShopList);
var
  temp:PShopList;
begin
  Grid.ColCount := 7;
  Grid.RowCount := 2;
  Grid.Cells[0,0] := 'ID';
  Grid.Cells[1,0] := 'Name';
  Grid.Cells[2,0] := 'Adress';
  Grid.Cells[3,0] := 'number';
  Grid.Cells[4,0] := 'add';
  Grid.Cells[5,0] := 'Delete';
  Grid.Cells[6,0] := 'ведомость';
 // Grid.Cells[6,0] := 'Delete';
  //ShowMessage('kek');
  temp := head^.adr;
  while temp <> nil do
  begin
    Grid.Cells[0,Grid.RowCount - 1] := IntToStr(temp^.Inf.id);
    Grid.Cells[1,Grid.RowCount - 1] := temp^.Inf.name;
    Grid.Cells[2,Grid.RowCount - 1] := temp^.Inf.adress;
    Grid.Cells[3,Grid.RowCount - 1] := temp^.Inf.tel;
    Grid.Cells[4,Grid.RowCount - 1] := '+';
    Grid.Cells[5,Grid.RowCount - 1] := '-';
    Grid.Cells[6,Grid.RowCount - 1] := 'сформировать';
    temp:=temp^.adr;
    Grid.RowCount := Grid.RowCount + 1;
  end;
  Grid.RowCount := Grid.RowCount - 1;
end;


procedure writeSectList(Grid:TStringGrid; const head:PSectorList; ShopAdr:  PShopList);
var
  temp:PSectorList;
begin
  Grid.ColCount := 6;
  Grid.RowCount := 2;
  Grid.Cells[0,0] := 'ID';
  Grid.Cells[1,0] := 'Name';
  Grid.Cells[2,0] := 'Shop Name';
  Grid.Cells[3,0] := 'Zav';
  Grid.Cells[4,0] := 'Tel. number';
  Grid.Cells[5,0] := 'Delete';
  //ShowMessage('kek');
  temp := head^.adr;
  while temp <> nil do
  begin
    Grid.Cells[0,Grid.RowCount - 1] := IntToStr(temp^.Inf.id);
    Grid.Cells[1,Grid.RowCount - 1] := temp^.Inf.name;
    Grid.Cells[2,Grid.RowCount - 1] := getShopName(ShopAdr,temp^.Inf.shopid);
    Grid.Cells[3,Grid.RowCount - 1] := temp^.Inf.zav;
    Grid.Cells[4,Grid.RowCount - 1] := temp^.Inf.tel;
    Grid.Cells[5,Grid.RowCount - 1] := '-';
    temp:=temp^.adr;
    Grid.RowCount := Grid.RowCount + 1;
  end;
  Grid.RowCount := Grid.RowCount - 1;
end;


procedure writeProdList(Grid:TStringGrid; const head:PProductList; ShopHead:PShopList; SectHead: PSectorList);
var
  temp:PProductList;
begin
  Grid.ColCount := 8;
  Grid.RowCount := 2;
  Grid.Cells[0,0] := 'Vendor';
  Grid.Cells[1,0] := 'Name';
  Grid.Cells[2,0] := 'Shop Name';
  Grid.Cells[3,0] := 'Sector Name';
  Grid.Cells[4,0] := 'Date';
  Grid.Cells[5,0] := 'Count';
  Grid.Cells[6,0] := 'Currency';
  Grid.Cells[7,0] := 'Delete';
  //ShowMessage('kek');
  temp := head^.adr;
  while temp <> nil do
  begin
    Grid.Cells[0,Grid.RowCount - 1] := temp^.Inf.VendorCode;
    Grid.Cells[1,Grid.RowCount - 1] := temp^.Inf.Name;
    Grid.Cells[2,Grid.RowCount - 1] := getShopName(ShopHead, temp^.Inf.shopid);
    Grid.Cells[3,Grid.RowCount - 1] := getSectName(SectHead, temp^.Inf.sectid);
    Grid.Cells[4,Grid.RowCount - 1] := DateToStr( temp^.Inf.Date );
    Grid.Cells[5,Grid.RowCount - 1] := IntToStr(temp^.Inf.Count);
    Grid.Cells[6,Grid.RowCount - 1] := CurrToStr(temp^.Inf.Price);
    Grid.Cells[7,Grid.RowCount - 1] := '-';
    temp:=temp^.adr;
    Grid.RowCount := Grid.RowCount + 1;
  end;
  Grid.RowCount := Grid.RowCount - 1;
end;

function ShopIDsort (r1, r2: TProductInfo): Boolean;
begin
   Result:= r1.shopid > r2.shopid;
end;

function SectIDsort (r1, r2: TProductInfo): Boolean;
begin
   Result:= r1.sectid > r2.sectid;
end;

function ArtIDsort (r1, r2: TProductInfo): Boolean;
begin
   Result:= r1.VendorCode > r2.VendorCode;
end;

procedure sortProdList(const head:PProductList; kek: TSortMode);
var
  i:integer;
  temp: PProductList;
  temp2: PProductList;
  t1:PProductList;
begin
  temp := head;
  while temp.adr <> nil do
  begin
    temp2 := temp.adr;
    while temp2.adr <> nil do
    begin
      if (kek(temp2^.Adr^.inf, temp^.Adr^.inf)) then
      //
      begin

        t1 := temp2^.adr;
        temp2^.adr := temp^.adr;
        temp^.adr := t1;

        t1 := temp^.adr^.adr;
        temp^.adr^.adr := temp2^.adr.adr;
        temp2^.adr^.adr := t1;

        temp2 := temp;
      end;
      temp2 := temp2^.adr;
    end;
    temp := temp^.adr;
  end;
end;


function isShopIDFound(head: PShopList; id: integer):boolean;
var
  tmp: PShopList;
begin
  tmp:= head;
  while tmp <> nil do
  begin
    if tmp^.Inf.id = id then
    begin
      Result:= true;
      exit;
    end;

    tmp:= tmp^.Adr;
  end;
  result:= false;
end;

function isSectIDFound(head: PSectorList; id: integer):boolean;
var
  tmp: PSectorList;
begin
  tmp:= head;
  while tmp <> nil do
  begin
    if tmp^.Inf.id = id then
    begin
      Result:= true;
      exit;
    end;

    tmp:= tmp^.Adr;
  end;
  result:= false;
end;

function isProdIDFound(head: PProductList; id: string):boolean;
var
  tmp: PProductList;
begin
  tmp:= head;
  while tmp <> nil do
  begin
    if tmp^.Inf.VendorCode = id then
    begin
      Result:= true;
      exit;
    end;

    tmp:= tmp^.Adr;
  end;
  result:= false;
end;

procedure saveShopList(head:PShopList);
var
  f: textfile;
  temp: PShopList;
begin
  AssignFile(f, 'shops.brakh');
  rewrite(f);
  temp := head^.adr;
  while temp <> nil do
  begin
    writeln(f, temp^.Inf.id);
    writeln(f, temp^.Inf.name);
    writeln(f, temp^.Inf.adress);
    writeln(f, temp^.Inf.tel);
    //write(f, temp^.Inf);
    temp:=temp^.adr;
  end;
  close(F);
end;

procedure saveSectList(head:PSectorList);
var
  f: file of TSectorInfo;
  temp: PSectorList;
begin
  AssignFile(f, 'sect.brakh');
  rewrite(f);
  temp := head^.adr;
  while temp <> nil do
  begin
    write(f, temp^.Inf);
    temp:=temp^.adr;
  end;
  close(F);
end;

procedure saveProdList(head:PProductList);
var
  f: file of TProductInfo;
  temp: PProductList;
begin
  AssignFile(f, 'prod.brakh');
  rewrite(f);
  temp := head^.adr;
  while temp <> nil do
  begin
    write(f, temp^.Inf);
    temp:=temp^.adr;
  end;
  close(F);
end;

function readShopFile(const head:PShopList):integer;
var
  f: textfile;
  OTemp: PShopList;
  filename: string;
begin
  Result := 1;
  filename := 'shops.brakh';
  AssignFile(f, filename);
  if fileExists(Filename) then
  begin
    Reset(f);
    OTemp := Head;
    head^.Adr := nil;
    while not EOF(f) do
    begin
      new(OTemp^.adr);
      OTemp:=OTemp^.adr;
      OTemp^.adr:=nil;

      readln(f, Otemp^.Inf.id);
      readln(f, Otemp^.Inf.name);
      readln(f, Otemp^.Inf.adress);
      readln(f, Otemp^.Inf.tel);
      result := OTemp^.Inf.id;
    end;
    close(f);
  end
  else
  begin
    Rewrite(f);
    close(f);
  end;

end;


function readSectFile(const head:PSectorList):integer;
var
  f: file of TSectorInfo;
  OTemp: PSectorList;
  filename: string;
begin
  Result := 1;
  filename := 'sect.brakh';
  AssignFile(f, filename);
  if fileExists(Filename) then
  begin
    Reset(f);
    OTemp := Head;
    head^.Adr := nil;
    while not EOF(f) do
    begin
      new(OTemp^.adr);
      OTemp:=OTemp^.adr;
      OTemp^.adr:=nil;

      read(f, OTemp^.Inf);
      result := OTemp^.Inf.id;
    end;
    close(f);
  end
  else
  begin
    Rewrite(f);
    close(f);
  end;

end;

procedure readProdFile(const head:PProductList);
var
  f: file of TProductInfo;
  OTemp: PProductList;
  filename: string;
begin
  filename := 'prod.brakh';
  AssignFile(f, filename);
  if fileExists(Filename) then
  begin
    Reset(f);
    OTemp := Head;
    head^.Adr := nil;
    while not EOF(f) do
    begin
      new(OTemp^.adr);
      OTemp:=OTemp^.adr;
      OTemp^.adr:=nil;

      read(f, OTemp^.Inf);

    end;
    close(f);
  end
  else
  begin
    Rewrite(f);
    close(f);
  end;

end;

function GetProdCount:Integer;
var flag:Boolean;
var prodlistkek:TProductInfo;
begin
      repeat
        flag:=True;
        try
        Result:=StrToInt(InputBox('Введите количество товара','количество','2'));
        except
           on E:Exception do
           begin
           ShowMessage('Wrong input');
           flag:=false;
           end;

        end;
      until (flag);
end;
function  GetProdPrice:Currency;
var flag:Boolean;
begin
      repeat
        flag:=True;
        try
        Result:=StrToCurr(InputBox('введите цену за ед','цена','22,8'));
        except
           on E:Exception do
           begin
           ShowMessage('Wrong input');
           flag:=false;
           end;

        end;
      until (flag);
end;
function GetProdShopID(const shophead:PShopList):Integer;
var flag:Boolean;
begin
      repeat
        flag:=True;
        try
        Result:=StrToInt(InputBox('Введите id магазина','ID:','1'));
        except
           on E:Exception do
           begin
           ShowMessage('Wrong input');
           flag:=false;
           end;

        end;
        if not(isShopIDFound(shophead,Result)) then
        begin
        flag:=false;
        ShowMessage('Нет такого магазина');
        end;
       until (flag);
end;
function GetProdDate:TDate;
var flag:Boolean;
begin
      repeat
        flag:=True;
        try
        Result:=StrToDate(InputBox('введите Дату','Дата',DateToStr(GetTime)));
        except
           on E:Exception do
           begin
           ShowMessage('Wrong input');
           flag:=false;
           end;

        end;
      until (flag);
end;
function GetProdsectID(const sectorhead:PSectorList):Integer;
var flag:Boolean;
begin
       repeat
        flag:=True;
        try
        Result:=StrToInt(InputBox('Введите номер сектора','номер:','1'));
        except
           on E:Exception do
           begin
           ShowMessage('Wrong input');
           flag:=false;
           end;

        end;
        if not(isSectIDFound(sectorhead,Result)) then
        begin
        flag:=false;
        ShowMessage('Нет такой секции');
        end;

      until (flag);
end;
function GetProdVendor(const producthead:PProductList):string;
var flag:Boolean;
begin
        repeat
        flag:=True;
       Result:=InputBox('Введите артикул товара','артикул:','1');
       if isProdIDFound(producthead,Result) then
       begin
       ShowMessage('Артикул занят');
       flag:=False;
       end;
      until flag;
end;
end.


