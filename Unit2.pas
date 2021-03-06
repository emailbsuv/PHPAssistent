unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,DateUtils,System.JSON,clipbrd,IdHTTP, IdMultipartFormData,
  IdSSL, IdSSLOpenSSL, Registry;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    Panel3: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(JSONValue: string);
    procedure InsertPanel(country:string; domain:string; intervaldays:string;contact:string;messenger:string);
    procedure HandleImgmessengerClick(Sender: TObject);
    procedure HandleDomainClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
uses Unit1;

procedure TForm2.InsertPanel(country:string; domain:string; intervaldays:string;contact:string;messenger:string);
var
panel : TPanel;
editcountry,editdomain,editdtime,editcontact,editmessenger,cbintervaldays : TEdit;
rgaction:TRadioGroup;
imgok,imgdel,imgmessenger:TImage;
StrList: TStringList;
i:integer;

FmtStngs: TFormatSettings;
dtimedelta:integer;
dtime:string;
begin
    GetLocaleFormatSettings( GetThreadLocale, FmtStngs );
    FmtStngs.DateSeparator := '-';
    FmtStngs.ShortDateFormat := 'yyyy-mm-dd';
    FmtStngs.TimeSeparator := ':';
    FmtStngs.LongTimeFormat := 'hh:nn:ss';
    dtime := DateTimeToStr(IncMinute(Now,100*-1*24*60),FmtStngs);


    panel :=TPanel.Create(nil);
    panel.Parent := ScrollBox1;
    panel.Align := alTop;
    panel.ParentBackground := true;
    panel.ShowCaption := false; panel.BevelOuter := bvNone;
    panel.Height := 20;

    editdtime := TEdit.Create(nil);
    editdtime.Parent := panel;
    editdtime.Text := dtime;
    editdtime.Visible := false;
    panel.InsertComponent(editdtime);

    imgmessenger := TImage.Create(nil);
    imgmessenger.Parent := panel;
      if messenger='Telegram' then imgmessenger.Picture := Form9.Telegram.Picture;
      if messenger='Skype' then imgmessenger.Picture := Form9.Skype.Picture;
      if messenger='WhatsApp' then imgmessenger.Picture := Form9.WhatsApp.Picture;
      if messenger='Discord' then imgmessenger.Picture := Form9.Discord.Picture;
      if messenger='Viber' then imgmessenger.Picture := Form9.Viber.Picture;
      if messenger='Kvirc' then imgmessenger.Picture := Form9.Kvirc.Picture;
    imgmessenger.Width := 25;
    imgmessenger.Stretch := true;
    imgmessenger.Align := alLeft;
    imgmessenger.OnClick := HandleImgmessengerClick;
    panel.InsertComponent(imgmessenger);

    cbintervaldays := TEdit.Create(nil);
    cbintervaldays.Parent := panel;
    cbintervaldays.Text := intervaldays;
    cbintervaldays.Width := 20;
    cbintervaldays.Align := alLeft;
    cbintervaldays.ReadOnly := true;
    panel.InsertComponent(cbintervaldays);

    editdomain := TEdit.Create(nil);
    editdomain.Parent := panel;
    editdomain.Text := domain;
    editdomain.Width := 260;
    editdomain.Align := alLeft;
    editdomain.ReadOnly := true;
    editdomain.OnClick := HandleDomainClick;
    panel.InsertComponent(editdomain);

    editcountry := TEdit.Create(nil);
    editcountry.Parent := panel;
    editcountry.Text := country;
    editcountry.Width := 60;
    editcountry.Align := alLeft;
    editcountry.ReadOnly := true;
    panel.InsertComponent(editcountry);

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

    rgaction := TRadioGroup.Create(nil);
    rgaction.Parent := panel;
    rgaction.Caption := '';
    rgaction.Width := 210;
    rgaction.Height := 41;
    rgaction.Left := 368;
    rgaction.Top := -15;
    rgaction.Columns:=2;
    rgaction.Items.Add('????????');
    rgaction.Items.Add('?????????????');
    rgaction.ItemIndex := 0;
    panel.InsertComponent(rgaction);

    ScrollBox1.InsertComponent(panel);
end;

procedure SortScrollBox1();
var
fields,fields2,psfields1,sfields1: TJSONArray;
psfields2,sfields2: TJSONArray;
psfields3,sfields3: TJSONArray;
i,i0,i1,tmp1,tmp2,tmp3:integer;
tmp:string;
begin
  fields2 := TJSONArray.Create;
  for i := 0 to Form2.ScrollBox1.ComponentCount-1 do
  begin
    fields := TJSONArray.Create;
    fields.Add(((Form2.ScrollBox1.Components[i] as TPanel).Components[4] as TEdit).Text);//country
    fields.Add(((Form2.ScrollBox1.Components[i] as TPanel).Components[3] as TEdit).Text);//domain
    fields.Add(((Form2.ScrollBox1.Components[i] as TPanel).Components[2] as TEdit).Text);//intervaldays
    fields.Add(((Form2.ScrollBox1.Components[i] as TPanel).Components[5] as TEdit).Text);//contact
    fields.Add(((Form2.ScrollBox1.Components[i] as TPanel).Components[6] as TEdit).Text);//messenger
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
    sfields3.Add(psfields3);
    sfields2.Remove(i1);
  end;

  Form2.ScrollBox1.DestroyComponents;
  for i := 0 to sfields3.Count-1 do
  begin
    Form2.InsertPanel(
      sfields3.Items[i].GetValue<TJSONArray>().Items[0].GetValue<String>(),
      sfields3.Items[i].GetValue<TJSONArray>().Items[1].GetValue<String>(),
      sfields3.Items[i].GetValue<TJSONArray>().Items[2].GetValue<String>(),
      sfields3.Items[i].GetValue<TJSONArray>().Items[3].GetValue<String>(),
      sfields3.Items[i].GetValue<TJSONArray>().Items[4].GetValue<String>()
    );
//    Form2.Memo2.Lines.Add(sfields1.Items[i].GetValue<TJSONArray>().Items[0].GetValue<String>());
  end;
  sfields1.Free;
  sfields2.Free;
  sfields3.Free;
  fields2.Free;
end;

procedure TForm2.HandleDomainClick(Sender: TObject);
begin
(Sender as TEdit).SelectAll;
(Sender as TEdit).CopyToClipboard;
end;

procedure TForm2.HandleImgmessengerClick(Sender: TObject);
begin
  //ShowMessage
Clipboard.asText:=(((Sender as TImage).Parent as TPanel).Components[5] as TEdit).Text;
  MessageBox(
    Self.Handle
    , PChar(
    (((Sender as TImage).Parent as TPanel).Components[4] as TEdit).Text + ': ' +
    (((Sender as TImage).Parent as TPanel).Components[3] as TEdit).Text + #10#13 +
    (((Sender as TImage).Parent as TPanel).Components[6] as TEdit).Text + ': ' +
    (((Sender as TImage).Parent as TPanel).Components[5] as TEdit).Text + #10#13#10#13 +
    '??????????? ? ????? ??????'
    )
    , PChar('??????? ????????????')
    , MB_OK + MB_ICONINFORMATION + MB_APPLMODAL
  );

end;
procedure TForm2.Button1Click(Sender: TObject);
var
i:integer;
blocksites:string;

 Buffer: String;
 HTTP: TIdHTTP;
 data: TIdMultiPartFormDataStream;
 SSL:TIdSSLIOHandlerSocketOpenSSL;

 Reg:TRegistry;

 FmtStngs: TFormatSettings;
 dtime:string;
begin
    GetLocaleFormatSettings( GetThreadLocale, FmtStngs );
    FmtStngs.DateSeparator := '-';
    FmtStngs.ShortDateFormat := 'yyyy-mm-dd';
    FmtStngs.TimeSeparator := ':';
    FmtStngs.LongTimeFormat := 'hh:nn:ss';
    dtime := DateTimeToStr(IncMinute(Now,100*-1*24*60),FmtStngs);

SendMessage(Form9.ScrollBox1.Handle, WM_SETREDRAW, 0, 0);
try


    blocksites := '';
    for i := 0 to ScrollBox1.ComponentCount -1 do
      begin
          if ((ScrollBox1.Components[i] as TPanel).Components[7] as TRadioGroup).ItemIndex = 1 then
            blocksites := blocksites + ' ' +((ScrollBox1.Components[i] as TPanel).Components[3] as TEdit).Text
            else
          if ((ScrollBox1.Components[i] as TPanel).Components[7] as TRadioGroup).ItemIndex = 0 then
          Form9.InsertPanel(
            ((ScrollBox1.Components[i] as TPanel).Components[4] as TEdit).Text,
            ((ScrollBox1.Components[i] as TPanel).Components[3] as TEdit).Text,
            dtime,
            ((ScrollBox1.Components[i] as TPanel).Components[2] as TEdit).Text,
            ((ScrollBox1.Components[i] as TPanel).Components[5] as TEdit).Text,
            ((ScrollBox1.Components[i] as TPanel).Components[6] as TEdit).Text
          );

      end;
      if blocksites <> '' then
      begin

        Reg := TRegistry.Create;
        Reg.LazyWrite := false;
        Reg.RootKey := HKEY_CURRENT_USER;
        Reg.OpenKey('\SOFTWARE\PHPAssistent', true);

        data := TIdMultiPartFormDataStream.Create;
        data.AddFormField('userid', Reg.ReadString('id'));
           Reg.CloseKey;
           Reg.Free;
        data.AddFormField('blocksites', UTF8Encode(blocksites), 'utf-8').ContentTransfer := '8bit';

      //  SSL:=TIdSSLIOHandlerSocketOpenSSL.Create(Application);
      //  SSL.ReadTimeOut:=10000;
      //  ///sslvSSLv2, sslvSSLv23, sslvSSLv3, sslvTLSv1,sslvTLSv1.sslvTLSv1_1,sslvTLSv1_2
      //  SSL.SSLOptions.Method:=sslvSSLv23;
      //  SSL.SSLOptions.Mode:=sslmUnassigned;
        HTTP := TIdHTTP.Create;
        HTTP.ReadTimeout:=10000;
        HTTP.ConnectTimeout:=10000;
    //    HTTP.IOHandler:=SSL;
        HTTP.AllowCookies:=true;
        try
          Buffer := HTTP.Post('http://php.xp3.biz/blocksites.php',data);
        except
          //ShowMessage('??????????? ????? ? ????????' + #10#13);
          Exit;
        end;
        HTTP.Destroy;
      //  SSL.Destroy;

      end;
  Form9.SortScrollBox1;

 {&#133}
finally
 SendMessage(Form9.ScrollBox1.Handle, WM_SETREDRAW, 1, 0);
 RedrawWindow(Form9.ScrollBox1.Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
end;
 Form9.Label14.Caption := '0';


Form2.Close;
end;

procedure TForm2.FormShow(JSONValue: string);
var
  ArrayElement: TJSonValue;
  JsonArray: TJSONArray;
begin
Form2.Show;
SendMessage(ScrollBox1.Handle, WM_SETREDRAW, 0, 0);
try
        ScrollBox1.DestroyComponents;
        JsonArray := TJSonObject.ParseJSONValue(JSONValue) as TJSONArray;
        for ArrayElement in JsonArray do
        begin
          Form2.InsertPanel(
          ArrayElement.GetValue<TJSONArray>().Items[0].GetValue<String>(),
          ArrayElement.GetValue<TJSONArray>().Items[1].GetValue<String>(),
          ArrayElement.GetValue<TJSONArray>().Items[2].GetValue<String>(),
          ArrayElement.GetValue<TJSONArray>().Items[4].GetValue<String>(),
          ArrayElement.GetValue<TJSONArray>().Items[3].GetValue<String>()
          );
        end;
        SortScrollBox1;
 {&#133}
finally
 SendMessage(ScrollBox1.Handle, WM_SETREDRAW, 1, 0);
 RedrawWindow(ScrollBox1.Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
end;

end;

end.

