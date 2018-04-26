unit Vedom2;

interface
uses
  SysUtils, Vcl.Grids, Vcl.Dialogs,Spravochnik_1, DateUtils,Vcl.ColorGrd,FMX.Colors, Vcl.Graphics;
procedure formVedom1({cht1:Tchart;}Grid: TStringGrid; ProdHead:PProductList; ShopHead: PShopList; SectHead: PSectorList; id:integer);
implementation

procedure formVedom1({cht1:Tchart;}Grid: TStringGrid; ProdHead:PProductList; ShopHead: PShopList; SectHead: PSectorList; id:Integer);
var
  i,j: integer;
  currnum: integer;
  tmpProd: PProductList;
  tmpShop: PShopList;
  tmpSect: PSectorList;
  kek: Boolean;
  sectPrice: Currency;
  shopPrice: Currency;
  totalPrice: Currency;
begin
//cht1.Visible:=True;
  tmpProd:=ProdHead;
    for i := 0 to Grid.ColCount do
    for j := 0 to Grid.RowCount do
    Grid.Cells[i,j] := '';

  Grid.Cells[1,0] := 'Ведомость 2' ;
  Grid.ColCount := 5;
  Grid.RowCount := 3;
  Grid.Cells[0,1] := '№ п/п';
  Grid.Cells[1,1] := 'Shop id';
  Grid.Cells[2,1] := 'Sect';
  Grid.Cells[3,1] := 'tel num';
  Grid.Cells[4,1] := 'Profit';
  Grid.Cells[1,2] := IntToStr(id);


  currnum := 1;
  totalPrice := 0;

    tmpSect := SectHead^.Adr;
    shopPrice := 0;
    //cht1.Series[0].Clear;


    while tmpSect <> nil  do
    begin
      kek := false;
      sectPrice := 0;
      tmpProd := ProdHead.Adr;
      Grid.Cells[0,Grid.RowCount  - 1] := IntToStr(currnum);
      Grid.Cells[2,Grid.RowCount  - 1] := tmpSect^.Inf.name;
      Grid.Cells[3,Grid.RowCount  - 1] := ( tmpSect^.Inf.tel );

      while tmpProd <> nil do
      begin
        if (tmpProd.Inf.shopid = id) and (tmpProd.Inf.sectid = tmpSect.Inf.id) then
        begin
          sectPrice := sectPrice + (tmpProd^.Inf.Price)*(tmpProd^.Inf.Count);
          kek := true;
        end;
        tmpProd := tmpProd^.Adr;
      end;
      if kek then
      begin
      {cht1.series[0].Active:=true;
      cht1.SeriesList.Create;
      cht1.series[0].Add(sectPrice, IntToStr(currnum));

      cht1.Series[0].Repaint;  }

      Grid.Cells[4,Grid.RowCount-1] := CurrToStr(sectprice);
      Grid.RowCount := Grid.RowCount + 1;
      inc(currnum);
      shopPrice := shopPrice + sectPrice;
      end;
      tmpSect := tmpSect^.Adr;
    end;
    if shopPrice <> 0 then
    begin
      Grid.RowCount := Grid.RowCount + 1;
      for i := 0 to Grid.ColCount-1 do
        Grid.Cells[i,Grid.RowCount-2] := '';
      Grid.Cells[4,Grid.RowCount-2] := CurrToStr(shopPrice);
    end;
  {  totalPrice := totalPrice + shopPrice;

  Grid.Cells[3,Grid.RowCount-1] := 'Total ';
  Grid.Cells[4,Grid.RowCount-1] := CurrToStr(totalPrice);          }

  Grid.RowCount := Grid.RowCount -1;

end;


end.
