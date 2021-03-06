unit Unit1;

interface

uses
  Registry,Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, System.JSON,
  Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,DateUtils,IdHTTP, IdMultipartFormData,
  IdSSL, IdSSLOpenSSL, clipbrd, Unit2,Unit3,ShellAPI;

type
  TForm9 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Image1: TImage;
    Memo1: TMemo;
    TabSheet3: TTabSheet;
    ScrollBox2: TScrollBox;
    Panel2: TPanel;
    Image18: TImage;
    TabSheet4: TTabSheet;
    ScrollBox3: TScrollBox;
    Panel3: TPanel;
    Image19: TImage;
    Label1: TLabel;
    Image9: TImage;
    TabSheet5: TTabSheet;
    Panel4: TPanel;
    Panel5: TPanel;
    Edit24: TEdit;
    Label2: TLabel;
    Edit25: TEdit;
    Label3: TLabel;
    Panel6: TPanel;
    ScrollBox4: TScrollBox;
    Panel7: TPanel;
    Image2: TImage;
    ListBox1: TListBox;
    Edit1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Image3: TImage;
    Label6: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    ListBox2: TListBox;
    Telegram: TImage;
    Viber: TImage;
    Skype: TImage;
    WhatsApp: TImage;
    Discord: TImage;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Kvirc: TImage;
    Label14: TLabel;
    Label15: TLabel;
    Panel8: TPanel;
    Image4: TImage;
    Image5: TImage;
    ReclamaURL: TEdit;

    procedure HandleImgokClick(Sender: TObject);
    procedure HandleImgdelClick(Sender: TObject);
    procedure HandleImgmessengerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure InsertPanel(country:string; domain:string; dtime:string;intervaldays:string;contact:string;messenger:string);
    procedure HandleDomainClick(Sender: TObject);
    procedure SaveConfigToRegistry();
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure SortScrollBox1();
    procedure Image5Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet1Hide(Sender: TObject);
    procedure StatsUpdate();
    procedure DownloadPNG(url:string;im:TImage);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;
  Queue: Integer = 0;
  FocusObject : TWinControl;

implementation

{$R *.dfm}
procedure Proc(hWnd: HWND; uMsg: UINT; idEvent: UINT_PTR; dwTime: DWORD); stdcall;
var
i:integer;
FmtStngs: TFormatSettings;
dtimedelta:integer;
intervaldays,lastvisitdtime:string;
begin
    GetLocaleFormatSettings( GetThreadLocale, FmtStngs );
    FmtStngs.DateSeparator := '-';
    FmtStngs.ShortDateFormat := 'yyyy-mm-dd';
    FmtStngs.TimeSeparator := ':';
    FmtStngs.LongTimeFormat := 'hh:nn:ss';

   // Form9.ProgressBar1.Position := Form9.ProgressBar1.Position +10;

  for i := 0 to Form9.ScrollBox1.ComponentCount-1 do
  begin
    intervaldays := (((Form9.ScrollBox1.Components[i] as TPanel).Components[4] as TComboBox).Text);
    lastvisitdtime := (((Form9.ScrollBox1.Components[i] as TPanel).Components[6] as TEdit).Text);
//    dtimedelta := MinutesBetween(Now,IncMilliSecond(IncMinute(StrToDateTime(lastvisitdtime,FmtStngs),intervaldays.ToInt64*24*60)));
    dtimedelta := MinutesBetween(Now,IncMilliSecond(StrToDateTime(lastvisitdtime,FmtStngs)));

    if (dtimedelta >= (intervaldays.ToInteger*24*60)) OR (dtimedelta <=0) then
    begin
       ((Form9.ScrollBox1.Components[i] as TPanel).Components[5] as TProgressBar).Position := 100;
       ((Form9.ScrollBox1.Components[i] as TPanel).Components[5] as TProgressBar).State := pbsError;
    end
    else
    begin
       ((Form9.ScrollBox1.Components[i] as TPanel).Components[5] as TProgressBar).State := pbsNormal;
       ((Form9.ScrollBox1.Components[i] as TPanel).Components[5] as TProgressBar).Position := round(100/((intervaldays.ToInteger*24*60)/dtimedelta));
    end;
  end;

  Form9.StatsUpdate();

end;
procedure TForm9.SortScrollBox1();
var
fields,fields2,psfields1,sfields1: TJSONArray;
psfields2,sfields2: TJSONArray;
psfields3,sfields3: TJSONArray;
i,i0,i1,tmp1,tmp2,tmp3:integer;
tmp:string;
begin
  fields2 := TJSONArray.Create;
  for i := 0 to Form9.ScrollBox1.ComponentCount-1 do
  begin
    fields := TJSONArray.Create;
    fields.Add(((Form9.ScrollBox1.Components[i] as TPanel).Components[0] as TEdit).Text);//country
    fields.Add(((Form9.ScrollBox1.Components[i] as TPanel).Components[1] as TEdit).Text);//domain
    fields.Add(((Form9.ScrollBox1.Components[i] as TPanel).Components[6] as TEdit).Text);//lastvisitdtime
    fields.Add(((Form9.ScrollBox1.Components[i] as TPanel).Components[4] as TComboBox).Text);//intervaldays
    fields.Add(((Form9.ScrollBox1.Components[i] as TPanel).Components[8] as TEdit).Text);//contact
    fields.Add(((Form9.ScrollBox1.Components[i] as TPanel).Components[9] as TEdit).Text);//messenger
    fields2.Add(fields);
  end;
  sfields1 := TJSONArray.Create;
  while fields2.Count <>0 do
  begin
     tmp1 := 0;i1 := 0;
     for i := 0 to fields2.Count -1 do
     begin
        tmp := UpperCase(fields2.Items[i].GetValue<TJSONArray>().Items[0].GetValue<String>());
        if (Ord(tmp[1])>=tmp1) then
        begin
                tmp1 := Ord(tmp[1]);
                i1 := i;
        end;
     end;
    psfields1 := TJSONArray.Create;
    psfields1.Add(fields2.Items[i1].GetValue<TJSONArray>().Items[0].GetValue<String>());
    psfields1.Add(fields2.Items[i1].GetValue<TJSONArray>().Items[1].GetValue<String>());
    psfields1.Add(fields2.Items[i1].GetValue<TJSONArray>().Items[2].GetValue<String>());
    psfields1.Add(fields2.Items[i1].GetValue<TJSONArray>().Items[3].GetValue<String>());
    psfields1.Add(fields2.Items[i1].GetValue<TJSONArray>().Items[4].GetValue<String>());
    psfields1.Add(fields2.Items[i1].GetValue<TJSONArray>().Items[5].GetValue<String>());
    sfields1.Add(psfields1);
    fields2.Remove(i1);
  end;
  sfields2 := TJSONArray.Create;
  while sfields1.Count <>0 do
  begin
     tmp1 := 0;tmp2 := 0;i1 := 0;
     for i := 0 to sfields1.Count -1 do
     begin
        tmp := UpperCase(sfields1.Items[i].GetValue<TJSONArray>().Items[0].GetValue<String>());
        if (Ord(tmp[1])>=tmp1) AND (Ord(tmp[2])>=tmp2) then
        begin
                tmp1 := Ord(tmp[1]);
                tmp2 := Ord(tmp[2]);
                i1 := i;
        end;
     end;
    psfields2 := TJSONArray.Create;
    psfields2.Add(sfields1.Items[i1].GetValue<TJSONArray>().Items[0].GetValue<String>());
    psfields2.Add(sfields1.Items[i1].GetValue<TJSONArray>().Items[1].GetValue<String>());
    psfields2.Add(sfields1.Items[i1].GetValue<TJSONArray>().Items[2].GetValue<String>());
    psfields2.Add(sfields1.Items[i1].GetValue<TJSONArray>().Items[3].GetValue<String>());
    psfields2.Add(sfields1.Items[i1].GetValue<TJSONArray>().Items[4].GetValue<String>());
    psfields2.Add(sfields1.Items[i1].GetValue<TJSONArray>().Items[5].GetValue<String>());
    sfields2.Add(psfields2);
    sfields1.Remove(i1);
  end;
  sfields3 := TJSONArray.Create;
  while sfields2.Count <>0 do
  begin
     tmp1 := 0;tmp2 := 0;tmp3 := 0;i1 := 0;
     for i := 0 to sfields2.Count -1 do
     begin
        tmp := UpperCase(sfields2.Items[i].GetValue<TJSONArray>().Items[0].GetValue<String>());
        if (Ord(tmp[1])>=tmp1) AND (Ord(tmp[2])>=tmp2) AND (Ord(tmp[3])>tmp3) then
        begin
                tmp1 := Ord(tmp[1]);
                tmp2 := Ord(tmp[2]);
                tmp3 := Ord(tmp[3]);
                i1 := i;
        end;
     end;
    psfields3 := TJSONArray.Create;
    psfields3.Add(sfields2.Items[i1].GetValue<TJSONArray>().Items[0].GetValue<String>());
    psfields3.Add(sfields2.Items[i1].GetValue<TJSONArray>().Items[1].GetValue<String>());
    psfields3.Add(sfields2.Items[i1].GetValue<TJSONArray>().Items[2].GetValue<String>());
    psfields3.Add(sfields2.Items[i1].GetValue<TJSONArray>().Items[3].GetValue<String>());
    psfields3.Add(sfields2.Items[i1].GetValue<TJSONArray>().Items[4].GetValue<String>());
    psfields3.Add(sfields2.Items[i1].GetValue<TJSONArray>().Items[5].GetValue<String>());
    sfields3.Add(psfields3);
    sfields2.Remove(i1);
  end;

  Form9.ScrollBox1.DestroyComponents;
  for i := 0 to sfields3.Count-1 do
  begin
    Form9.InsertPanel(
      sfields3.Items[i].GetValue<TJSONArray>().Items[0].GetValue<String>(),
      sfields3.Items[i].GetValue<TJSONArray>().Items[1].GetValue<String>(),
      sfields3.Items[i].GetValue<TJSONArray>().Items[2].GetValue<String>(),
      sfields3.Items[i].GetValue<TJSONArray>().Items[3].GetValue<String>(),
      sfields3.Items[i].GetValue<TJSONArray>().Items[4].GetValue<String>(),
      sfields3.Items[i].GetValue<TJSONArray>().Items[5].GetValue<String>()
    );
//    Form9.Memo2.Lines.Add(sfields1.Items[i].GetValue<TJSONArray>().Items[0].GetValue<String>());
  end;
  sfields1.Free;
  sfields2.Free;
  sfields3.Free;
  fields2.Free;
end;
procedure TForm9.TabSheet1Hide(Sender: TObject);
begin
//FocusObject:= Screen.ActiveControl;
end;

procedure TForm9.TabSheet1Show(Sender: TObject);
begin
//FocusObject.SetFocus;
end;

procedure TForm9.Button1Click(Sender: TObject);
var
i:integer;
begin
SendMessage(ScrollBox1.Handle, WM_SETREDRAW, 0, 0);
try
i:=ListBox1.ItemIndex;if i=-1 then i:=179;
Form9.InsertPanel(ListBox1.Items[i],Edit1.Text,'2020-01-01 00:00:00',ComboBox1.Text,Edit2.Text,ListBox2.Items[ListBox2.ItemIndex] );
SortScrollBox1;
 {&#133}
finally
 SendMessage(ScrollBox1.Handle, WM_SETREDRAW, 1, 0);
 RedrawWindow(ScrollBox1.Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
end;
//   Edit1.Text:= ListBox1.ItemIndex.ToString;

end;

procedure TForm9.Button2Click(Sender: TObject);
var
 Reg:TRegistry;
 fields,fields2: TJSONArray;
 i:integer;

 Buffer: String;
 HTTP: TIdHTTP;
 data: TIdMultiPartFormDataStream;
 SSL:TIdSSLIOHandlerSocketOpenSSL;

 JSonValue,ArrayElement: TJSonValue;
 JsonArray: TJSONArray;

 FmtStngs: TFormatSettings;
 dtimecurrent:TDateTime;
 dtime:String;
begin
  fields2 := TJSONArray.Create;

  for i := 0 to ScrollBox1.ComponentCount-1 do
  begin
  fields := TJSONArray.Create;
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[0] as TEdit).Text);//country
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[1] as TEdit).Text);//domain
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[4] as TComboBox).Text);//intervaldays
  fields2.Add(fields);
//  fields.Free;
  end;

     Reg := TRegistry.Create;
     Reg.LazyWrite := false;
     Reg.RootKey := HKEY_CURRENT_USER;
     Reg.OpenKey('\SOFTWARE\PHPAssistent', true);

  data := TIdMultiPartFormDataStream.Create;
  data.AddFormField('userid', Reg.ReadString('id'));
     Reg.CloseKey;
     Reg.Free;
  data.AddFormField('config', UTF8Encode(fields2.ToString), 'utf-8').ContentTransfer := '8bit';
  fields := TJSONArray.Create;
  fields.Add(ListBox2.Items[ListBox2.ItemIndex]);
  fields.Add(Edit2.Text);
  data.AddFormField('contact', UTF8Encode(fields.ToString), 'utf-8').ContentTransfer := '8bit';

//  SSL:=TIdSSLIOHandlerSocketOpenSSL.Create(Application);
//  SSL.ReadTimeOut:=10000;
//  ///sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1,sslvTLSv1.sslvTLSv1_1,sslvTLSv1_2
//  SSL.SSLOptions.Method:=sslvSSLv23;
//  SSL.SSLOptions.Mode:=sslmUnassigned;
  HTTP := TIdHTTP.Create;
  HTTP.ReadTimeout:=10000;
  HTTP.ConnectTimeout:=10000;
 // HTTP.IOHandler:=SSL;
  HTTP.AllowCookies:=true;
  try
    Buffer := HTTP.Post('http://php.xp3.biz/refresh.php',data);
  except
    //ShowMessage('??????????? ????? ? ????????' + #10#13);
    Exit;
  end;
  HTTP.Destroy;
//  SSL.Destroy;
       //  ShowMessage(Buffer);

        GetLocaleFormatSettings( GetThreadLocale, FmtStngs );
        FmtStngs.DateSeparator := '-';
        FmtStngs.ShortDateFormat := 'yyyy-mm-dd';
        FmtStngs.TimeSeparator := ':';
        FmtStngs.LongTimeFormat := 'hh:nn:ss';
        dtime := DateTimeToStr(IncMinute(Now,100*-1*24*60),FmtStngs);
        Form2.FormShow(Buffer);
//        JsonArray := TJSonObject.ParseJSONValue(Buffer) as TJSONArray;
//        for ArrayElement in JsonArray do
//        begin
//          Form9.InsertPanel(
//          ArrayElement.GetValue<TJSONArray>().Items[0].GetValue<String>(),
//          ArrayElement.GetValue<TJSONArray>().Items[1].GetValue<String>(),
//          dtime,
//          ArrayElement.GetValue<TJSONArray>().Items[2].GetValue<String>(),
//          ArrayElement.GetValue<TJSONArray>().Items[3].GetValue<String>(),
//          ArrayElement.GetValue<TJSONArray>().Items[4].GetValue<String>()
//          );
//        end;
//
//        SendMessage(ScrollBox1.Handle, WM_SETREDRAW, 0, 0);
//        try
//        SortScrollBox1;
//         {&#133}
//        finally
//         SendMessage(ScrollBox1.Handle, WM_SETREDRAW, 1, 0);
//         RedrawWindow(ScrollBox1.Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
//        end;


  fields2.Free;
end;

procedure TForm9.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   SaveConfigToRegistry;
end;
procedure TForm9.StatsUpdate();
var
 Reg:TRegistry;
 fields,fields2: TJSONArray;
 i:integer;

 Buffer: String;
 HTTP: TIdHTTP;
 data: TIdMultiPartFormDataStream;
 SSL:TIdSSLIOHandlerSocketOpenSSL;

 JsonArray: TJSONArray;
begin
  fields2 := TJSONArray.Create;

  for i := 0 to ScrollBox1.ComponentCount-1 do
  begin
  fields := TJSONArray.Create;
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[0] as TEdit).Text);//country
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[1] as TEdit).Text);//domain
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[4] as TComboBox).Text);//intervaldays
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[9] as TEdit).Text);//messanger
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[8] as TEdit).Text);//contact
  fields2.Add(fields);
//  fields.Free;
  end;

  Reg := TRegistry.Create;
  Reg.LazyWrite := false;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('\SOFTWARE\PHPAssistent', true);

  data := TIdMultiPartFormDataStream.Create;
  data.AddFormField('userid', Reg.ReadString('id'));
     Reg.CloseKey;
     Reg.Free;
  data.AddFormField('config', UTF8Encode(fields2.ToString), 'utf-8').ContentTransfer := '8bit';
//  SSL:=TIdSSLIOHandlerSocketOpenSSL.Create(Application);
//  SSL.ReadTimeOut:=10000;
//  ///sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1,sslvTLSv1.sslvTLSv1_1,sslvTLSv1_2
//  SSL.SSLOptions.Method:=sslvSSLv23;
//  SSL.SSLOptions.Mode:=sslmUnassigned;
  HTTP := TIdHTTP.Create;
  HTTP.ReadTimeout:=10000;
  HTTP.ConnectTimeout:=10000;
 // HTTP.IOHandler:=SSL;
  HTTP.AllowCookies:=true;
  try
    Buffer := HTTP.Post('http://php.xp3.biz/statsupdate.php',data);
  except
    //ShowMessage('??????????? ????? ? ????????' + #10#13);
    Exit;
  end;
  HTTP.Destroy;
//  SSL.Destroy;

//  MessageBox(
//    Self.Handle
//    , PChar(
//       Buffer
//    )
//    , PChar('?????????? ???????')
//    , MB_OK + MB_ICONINFORMATION + MB_APPLMODAL
//  );

        JsonArray := TJSonObject.ParseJSONValue(Buffer) as TJSONArray;
        Label10.Caption := JsonArray.GetValue<TJSONArray>().Items[0].GetValue<String>();
        Label14.Caption := JsonArray.GetValue<TJSONArray>().Items[1].GetValue<String>();
        Label13.Caption := JsonArray.GetValue<TJSONArray>().Items[2].GetValue<String>();
        ReclamaURL.Text := JsonArray.GetValue<TJSONArray>().Items[3].GetValue<String>();
        DownloadPNG(JsonArray.GetValue<TJSONArray>().Items[4].GetValue<String>(),Image4);

end;
procedure TForm9.DownloadPNG(url:string;im:TImage);
var
str :TMemoryStream;
pngimg: TPNGImage;
idhttp1:TIdHTTP;
//SSL:TIdSSLIOHandlerSocketOpenSSL;
begin
      idhttp1 := TIdHTTP.Create(nil); idhttp1.ReadTimeout:=10000;
//      SSL:=TIdSSLIOHandlerSocketOpenSSL.Create(Application);
//      SSL.ReadTimeOut:=10000;
      ///sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1,sslvTLSv1.sslvTLSv1_1,sslvTLSv1_2
//      SSL.SSLOptions.Method:=sslvSSLv23;
//      SSL.SSLOptions.Mode:=sslmUnassigned;
//      idhttp1.IOHandler:=SSL;
      str:=TMemoryStream.Create;
      try
      idhttp1.Get('http://php.xp3.biz/img/'+url,str);
      except
      //ShowMessage('Image was not found');
      Exit;
      end;
      pngimg := TPNGImage.Create;
      try
      str.Position := 0;
      pngimg.LoadFromStream(str);
      im.Picture.Assign(pngimg);
      finally
//      SSL.Free;
      idhttp1.Free;
      str.Free;
      pngimg.Free;
      end;
end;

procedure TForm9.FormCreate(Sender: TObject);
var
FmtStngs: TFormatSettings;
dtimecurrent:TDateTime;
dtime:String;
Reg:TRegistry;
jsonstring:string;
  JSonValue,ArrayElement: TJSonValue;
  JsonArray: TJSONArray;
  a:TJsonObject;
  aPair: TJSONPair;
begin
//FocusObject := Edit1;
dtimecurrent := Now;
GetLocaleFormatSettings( GetThreadLocale, FmtStngs );
FmtStngs.DateSeparator := '-';
FmtStngs.ShortDateFormat := 'yyyy-mm-dd';
FmtStngs.TimeSeparator := ':';
FmtStngs.LongTimeFormat := 'hh:nn:ss';
dtime := DateTimeToStr(IncMinute(dtimecurrent,100*-1*24*60),FmtStngs);
     Reg := TRegistry.Create;
     Reg.LazyWrite := false;
     Reg.RootKey := HKEY_CURRENT_USER;
     Reg.OpenKey('\SOFTWARE\PHPAssistent', true);
     if Reg.ReadString('id')='' then
     begin
        Reg.WriteString('id', Random(99999999).ToString);
        Form9.ScrollBox1.DestroyComponents;
        Form9.InsertPanel('Russia', 'www.hh.ru', dtime,'2','@bogdansuvorov','Telegram');
        Form9.InsertPanel('Russia', 'www.rabota.ru', dtime,'5','@bogdansuvorov','Telegram');
        Form9.InsertPanel('Russia', 'www.superjob.ru', dtime,'5','@bogdansuvorov','Telegram');
        Form9.InsertPanel('Ukraine', 'www.work.ua', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('Ukraine', 'www.rabota.ua', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('Ukraine', 'www.trud.ua', dtime,'20','@bogdansuvorov','Telegram');
        Form9.InsertPanel('USA', 'www.indeed.com', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('USA', 'www.monster.com', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('USA', 'www.linkedin.com', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('USA', 'www.careerbuilder.com', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('Turkey', 'www.kariyer.net', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('Turkey', 'www.careerjet.com.tr', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('Turkey', 'www.elemanonline.com.tr', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('Turkey', 'www.yenibiris.com', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('France', 'www.ouestjob.com', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('France', 'www.apec.fr', dtime,'7','@bogdansuvorov','Telegram');
        Form9.InsertPanel('France', 'www.meteojob.com', dtime,'7','@bogdansuvorov','Telegram');
        SaveConfigToRegistry;
        SortScrollBox1;
     end
     else
     if Reg.ReadString('config')<>'' then
     begin
        jsonstring := Reg.ReadString('config');
        JsonArray := TJSonObject.ParseJSONValue(JsonString) as TJSONArray;
        for ArrayElement in JsonArray do
        begin
          Form9.InsertPanel(
          ArrayElement.GetValue<TJSONArray>().Items[0].GetValue<String>(),
          ArrayElement.GetValue<TJSONArray>().Items[1].GetValue<String>(),
          ArrayElement.GetValue<TJSONArray>().Items[2].GetValue<String>(),
          ArrayElement.GetValue<TJSONArray>().Items[3].GetValue<String>(),
          ArrayElement.GetValue<TJSONArray>().Items[4].GetValue<String>(),
          ArrayElement.GetValue<TJSONArray>().Items[5].GetValue<String>()
          );
        end;
        SortScrollBox1;

        jsonstring := Reg.ReadString('settings');
        JsonArray := TJSonObject.ParseJSONValue(JsonString) as TJSONArray;
        ListBox1.ItemIndex := JsonArray.GetValue<TJSONArray>().Items[0].GetValue<integer>();
        Edit1.Text := JsonArray.GetValue<TJSONArray>().Items[1].GetValue<String>();
        ComboBox1.Text := JsonArray.GetValue<TJSONArray>().Items[2].GetValue<String>();
        Edit2.Text := JsonArray.GetValue<TJSONArray>().Items[3].GetValue<String>();
        ListBox2.ItemIndex := JsonArray.GetValue<TJSONArray>().Items[4].GetValue<integer>();

     end;
     Reg.CloseKey;
     Reg.Free;
  ListBox1.ItemIndex := 179;
  ListBox2.ItemIndex := 0;

  StatsUpdate;

  Inc(Queue);
  SetTimer(Application.Handle,Queue,1800000,@Proc);
//Edit1.Text :=  dtime;
end;

procedure TForm9.HandleDomainClick(Sender: TObject);
begin
(Sender as TEdit).SelectAll;
(Sender as TEdit).CopyToClipboard;
end;
procedure TForm9.Image4Click(Sender: TObject);
begin
ShellExecute(0,'Open',PWideChar(ReclamaURL.Text),nil,nil,SW_SHOWNORMAL);
end;

procedure TForm9.Image5Click(Sender: TObject);
begin
Form3.Show;
end;

procedure TForm9.InsertPanel(country:string; domain:string; dtime:string;intervaldays:string;contact:string;messenger:string);
var
panel : TPanel;
editcountry,editdomain,editdtime,editcontact,editmessenger : TEdit;
pblastvisit: TProgressBar;
cbintervaldays:TComboBox;
imgok,imgdel,imgmessenger:TImage;
StrList: TStringList;
i:integer;

FmtStngs: TFormatSettings;
dtimedelta:integer;
begin
    GetLocaleFormatSettings( GetThreadLocale, FmtStngs );
    FmtStngs.DateSeparator := '-';
    FmtStngs.ShortDateFormat := 'yyyy-mm-dd';
    FmtStngs.TimeSeparator := ':';
    FmtStngs.LongTimeFormat := 'hh:nn:ss';
//    dtimedelta := MinutesBetween(Now,IncMilliSecond(IncMinute(StrToDateTime(dtime,FmtStngs),intervaldays.ToInt64*24*60)));
    dtimedelta := MinutesBetween(Now,IncMilliSecond(StrToDateTime(dtime,FmtStngs)));


    panel :=TPanel.Create(nil);
    panel.Parent := ScrollBox1;
    panel.Align := alTop;
  //  panel.Top := ScrollBox3.ComponentCount  * 30 + 10;
  //  panel.Left := 10;//(ScrollBox3.ComponentCount - (Trunc(ScrollBox3.ComponentCount / Trunc(ScrollBox3.ClientWidth / 150))*Trunc(ScrollBox3.ClientWidth / 150)))* 150 + 10;
  //  panel.Tag := 'id';
 //   panel.OnClick := Panel14Click;
    panel.ParentBackground := true;
 //   panel.Color := clWhite;
    panel.ShowCaption := false; panel.BevelOuter := bvNone;
    panel.Height := 20;

    editcountry := TEdit.Create(nil);
    editcountry.Parent := panel;
    editcountry.Text := country;//dtimedelta.ToString;//country;
    editcountry.Width := 60;
    editcountry.Align := alLeft;
    editcountry.ReadOnly := true;
    panel.InsertComponent(editcountry);

    editdomain := TEdit.Create(nil);
    editdomain.Parent := panel;
    editdomain.Text := domain;
//    editdomain.Width := 60;
    editdomain.Align := alClient;
    editdomain.OnClick := HandleDomainClick;
    panel.InsertComponent(editdomain);

    imgdel := TImage.Create(nil);
    imgdel.Parent := panel;
    imgdel.Picture := Image3.Picture;
    imgdel.Width := 25;
    imgdel.Stretch := true;
    imgdel.Align := alRight;
    imgdel.OnClick := HandleImgdelClick;
    panel.InsertComponent(imgdel);

    imgok := TImage.Create(nil);
    imgok.Parent := panel;
    imgok.Picture := Image1.Picture;
    imgok.Width := 25;
    imgok.Stretch := true;
    imgok.Align := alRight;
    imgok.OnClick := HandleImgokClick;
    panel.InsertComponent(imgok);

    cbintervaldays := TComboBox.Create(nil);
    cbintervaldays.Parent := panel;
    cbintervaldays.Width := 34;
    cbintervaldays.Align := alRight;
    StrList:=TStringList.Create;
    for i := 1 to 20 do StrList.Add(i.ToString);
    cbintervaldays.Items := StrList;
    cbintervaldays.ItemIndex := intervaldays.ToInteger-1;
    StrList.Free;
    cbintervaldays.SelStart:=2;
    cbintervaldays.Perform(WM_UPDATEUISTATE, MakeWParam(UIS_CLEAR, UISF_HIDEFOCUS), 0);
    cbintervaldays.Text := intervaldays;
    panel.InsertComponent(cbintervaldays);

    pblastvisit := TProgressBar.Create(nil);
    pblastvisit.Parent := panel;
    if (dtimedelta >= (intervaldays.ToInteger*24*60)) OR (dtimedelta <=0) then
    begin
       pblastvisit.Position := 100;
       pblastvisit.State := pbsError;
    end
    else
    begin
       pblastvisit.State := pbsNormal;
       pblastvisit.Position := round(100/((intervaldays.ToInteger*24*60)/dtimedelta));
    end;
    pblastvisit.Width := 150;
    pblastvisit.Align := alRight;
    panel.InsertComponent(pblastvisit);

    editdtime := TEdit.Create(nil);
    editdtime.Parent := panel;
    editdtime.Text := dtime;
    editdtime.Visible := false;
    panel.InsertComponent(editdtime);

    imgmessenger := TImage.Create(nil);
    imgmessenger.Parent := panel;
      if messenger='Telegram' then imgmessenger.Picture := Telegram.Picture;
      if messenger='Skype' then imgmessenger.Picture := Skype.Picture;
      if messenger='WhatsApp' then imgmessenger.Picture := WhatsApp.Picture;
      if messenger='Discord' then imgmessenger.Picture := Discord.Picture;
      if messenger='Viber' then imgmessenger.Picture := Viber.Picture;
      if messenger='Kvirc' then imgmessenger.Picture := Kvirc.Picture;
    //imgmessenger.Picture := Image3.Picture;
    imgmessenger.Width := 25;
    imgmessenger.Stretch := true;
    imgmessenger.Align := alRight;
    imgmessenger.OnClick := HandleImgmessengerClick;
    panel.InsertComponent(imgmessenger);

    editcontact := TEdit.Create(nil);
    editcontact.Parent := panel;
    editcontact.Text := contact;
    editcontact.Visible := false;
    panel.InsertComponent(editcontact);

    editmessenger := TEdit.Create(nil);
    editmessenger.Parent := panel;
    editmessenger.Text := messenger;
    editmessenger.Visible := false;
    panel.InsertComponent(editmessenger);

    ScrollBox1.InsertComponent(panel);
end;

procedure TForm9.SaveConfigToRegistry ();
var
Reg:TRegistry;
  fields,fields2: TJSONArray;
  i:integer;
begin
  fields2 := TJSONArray.Create;

  for i := 0 to ScrollBox1.ComponentCount-1 do
  begin
  fields := TJSONArray.Create;
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[0] as TEdit).Text);//country
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[1] as TEdit).Text);//domain
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[6] as TEdit).Text);//lastvisitdtime
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[4] as TComboBox).Text);//intervaldays
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[8] as TEdit).Text);//contact
  fields.Add(((ScrollBox1.Components[i] as TPanel).Components[9] as TEdit).Text);//messanger
  fields2.Add(fields);
//  fields.Free;
  end;



     Reg := TRegistry.Create;
     Reg.LazyWrite := false;
     Reg.RootKey := HKEY_CURRENT_USER; // HKEY_LOCAL_MACHINE;//
//     Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', true);
     Reg.OpenKey('\SOFTWARE\PHPAssistent', true);
     Reg.WriteString('config', fields2.ToString);

     fields := TJSONArray.Create;
     fields.Add(ListBox1.ItemIndex.ToString);
     fields.Add(Edit1.Text);
     fields.Add(ComboBox1.Text);
     fields.Add(Edit2.Text);
     fields.Add(ListBox2.ItemIndex.ToString);
     Reg.WriteString('settings', fields.ToString);

     Reg.CloseKey;
     Reg.Free;
    fields2.Free;
//    fields.Free;
end;

procedure TForm9.HandleImgokClick(Sender: TObject);
var
FmtStngs: TFormatSettings;
begin
  (((Sender as TImage).Parent as TPanel).Components[5] as TProgressBar).Position :=0;
  (((Sender as TImage).Parent as TPanel).Components[5] as TProgressBar).Position :=0;
  (((Sender as TImage).Parent as TPanel).Components[5] as TProgressBar).State := pbsNormal;

    GetLocaleFormatSettings( GetThreadLocale, FmtStngs );
    FmtStngs.DateSeparator := '-';
    FmtStngs.ShortDateFormat := 'yyyy-mm-dd';
    FmtStngs.TimeSeparator := ':';
    FmtStngs.LongTimeFormat := 'hh:nn:ss';
  (((Sender as TImage).Parent as TPanel).Components[6] as TEdit).Text := DateTimeToStr(Now,FmtStngs);
  SaveConfigToRegistry;
end;

procedure TForm9.HandleImgmessengerClick(Sender: TObject);
begin

Clipboard.asText:=(((Sender as TImage).Parent as TPanel).Components[8] as TEdit).Text;
  MessageBox(
    Self.Handle
    , PChar(
    (((Sender as TImage).Parent as TPanel).Components[0] as TEdit).Text + ': ' +
    (((Sender as TImage).Parent as TPanel).Components[1] as TEdit).Text + #10#13 +
    (((Sender as TImage).Parent as TPanel).Components[9] as TEdit).Text + ': ' +
    (((Sender as TImage).Parent as TPanel).Components[8] as TEdit).Text + #10#13#10#13 +
    '??????????? ? ????? ??????'
    )
    , PChar('??????? ????????????')
    , MB_OK + MB_ICONINFORMATION + MB_APPLMODAL
  );
end;

procedure TForm9.HandleImgdelClick(Sender: TObject);
var
FmtStngs: TFormatSettings;
begin

  ((Sender as TImage).Parent as TPanel).Destroy;
  SaveConfigToRegistry;
end;

procedure TForm9.Memo1Click(Sender: TObject);
begin
Memo1.SelectAll;
Memo1.CopyToClipboard;
end;

end.
