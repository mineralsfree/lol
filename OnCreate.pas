unit OnCreate;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls,  Vcl.Forms,pngimage, Vcl.Dialogs, Vcl.ExtCtrls, SplashScreen, Vcl.StdCtrls, ComObj,  Vcl.Grids,
  Vcl.Menus, Spravochnik_1,vedom,Vedom2, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart;

type
   Tmode = (spr1, spr2, ved1, ved2, main);
  MainList = record
    StoreNum: Integer;
    SectionNum:Integer;
    Date: TDateTime;
    VendorCode: string[10];
    ProdName: string[15];
    ProdCount: Integer;
    ProdPrice: Integer;


  end;
  TForm1 = class(TForm)

    strngrd1: TStringGrid;
    imgSplashIMG: TImage;
    mm1: TMainMenu;
    N11: TMenuItem;
    N1: TMenuItem;
    btn1: TButton;
    N21: TMenuItem;
    Save1: TMenuItem;
    N12: TMenuItem;
    btn2: TButton;
    cht1: TChart;
    psrsSeries1: TPieSeries;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure strngrd1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N11Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    //function GetProdCount:Integer;
      private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  introIMG: TImage;
  var Splash:Tsplash;
  mode:Tmode;
  sectorhead:PSectorList;
  shophead:PShopList;
  producthead:PProductList;
  kek:Integer;
  HehID:Integer;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var shoplistkek:TShopInfo;
var prodlistkek:TProductInfo;
var flag:Boolean;
begin

case mode of
  spr1:
    begin
          inc(kek);
         shoplistkek.id:=kek;
         shoplistkek.name:=InputBox('','','Магазин_'+IntToStr(kek));
         shoplistkek.adress:=InputBox('','','платонова');
         shoplistkek.tel:=InputBox('','','+37529235232');
         insertShopList(shophead,shoplistkek);
         writeShopList(strngrd1,shophead);
    end;
  main:
    begin
      if (shophead.Adr<>nil)  and (sectorhead.Adr<>nil) then
      begin
      prodlistkek.shopid:=GetProdShopID(shophead);
      prodlistkek.sectid:=GetProdsectID(sectorhead);
      prodlistkek.Date:=GetProdDate;
      prodlistkek.VendorCode:=GetProdVendor(producthead);
      prodlistkek.Name:=InputBox('Введите название товара','товар','майка');
      prodlistkek.Count:=GetProdCount;
      prodlistkek.Price:=GetProdPrice;
      insertProdList(producthead,prodlistkek);
      writeProdList(strngrd1,producthead,shophead,sectorhead);
      end;
    end;
end;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
case mode of
  spr1:
  begin

  end;
  spr2:
  begin
  //sortsect
  end;
  main:
  begin
  sortProdList(producthead,top12);
  writeProdList(strngrd1,producthead,shophead,sectorhead);
  cht1.Visible:=False;
  end;

end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
png: TPngImage;
begin

png:= TPngImage(imgSplashIMG.Picture);
  Splash := TSplash.Create(png);
  Splash.Show(true);
  Sleep(2000);
  Splash.Close;
  createProdHead(producthead);
  createSectHead(sectorhead);
  createShopHead(shophead);
  mode:=main;
 kek:=readShopFile(shophead);
 HehID:=readSectFile(sectorhead);
  readProdFile(producthead);
  writeProdList(strngrd1,producthead,shophead,sectorhead);
  cht1.Visible:=False;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
 mode:=spr1;
 writeshopList(strngrd1,shophead);
 btn1.Visible:=true;
 cht1.Visible:=False;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
formVedom2(strngrd1,producthead,shophead,sectorhead);
cht1.Visible:=False;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
mode:=main;
writeProdList(strngrd1,producthead,shophead,sectorhead);
cht1.Visible:=False;
btn1.Visible:=true;
end;

procedure TForm1.N21Click(Sender: TObject);
begin
 mode:=spr2;
 writeSectList(strngrd1,sectorhead,shophead);
 cht1.Visible:=False;
 btn1.Visible:=False;
end;

procedure TForm1.N22Click(Sender: TObject);
begin
//formVedom1(strngrd1,producthead,shophead,sectorhead);
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
case mode of
  spr1: begin
         saveShopList(shophead);
        ShowMessage('shoplist saved');
        end;
        spr2:
        begin
          saveSectList(sectorhead);
          ShowMessage('sectorlist saved');
        end;
  main:
    begin
     saveProdList(producthead);
     ShowMessage('productlist saved');
    end;
end;
end;

procedure TForm1.strngrd1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
   var shopNum,sectnum,id,i,Acol,Arow:Integer;
   var sectlistkek:TSectorInfo;
   var shoplistkek:TShopInfo;
   var prodlistkek:TProductInfo;
   var id2:string;
   var flag:Boolean;
begin
  strngrd1.MouseToCell(X,Y,Acol,Arow);
  flag:=False;
  if Arow<>0 then
  begin
    case mode of
     spr1:       //SHOPLIST
      begin
      id:=StrToInt(strngrd1.Cells[0,Arow]);
      shoplistkek.id:=id;
        case Acol of
          0:Exit;
          1:
            begin                //red name
             shoplistkek.name:=InputBox('Введите название магазина','Название:','kek');
             shoplistkek.adress:=strngrd1.Cells[2,Arow];
             shoplistkek.tel:=strngrd1.Cells[3,Arow];
            end;
          2:
            begin                    //red adres
              shoplistkek.name:=strngrd1.Cells[1,Arow];
              shoplistkek.adress:=InputBox('Введите адрес','Адрес:','Гикало, 4');
              shoplistkek.tel:=strngrd1.Cells[3,Arow];
            end;
          3:
            begin                       //red telefon
              shoplistkek.name:=strngrd1.Cells[1,Arow];
              shoplistkek.adress:=strngrd1.Cells[2,Arow];
              shoplistkek.tel:=InputBox('Введите номер телефона','номер:','+375296836944');
            end;
          4:
            begin
            Inc(hehid);
             sectlistkek.id:=HehID;
             sectlistkek.shopid:=StrToInt(strngrd1.Cells[0,Arow]);
             sectlistkek.name:=InputBox('Введите имя секора','имя:','Молочные продукты');
             sectlistkek.zav:=InputBox('Заведующий сектором','имя','Вася');
             sectlistkek.tel:=InputBox('Телефон','номер:','+37529235232');
             insertSectList(sectorhead,sectlistkek);

             Exit;
            end;
          5:
            begin
             deleteShopList(shophead,sectorhead,producthead,id);
             writeshopList(strngrd1,shophead);
             exit
            end;
          6:
            begin
             formVedom1(cht1,strngrd1,producthead,shophead,sectorhead,id);
             mode:=ved1;
             exit;
             end;
        end;
        editShopList(shophead,id,shoplistkek);
        writeshopList(strngrd1,shophead);
      end;
      spr2:
      begin
      id:=StrToInt(strngrd1.Cells[0,Arow]);
        case Acol of
          0:Exit;
          1:
            begin
             sectlistkek.name:=inputbox('Введите имя','имя секции:','Мясная секция');
             sectlistkek.zav:=strngrd1.Cells[3,Arow];
             sectlistkek.tel:=strngrd1.Cells[4,Arow];
            end;
          2: Exit;
          3:
            begin
             sectlistkek.name:=strngrd1.Cells[1,Arow];
             sectlistkek.zav:=InputBox('Заведующий сектором','имя','Петя');
             sectlistkek.tel:=strngrd1.Cells[4,Arow];
            end;
          4:
            begin
             sectlistkek.name:=strngrd1.Cells[1,Arow];
             sectlistkek.zav:=strngrd1.Cells[3,Arow];
             sectlistkek.tel:=inputbox('Введите телефон','номер:','+37529235232');
            end;
          5:
            begin
              deleteSectList(sectorhead,producthead,ID);
              writeSectList(strngrd1,sectorhead,shophead);
              Exit;
            end;
        end;
        sectlistkek.shopid:=getShopID(shophead,strngrd1.Cells[2,Arow]);
        editSectList(sectorhead,ID,sectlistkek);
        writeSectList(strngrd1,sectorhead,shophead);
      end;
      main:
        begin
          id2:=strngrd1.Cells[0,Arow];
          case Acol of
          0..3: Exit;
          4:
            begin
             prodlistkek.Date:=GetProdDate;
             prodlistkek.Name:=strngrd1.Cells[1,Arow];
             prodlistkek.Count:=StrToInt(strngrd1.Cells[5,Arow]);
             prodlistkek.Price:=StrToCurr(strngrd1.Cells[6,Arow]);
            end;
          5:
            begin
             prodlistkek.Date:=StrToDate(strngrd1.Cells[4,Arow]);
             prodlistkek.Name:=strngrd1.Cells[1,Arow];
             prodlistkek.Count:=GetProdCount;
             prodlistkek.Price:=StrToCurr(strngrd1.Cells[6,Arow]);
            end;
          6:
           begin
             prodlistkek.Date:=StrToDate(strngrd1.Cells[4,Arow]);
             prodlistkek.Name:=strngrd1.Cells[1,Arow];
             prodlistkek.Count:=StrToInt(strngrd1.Cells[5,Arow]);
             prodlistkek.Price:=GetProdPrice;
            end;
          7:
            begin
            deleteProdList(producthead,id2);
            Exit;
            end;
          end;
          prodlistkek.shopid:=getShopID(shophead,strngrd1.Cells[2,Arow]);
          prodlistkek.sectid:=getSectID(sectorhead,strngrd1.Cells[3,Arow]);
          prodlistkek.VendorCode:=id2;
          editProdList(producthead,id2,prodlistkek);
           writeProdList(strngrd1,producthead,shophead,sectorhead);
        end;
    end;
  end
  {else
  case Acol of
    0:
    begin
    sortProdList(producthead,ArtIDsort);
    writeProdList(strngrd1,producthead,shophead,sectorhead);
    end;
    2:
    begin
    sortProdList(producthead,ShopIDsort);
    end;
    3:
    begin
    sortProdList(producthead,SectIDsort);
    end;
  end;  }
end;
end.
