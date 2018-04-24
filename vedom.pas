unit vedom;

interface
uses
  SysUtils, Vcl.Grids, Vcl.Dialogs,Spravochnik_1, DateUtils;
procedure formVedom2(Grid: TStringGrid; ProdHead:PProductList; ShopHead: PShopList; SectHead: PSectorList);

implementation

procedure formVedom2(Grid: TStringGrid; ProdHead:PProductList; ShopHead: PShopList; SectHead: PSectorList);
var
  i: integer;
  currnum: integer;
  tmpProd: PProductList;
  tmpShop: PShopList;
  tmpSect: PSectorList;
  kek: Boolean;
  sectPrice: Currency;
  shopPrice: Currency;
  totalPrice: Currency;
begin

  Grid.ColCount := 9;
  Grid.RowCount := 3;
  for i := 0 to Grid.ColCount-1 do
    Grid.Cells[i,0] := '';

  Grid.Cells[4,0] := 'Date: ';
  Grid.Cells[5,0] :=  FormatDateTime('dd.mm.yyyy"-"hh:nn:ss', Now);
  Grid.Cells[0,1] := 'Num p/p';
  Grid.Cells[1,1] := 'Shop ID';
  Grid.Cells[2,1] := 'Shop Name';
  Grid.Cells[3,1] := 'Sect Name';
  Grid.Cells[4,1] := 'Sect ID';
  Grid.Cells[5,1] := 'Articul';
  Grid.Cells[6,1] := 'Name';
  Grid.Cells[7,1] := 'Count';
  Grid.Cells[8,1] := 'Price';

  currnum := 1;
  totalPrice := 0;
  tmpShop:= ShopHead^.Adr;
  while tmpShop <> nil do
  begin
    tmpSect := SectHead^.Adr;
    shopPrice := 0;
    while tmpSect <> nil do
    begin
      kek := false;
      sectPrice := 0;
      tmpProd := ProdHead.Adr;
      while tmpProd <> nil do
      begin
        if (tmpProd.Inf.shopid = tmpShop.Inf.id) and (tmpProd.Inf.sectid = tmpSect.Inf.id) then
        begin
          Grid.Cells[0,Grid.RowCount  - 1] := IntToStr(currnum);
          Grid.Cells[1,Grid.RowCount  - 1] := IntToStr(tmpShop^.Inf.id) + 'kek';
          Grid.Cells[2,Grid.RowCount  - 1] := tmpShop^.Inf.name;
          Grid.Cells[3,Grid.RowCount  - 1] := tmpSect^.Inf.name;
          Grid.Cells[4,Grid.RowCount  - 1] := IntToStr( tmpSect^.Inf.id );
          Grid.Cells[5,Grid.RowCount  - 1] := tmpProd^.Inf.VendorCode;
          Grid.Cells[6,Grid.RowCount  - 1] := tmpProd^.Inf.Name;
          Grid.Cells[7,Grid.RowCount  -1] := IntToStr( tmpProd^.Inf.Count );
          Grid.Cells[8,Grid.RowCount  - 1] := CurrToStr( (tmpProd^.Inf.Price)*(tmpProd^.Inf.Count) );
          sectPrice := sectPrice + (tmpProd^.Inf.Price)*(tmpProd^.Inf.Count);
          inc(currnum);
          Grid.RowCount := Grid.RowCount + 1;
        end;
        tmpProd := tmpProd^.Adr;
      end;
      tmpSect := tmpSect^.Adr;
      if kek then
      begin
        Grid.RowCount := Grid.RowCount + 1;
        for i := 0 to Grid.ColCount-1 do
          Grid.Cells[i,Grid.RowCount-2] := '';
        Grid.Cells[4,Grid.RowCount-2] := 'At sector ';
        Grid.Cells[5,Grid.RowCount-2] := CurrToStr(sectPrice);
      end;
      shopPrice := shopPrice + sectPrice;
    end;
    if shopPrice <> 0 then
    begin
      Grid.RowCount := Grid.RowCount + 1;
      for i := 0 to Grid.ColCount-1 do
        Grid.Cells[i,Grid.RowCount-2] := '';
      Grid.Cells[4,Grid.RowCount-2] := 'At shop ';
      Grid.Cells[5,Grid.RowCount-2] := CurrToStr(shopPrice);
    end;
    totalPrice := totalPrice + shopPrice;
    tmpShop := tmpShop^.Adr;
  end;
  Grid.Cells[4,Grid.RowCount-1] := 'Total ';
  Grid.Cells[5,Grid.RowCount-1] := CurrToStr(totalPrice);
end;

end.
