unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Ani;

type
  TFrmPrincipal = class(TForm)
    LytToolbar: TLayout;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    LytPesquisa: TLayout;
    StyleBook: TStyleBook;
    RectPesquisa: TRectangle;
    Edit1: TEdit;
    Image3: TImage;
    Button1: TButton;
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
    procedure FormShow(Sender: TObject);
    procedure LvMercadoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure LblCasaClick(Sender: TObject);
  private
    procedure AddMercadoLv(id_mercado: integer; nome, endereco: string; taxa,
      preco: double);
    procedure ListarMercados;
    procedure SelecionarEntrega(lbl: Tlabel);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitCatalogo;

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

    AnimeRect.StopValue := lbl.Position.x;
    AnimeRect.Start;
end;

procedure TFrmPrincipal.LblCasaClick(Sender: TObject);
begin
   SelecionarEntrega(Tlabel(Sender));
end;

procedure TFrmPrincipal.ListarMercados;
begin
     AddMercadoLv(1,'Pao de A�ucar', 'Av. Paulista, 1500', 10, 50);
     AddMercadoLv(1,'Pao de A�ucar', 'Av. Paulista, 1500', 10, 50);
     AddMercadoLv(1,'Pao de A�ucar', 'Av. Paulista, 1500', 10, 50);
     AddMercadoLv(1,'Pao de A�ucar', 'Av. Paulista, 1500', 10, 50);
end;

procedure TFrmPrincipal.LvMercadoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if NOT Assigned(FrmCatalogo) then
      Application.CreateForm(TFrmCatalogo, FrmCatalogo);
      FrmCatalogo.Show;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
      ListarMercados;
end;

end.
