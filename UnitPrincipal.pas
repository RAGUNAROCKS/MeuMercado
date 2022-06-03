unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Ani, uLoading;

type
  TFrmPrincipal = class(TForm)
    LytToolbar: TLayout;
    ImgMenu: TImage;
    imgCarrinho: TImage;
    Label1: TLabel;
    LytPesquisa: TLayout;
    StyleBook: TStyleBook;
    RectPesquisa: TRectangle;
    EdtBusca: TEdit;
    Image3: TImage;
    BtnBusca: TButton;
    LytSwitch: TLayout;
    RectSwitch: TRectangle;
    RectSwitchGrn: TRectangle;
    LblCasa: TLabel;
    LblLoja: TLabel;
    LvMercado: TListView;
    ImgShop: TImage;
    ImgTaxa: TImage;
    ImgPreco: TImage;
    AnimeRect: TFloatAnimation;
    RectMenu: TRectangle;
    Image2: TImage;
    ImgFecharMenu: TImage;
    LblEndereco: TLabel;
    Label2: TLabel;
    Rectangle2: TRectangle;
    Label3: TLabel;
    RectMenuPedido: TRectangle;
    Label4: TLabel;
    Rectangle3: TRectangle;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure LvMercadoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure LblCasaClick(Sender: TObject);
    procedure imgCarrinhoClick(Sender: TObject);
    procedure ImgMenuClick(Sender: TObject);
    procedure ImgFecharMenuClick(Sender: TObject);
    procedure RectMenuPedidoClick(Sender: TObject);
    procedure BtnBuscaClick(Sender: TObject);
  private
    FInd_Retira: string;
    FInd_Entrega: string;
    procedure AddMercadoLv(id_mercado: integer; nome, endereco: string; taxa,
      preco: double);
    procedure ListarMercados;
    procedure SelecionarEntrega(lbl: Tlabel);
    procedure OpenMenu(ind: boolean);
    procedure ThreadMercadoTerminate(Sender: TObject);
    { Private declarations }
  public
    property Ind_Entrega : string read FInd_Entrega write FInd_Entrega;
    property Ind_Retira : string read FInd_Retira write FInd_Retira;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitCatalogo, UnitCarrinho, UnitPedido, DataModule.Mercado;

procedure TFrmPrincipal.AddMercadoLv(id_mercado: integer;
                                     nome, endereco: string;
                                     taxa, preco: double);
var img: TListItemImage;
    txt: TListItemText;
begin
      with lvMercado.Items.add do
      Begin
        height  := 120;
        Tag := id_mercado;

        img := TListItemImage(Objects.FindDrawable('imgShop'));
        img.Bitmap := imgShop.Bitmap;
        img := TListItemImage(Objects.FindDrawable('imgTaxa'));
        img.Bitmap := imgTaxa.Bitmap;
        img := TListItemImage(Objects.FindDrawable('imgPreco'));
        img.Bitmap := imgPreco.Bitmap;
        txt := TListItemText(Objects.FindDrawable('TxtNome'));
        txt.Text := nome;
        txt := TListItemText(Objects.FindDrawable('TxtEndereco'));
        txt.Text := endereco;
        txt := TListItemText(Objects.FindDrawable('TxtTaxa'));
        txt.Text := 'Taxa de entrega: ' + FormatFloat('R$ #,##0.00', taxa);
        txt := TListItemText(Objects.FindDrawable('TxtPreco'));
        txt.Text := 'Compra Minima: ' + FormatFloat('R$ #,##0.00', preco);
      End;
end;

procedure TFrmPrincipal.SelecionarEntrega(lbl: Tlabel);
begin
    LblCasa.FontColor := $FF8F8F8F;
    LblLoja.FontColor := $FF8F8F8F;

    lbl.FontColor := $FFFFFFFF;
    Ind_Entrega := '';
    Ind_Retira := '';


    if lbl.Tag = 0 then
    begin
      Ind_Entrega := 'S';
    end
    else
    begin
      Ind_Retira := 'S';
    end;

    ListarMercados;

    AnimeRect.StopValue := lbl.Position.x;
    AnimeRect.Start;
end;

procedure TFrmPrincipal.LblCasaClick(Sender: TObject);
begin
   SelecionarEntrega(Tlabel(Sender));
end;

procedure TFrmPrincipal.ListarMercados;
var
  t : TThread;
begin
  TLoading.Show(FrmPrincipal, '');
  LvMercado.Items.Clear;
  LvMercado.BeginUpdate;
  t := TThread.CreateAnonymousThread(procedure
  var
  i : integer;
  begin
     sleep(1500);
     DmMercado.ListarMercado(EdtBusca.Text, Ind_Entrega, Ind_Retira);

     with DmMercado.TabMercado do
     begin
      for i := 0 to recordcount - 1 do
      begin
        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
          AddMercadoLv(fieldbyname('id_mercado').asinteger,
                      fieldbyname('nome').asstring,
                      fieldbyname('endereco').asstring,
                      fieldbyname('vl_entrega').asfloat,
                      fieldbyname('vl_compra_min').asfloat);
        end);

        Next;
      end;
     end;
  end);

  t.OnTerminate := ThreadMercadoTerminate;
  t.Start;
end;

procedure TFrmPrincipal.OpenMenu(ind: boolean);
begin
  rectMenu.Visible := ind;
end;

procedure TFrmPrincipal.RectMenuPedidoClick(Sender: TObject);
begin
  if NOT assigned(FrmPedido) then
    application.CreateForm(TFrmPedido,FrmPedido);

    OpenMenu(false);
    FrmPedido.show;
end;

procedure TFrmPrincipal.LvMercadoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if NOT Assigned(FrmCatalogo) then
      Application.CreateForm(TFrmCatalogo, FrmCatalogo);
    FrmCatalogo.id_mercado := AItem.Tag;
    FrmCatalogo.Show;
end;

procedure TFrmPrincipal.BtnBuscaClick(Sender: TObject);
begin
  ListarMercados;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
      SelecionarEntrega(lblCasa);
end;

procedure TFrmPrincipal.imgCarrinhoClick(Sender: TObject);
begin
  if NOT Assigned(FrmCarrinho) then
      Application.CreateForm(TFrmCarrinho, FrmCarrinho);

      FrmCarrinho.Show;
end;

procedure TFrmPrincipal.ImgFecharMenuClick(Sender: TObject);
begin
    OpenMenu(false);
end;

procedure TFrmPrincipal.ImgMenuClick(Sender: TObject);
begin
    OpenMenu(true);
end;

procedure TFrmPrincipal.ThreadMercadoTerminate(Sender: TObject);
begin
   TLoading.Hide;
   LvMercado.EndUpdate;
   if Sender is TThread then
   begin
     if Assigned(TThread(Sender).FatalException) then
     begin
      showmessage(Exception(TThread(Sender).FatalException).Message);
      exit;
     end;
   end;
end;

end.
