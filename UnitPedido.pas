unit UnitPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TFrmPedido = class(TForm)
    LytToolbar: TLayout;
    Label1: TLabel;
    ImgMenu: TImage;
    LvPedidos: TListView;
    ImgShop: TImage;
    procedure FormShow(Sender: TObject);
    procedure LvPedidosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure AddPedidoLv(id_pedido, qtd_itens: integer;
                           nome, endereco, dt_pedido: string;
                           vl_pedido: double);
    procedure ListarPedidos;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedido: TFrmPedido;

implementation

{$R *.fmx}

uses UnitPrincipal, UnitPedidoDetalhe;

procedure TFrmPedido.AddPedidoLv(id_pedido, qtd_itens: integer;
                                  nome, endereco, dt_pedido: string;
                                  vl_pedido: double);
var img: TListItemImage;
    txt: TListItemText;
begin
      with lvPedidos.Items.add do
      Begin
        height  := 120;
        Tag := id_pedido;

        img := TListItemImage(Objects.FindDrawable('imgShop'));
        img.Bitmap := imgShop.Bitmap;
        txt := TListItemText(Objects.FindDrawable('TxtNome'));
        txt.Text := nome;
        txt := TListItemText(Objects.FindDrawable('TxtPedido'));
        txt.Text := 'Pedido ' + id_pedido.ToString;
        txt := TListItemText(Objects.FindDrawable('TxtEndereco'));
        txt.Text := endereco;
        txt := TListItemText(Objects.FindDrawable('TxtValor'));
        txt.Text := FormatFloat('R$ #,##0.00', vl_pedido) + ' - ' + qtd_itens.ToString + ' itens';
        txt := TListItemText(Objects.FindDrawable('TxtData'));
        txt.Text := dt_pedido;
      End;
end;

procedure TFrmPedido.ListarPedidos;
begin
     AddPedidoLv(1,3,'P�o de A��car', 'Av.Paulista, 1500', '15/02/2022', 142);
     AddPedidoLv(2,3,'P�o de A��car', 'Av.Paulista, 1500', '15/02/2022', 142);
     AddPedidoLv(3,3,'P�o de A��car', 'Av.Paulista, 1500', '15/02/2022', 142);
     AddPedidoLv(4,3,'P�o de A��car', 'Av.Paulista, 1500', '15/02/2022', 142);
end;

procedure TFrmPedido.LvPedidosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  if NOT assigned(FrmPedidoDetalhe) then
    Application.CreateForm(TFrmPedidoDetalhe, FrmPedidoDetalhe);

    FrmPedidoDetalhe.Show;
end;

procedure TFrmPedido.FormShow(Sender: TObject);
begin
  ListarPedidos;
end;

end.
