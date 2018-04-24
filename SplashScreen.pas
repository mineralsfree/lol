unit SplashScreen;

interface

uses Windows, PNGImage, Forms, Graphics;

type
  TSplashForm = TForm;

  TSplash = class
  private
    FImage: TPNGImage;
    SplashForm: TSplashForm;
    procedure SetImage(value: TPNGImage);
    procedure ToLayeredWindow;
  public
    constructor Create; overload;
    constructor Create(Image: TPNGImage); overload;
    destructor Destroy;
    procedure Show(StayOnTop: Boolean);
    procedure Close;
    property Image: TPNGImage read FImage write SetImage;
  end;

implementation

procedure CreatePremultipliedBitmap(DstBitMap: TBitmap; SrcPngImage: TPNGImage);
type
  TRGBTripleArray = ARRAY[Word] of TRGBTriple;
  pRGBTripleArray = ^TRGBTripleArray;
  TRGBAArray = array[Word] of TRGBQuad;
  PRGBAArray = ^TRGBAArray;
var
  x, y: Integer;
  TripleAlpha: Double;
  pColor: pRGBTripleArray;
  pAlpha: pbytearray;
  pBmp: pRGBAArray;
begin
  DstBitMap.Height := SrcPngImage.Height;
  DstBitMap.Width := SrcPngImage.Width;
  DstBitMap.PixelFormat := pf32bit;
  for y := 0 to SrcPngImage.Height - 1 do
  begin
    pAlpha := SrcPngImage.AlphaScanline[y];
    pColor := SrcPngImage.Scanline[y];
    pBmp := DstBitMap.ScanLine[y];
    for x := 0 to SrcPngImage.Width - 1 do
      begin
        pBmp[x].rgbReserved := pAlpha[x];
        // ïðåîáðàçóåì â íóæíûé ôîðìàò
        TripleAlpha := pBmp[x].rgbReserved / 255;
        pBmp[x].rgbBlue := byte(trunc(pColor[x].rgbtBlue * TripleAlpha));
        pBmp[x].rgbGreen := byte(trunc(pColor[x].rgbtGreen * TripleAlpha));
        pBmp[x].rgbRed := byte(trunc(pColor[x].rgbtRed * TripleAlpha));
      end;
  end;
end;

constructor TSplash.Create;
begin
  SplashForm := TSplashForm.Create(nil);
  FImage := TPNGImage.Create;
end;

constructor TSplash.Create(Image: TPNGImage);
begin
  SplashForm := TSplashForm.Create(nil);
  FImage := TPNGImage.Create;
  FImage.Assign(Image);
end;

destructor TSplash.Destroy;
begin
  SplashForm.Free;
  FImage.Free
end;

procedure TSplash.SetImage(value: TPNGImage);
begin
  FImage.Assign(value);
end;

procedure TSplash.ToLayeredWindow;
var
  BitMap: TBitMap;
  bf: TBlendFunction;
  BitmapSize: TSize;
  BitmapPos: TPoint;
begin
  // ñîçäàíèå ïðàâèëüíîé áèòîâîé êàðòû(32 áèò íà ïèêñåëü, precalc àëüôà êàíàë)
  BitMap := TBitMap.Create;
  CreatePremultipliedBitmap(Bitmap,FImage);
  // îïèñàíèå BlendFunction
  with bf do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    AlphaFormat := AC_SRC_ALPHA;
    SourceConstantAlpha := 255;
  end;
  // ïîëó÷àåì ðàçìåðû BitMap
  BitmapSize.cx := Bitmap.Width;
  BitmapSize.cy := Bitmap.Height;
  // ïîëó÷àåì êîîðäèíàòû BitMap
  BitmapPos.X := 0;
  BitmapPos.Y := 0;
  // ñëîèñòûé ñòèëü îêíà
  SetWindowLong(SplashForm.Handle, GWL_EXSTYLE,
    GetWindowLong(SplashForm.Handle, GWL_EXSTYLE) + WS_EX_LAYERED);
  // ïðåâðàùåíèå îêíà â ñëîèñòîå îêíî
  UpdateLayeredWindow(
    SplashForm.Handle,
    0,
    nil,//pos
    @BitmapSize,//size
    bitmap.Canvas.Handle,//src
    @BitmapPos,//pptsrc
    0,
    @bf,
    ULW_ALPHA
  );
  BitMap.Free;
end;

procedure TSplash.Show(StayOnTop: Boolean);
begin
  // óñòàíàâëèâàåì íóæíûå ïàðàìåòðû
  with SplashForm do
  begin
    BorderStyle := bsNone;
    Width := FImage.Width;
    Height := FImage.Height;
    Position := poDesktopCenter;
    if StayOnTop then formstyle := fsStayOnTop;
  end;
  // ïðåîáðàçóåì â "ñëîèñòîå" îêíî
  ToLayeredWindow;
  // ïîêàçûâàåì
  SplashForm.Show;
end;

procedure TSplash.Close;
begin
  SplashForm.Close;
end;

end.
