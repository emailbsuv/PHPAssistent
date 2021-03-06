unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,IdHTTP, IdMultipartFormData,
  IdSSL, IdSSLOpenSSL,Registry;

type
  TForm3 = class(TForm)
    FileOpenDialog1: TFileOpenDialog;
    Button1: TButton;
    Edit1: TEdit;
    Image2: TImage;
    Panel1: TPanel;
    Image1: TImage;
    Edit2: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FileOpenDialog1FileOkClick(Sender: TObject;
      var CanClose: Boolean);
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}
uses Unit1;
procedure TForm3.Button1Click(Sender: TObject);
var
 Reg:TRegistry;
 Buffer: String;
 HTTP: TIdHTTP;
 data: TIdMultiPartFormDataStream;
 SSL:TIdSSLIOHandlerSocketOpenSSL;
begin
     Reg := TRegistry.Create;
     Reg.LazyWrite := false;
     Reg.RootKey := HKEY_CURRENT_USER;
     Reg.OpenKey('\SOFTWARE\PHPAssistent', true);

  data := TIdMultiPartFormDataStream.Create;
  data.AddFormField('userid', Reg.ReadString('id'));
     Reg.CloseKey;
     Reg.Free;

  data.AddFormField('linkname', UTF8Encode(Edit2.Text), 'utf-8').ContentTransfer := '8bit';
  data.AddFile('tmp_name', Edit1.Text, 'image/png');

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
    Buffer := HTTP.Post('http://php.xp3.biz/reclama.php',data);
  except
    //ShowMessage('??????????? ????? ? ????????' + #10#13);
    Exit;
  end;
  HTTP.Destroy;
//  SSL.Destroy;
  MessageBox(
    Self.Handle
    , PChar(
       Buffer
    )
    , PChar('?????????? ???????')
    , MB_OK + MB_ICONINFORMATION + MB_APPLMODAL
  );
  Form9.Image4.Picture := Image1.Picture;
  Form9.ReclamaURL.Text := Edit2.Text;
  Form3.Close;
end;

procedure TForm3.FileOpenDialog1FileOkClick(Sender: TObject;
  var CanClose: Boolean);
begin
Edit1.Text := FileOpenDialog1.FileName;
Image1.Picture.LoadFromFile(FileOpenDialog1.FileName);
end;

procedure TForm3.Image2Click(Sender: TObject);
begin
FileOpenDialog1.Execute;
end;

end.
