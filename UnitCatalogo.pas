unit UnitCatalogo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, FMX.ListBox;

type
  TFrmCatalogo = class(TForm)
    LytToolbar: TLayout;
    LblTitulo: TLabel;
    ImgVoltar: TImage;
    ImgCarrinho: TImage;
    LtyEndereco: TLayout;
    LblEndereco: TLabel;
    Image3: TImage;
    LblTaxa: TLabel;
    Image4: TImage;
    LblPreco: TLabel;
    LytPesquisa: TLayout;
    RectPesquisa: TRectangle;
    EdtBusca: TEdit;
    Image5: TImage;
    BtnBusca: TButton;
    LtbCategoria: TListBox;
    TbiAlimentos: TListBoxItem;
    TbiBebidas: TListBoxItem;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Label2: TLabel;
    Rectangle2: TRectangle;
    LtbProdutos: TListBox;
    procedure FormShow(Sender: TObject);
    procedure LtbCategoriaItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure AddProduto(id_produto: integer; descricao, unidade: string;
      valor: double);
    procedure ListarProdutos;
    procedure ListarCategorias;
    procedure AddCategoria(id_categoria: integer; descricao: string);
    procedure SelecionarCategoria(item: TListBoxItem);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCatalogo: TFrmCatalogo;

implementation

{$R *.fmx}

uses UnitPrincipal, Frame.ProdutoCard;

procedure TFrmCatalogo.AddProduto(id_produto: integer;
                                 descricao, unidade: string;
                                 valor: double);
var
    item: TListBoxItem;
    frame: TFrameProdutCard;
begin
    item := TListBoxItem.Create(LtbProdutos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 175;
    item.Tag := id_produto;

    frame := TFrameProdutCard.Create(item);
    //frame.img Produto(
    frame.LblDescricao.Text := descricao;
    frame.LblPreco.Text := FormatFloat('R$ #,##0.00', valor);
    frame.LblUnidade.Text := unidade;

    item.AddObject(frame);

    LtbProdutos.AddObject(item);
end;

procedure TFrmCatalogo.ListarProdutos;
begin
    AddProduto(1,'Caf� Pil�o Torrado E Mo�do','500g',15);
    AddProduto(1,'Caf� Pil�o Torrado E Mo�do','500g',15);
    AddProduto(1,'Caf� Pil�o Torrado E Mo�do','500g',15);
    AddProduto(1,'Caf� Pil�o Torrado E Mo�do','500g',15);
end;

procedure TFrmCatalogo.LtbCategoriaItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    SelecionarCategoria(Item);
end;

procedure TFrmCatalogo.SelecionarCategoria(item: TListBoxItem);
 var
    x: Integer;
    item_loop: TListBoxItem;
    rect: TRectangle;
    lbl: TLabel;
 begin
    //Zerar os itens...
    for x := 0 to LtbCategoria.Items.Count - 1 do
    begin
      item_loop := LtbCategoria.ItemByIndex(x);

      rect := TRectangle(item_loop.Components[0]);
      rect.Fill.Color := $FFE2E2E2;

      lbl := TLabel(rect.Components[0]);
      lbl.FontColor := $FF3A3A3A;
    end;

    //Ajusta somente o item selecionado...
    rect := TRectangle(item.Components[0]);
    rect.Fill.Color := $FF64BA01;

    lbl := TLabel(rect.Components[0]);
    lbl.FontColor := $FFFFFFFF;

    //Salvar a categoria selecionada...
    LtbCategoria.Tag := item.Tag;
 end;

procedure TFrmCatalogo.AddCategoria(id_categoria: integer;
                                    descricao: string);
var
    item:TListBoxItem;
    rect:TRectangle;
    lbl:TLabel;
begin
    item := TListBoxItem.Create(LtbCategoria);
    item.Selectable := false;
    item.Text := '';
    item.Width := 100;
    item.Tag := id_categoria;

    rect := TRectangle.Create(item);
    rect.Cursor := crHandPoint;
    rect.HitTest := false;
    rect.Fill.Color := $FFE2E2E2;
    rect.Align := TAlignLayout.Client;
    rect.Margins.Top := 8;
    rect.Margins.Left := 8;
    rect.Margins.Right := 8;
    rect.Margins.Bottom := 8;
    rect.XRadius := 6;
    rect.YRadius := 6;
    rect.Stroke.Kind := TBrushKind.None;

    lbl := TLabel.Create(rect);
    lbl.Align := TAlignLayout.Client;
    lbl.Text := descricao;
    lbl.TextSettings.HorzAlign := TTextAlign.Center;
    lbl.TextSettings.VertAlign := TTextAlign.Center;
    lbl.StyledSettings := lbl.StyledSettings - [TStyledSetting.Size,
                                                TStyledSetting.FontColor,
                                                TStyledSetting.Style,
                                                TStyledSetting.Other];
    lbl.Font.Size := 13;
    lbl.FontColor := $FF3A3A3A;

    rect.AddObject(lbl);
    item.AddObject(rect);
    LtbCategoria.AddObject(item);
end;

procedure TFrmCatalogo.ListarCategorias;
begin
    LtbCategoria.Items.Clear;

    AddCategoria(0, 'Alimentos');
    AddCategoria(1, 'Bebidas');
    AddCategoria(2, 'Limpeza');
    AddCategoria(3, 'Eletr�nicos');
end;

procedure TFrmCatalogo.FormShow(Sender: TObject);
begin
   ListarCategorias;
   ListarProdutos;
end;

end.
