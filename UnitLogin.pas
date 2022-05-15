unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects, FMX.Edit;

type
  TFrmLogin = class(TForm)
    Image1: TImage;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    Layout1: TLayout;
    Label1: TLabel;
    EdtEmail: TEdit;
    EdtSenha: TEdit;
    BtnLogin: TButton;
    TabConta1: TTabItem;
    TabConta2: TTabItem;
    Label2: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    BtnProx: TButton;
    Image2: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Edit5: TEdit;
    Image3: TImage;
    Layout3: TLayout;
    Label6: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    BtnCriarConta: TButton;
    Label7: TLabel;
    Edit8: TEdit;
    Label8: TLabel;
    Layout4: TLayout;
    Edit9: TEdit;
    Edit10: TEdit;
    Layout2: TLayout;
    StyleBook: TStyleBook;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    Rectangle8: TRectangle;
    Rectangle9: TRectangle;
    Rectangle10: TRectangle;
    procedure BtnLoginClick(Sender: TObject);
  private
    procedure ThreadLoginTerminate(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses DataModule.Usuario, UnitPrincipal;

procedure TFrmLogin.ThreadLoginTerminate(Sender: TObject);
begin
   if Sender is TThread then
   begin
     if Assigned(TThread(Sender).FatalException) then
     begin
      showmessage(Exception(TThread(Sender).FatalException).Message);
      exit;
     end;
   end;

   //Abrir o Unit Principal
   if NOT Assigned(FrmPrincipal) then
      Application.CreateForm(TFrmPrincipal, FrmPrincipal);
   FrmPrincipal.Show;
end;

procedure TFrmLogin.BtnLoginClick(Sender: TObject);
var
  t : TThread;
begin
  t := TThread.CreateAnonymousThread(procedure
  begin
     DmUsuario.Login(edtEmail.Text, edtSenha.Text);

     if DmUsuario.TabUsuario.RecordCount > 0 then
     begin

     end;
  end);

  t.OnTerminate := ThreadLoginTerminate;
  t.Start;
end;

end.
