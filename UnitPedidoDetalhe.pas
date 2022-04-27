unit UnitPedidoDetalhe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox;

type
  TFrmPedidoDetalhe = class(TForm)
    LtyEndereco: TLayout;
    LblNome: TLabel;
    LblEndereco: TLabel;
    LytToolbar: TLayout;
    LblTitulo: TLabel;
    ImgVoltar: TImage;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Layout2: TLayout;
    Label3: TLabel;
    Label4: TLabel;
    Layout3: TLayout;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LtbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
  private
    procedure AddProduto(id_produto: integer; descricao: string; qtd,
      valor_unit: double; foto: TStream);
    procedure CarregarPedido;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedidoDetalhe: TFrmPedidoDetalhe;

implementation

{$R *.fmx}

uses Frame.ProdutoLista;

procedure TFrmPedidoDetalhe.AddProduto(id_produto: integer;
                                 descricao: string;
                                 qtd, valor_unit: double;
                                 foto: TStream);
var
    item: TListBoxItem;
    frame: TFrameProdutLista;
begin
    item := TListBoxItem.Create(LtbProdutos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 80;
    item.Tag := id_produto;

    frame := TFrameProdutLista.Create(item);
    //frame.img Produto(
    frame.LblDescricao.Text := descricao;
    frame.LblQtd.Text := qtd.ToString + ' x ' + FormatFloat('R$ #,##0.00', valor_unit);
    frame.LblValor.Text := FormatFloat('R$ #,##0.00', qtd * valor_unit);

    item.AddObject(frame);

    LtbProdutos.AddObject(item);
end;

procedure TFrmPedidoDetalhe.CarregarPedido;
begin
    AddProduto(0, 'Caf� Pil�o Torrado E Mo�do', 2, 15, nil);
    AddProduto(0, 'Caf� Pil�o Torrado E Mo�do', 1, 15, nil);
    AddProduto(0, 'Caf� Pil�o Torrado E Mo�do', 3, 15, nil);
    AddProduto(0, 'Caf� Pil�o Torrado E Mo�do', 5, 15, nil);
    AddProduto(0, 'Caf� Pil�o Torrado E Mo�do', 4, 15, nil);
    AddProduto(0, 'Caf� Pil�o Torrado E Mo�do', 6, 15, nil);
end;

procedure TFrmPedidoDetalhe.FormShow(Sender: TObject);
begin
      CarregarPedido;
end;

end.
