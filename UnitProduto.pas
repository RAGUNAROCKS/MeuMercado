unit UnitProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, uLoading, uFunctions,
  FMX.DialogService;

type
  TFrmProduto = class(TForm)
    LytToolbar: TLayout;
    ImgVoltar: TImage;
    LytFoto: TLayout;
    ImgFoto: TImage;
    LblNome: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    LblUnidade: TLabel;
    LblValor: TLabel;
    LblDescricao: TLabel;
    RectRodap�: TRectangle;
    Layout3: TLayout;
    ImgMais: TImage;
    ImgMenos: TImage;
    LblQtd: TLabel;
    BtnAdicionar: TButton;
    LytFundo: TLayout;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImgVoltarClick(Sender: TObject);
    procedure ImgMenosClick(Sender: TObject);
    procedure BtnAdicionarClick(Sender: TObject);
  private
    FId_Produto: integer;
    FId_Mercado: integer;
    FEndereco: string;
    FNome_mercado: string;
    FTaxa_entrega: double;
    procedure CarregarDados;
    procedure ThreadDadosTerminate(Sender: TObject);
    procedure Opacity(op: integer);
    procedure Qtd(valor: integer);
    { Private declarations }
  public
    property Id_produto: integer read FId_Produto write FId_Produto;
    property Id_mercado: integer read FId_Mercado write FId_Mercado;
    property Nome_mercado: string read FNome_mercado write FNome_mercado;
    property Endereco: string read FEndereco write FEndereco;
    property Taxa_entrega: double read FTaxa_entrega write FTaxa_entrega;
    { Public declarations }
  end;

var
  FrmProduto: TFrmProduto;

implementation

{$R *.fmx}

uses UnitPrincipal, DataModule.Mercado;

procedure TFrmProduto.Qtd(valor: integer);
begin
   try
      if valor = 0 then
        LblQtd.Tag := 1
      else
        LblQtd.Tag := LblQtd.Tag + valor;
      if LblQtd.Tag <= 0 then LblQtd.Tag := 1;
   except
      lblQtd.Tag := 1;
   end;

   LblQtd.Text := FormatFloat('00', LblQtd.Tag);
end;

procedure TFrmProduto.FormResize(Sender: TObject);
begin
    if (FrmProduto.Width > 400) then
    begin
      LytFundo.Align := TAlignLayout.Center;
      BtnAdicionar.Align := TAlignLayout.Right;
    end
    else
    begin
      LytFundo.Align := TAlignLayout.Client;
      BtnAdicionar.Align := TAlignLayout.Client;
    end
end;

procedure TFrmProduto.Opacity(op : integer);
begin
  ImgFoto.Opacity := op;
  LblNome.Opacity := op;
  LblUnidade.Opacity := op;
  LblValor.Opacity := op;
  LblDescricao.Opacity := op;
end;

procedure TFrmProduto.BtnAdicionarClick(Sender: TObject);
begin
    //Consiste em
    if DmMercado.ExistePedidoLocal(Id_mercado) then
    begin
       TDialogService.MessageDialog('Voc� s� pode adicionar itens de um mercado por vez. Deseja esvaziar a sacola e adicionar esse item?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
         procedure(const AResult: TModalResult)
         begin
            if AResult = mrYes then
            begin
                DmMercado.LimparCarrinhoLocal;
                DmMercado.AdicionarCarrinhoLocal(Id_mercado, Nome_mercado, Endereco, Taxa_entrega);
                DmMercado.AdicionarItemCarrinhoLocal(Id_produto, ImgFoto.TagString, LblNome.Text,
                                                     LblUnidade.Text, LblQtd.Tag, LblValor.TagFloat);
            end;
          end);
    end
    else
    begin
        DmMercado.AdicionarCarrinhoLocal(Id_mercado, Nome_mercado, Endereco, Taxa_entrega);
        DmMercado.AdicionarItemCarrinhoLocal(Id_produto, ImgFoto.TagString, LblNome.Text, LblUnidade.Text,
                                        LblQtd.Tag, LblValor.TagFloat);
    end;
    close;
end;

procedure TFrmProduto.CarregarDados;
var
  t : TThread;
begin
  Qtd(0);
  Opacity(0);
  TLoading.Show(FrmProduto, '');
  t := TThread.CreateAnonymousThread(procedure
  begin
     sleep(2000);

     //Listar dados do produto...
     DmMercado.ListarProdutoId(Id_produto);

     with DmMercado.TabProdDetalhe do
     begin
        TThread.Synchronize(TThread.CurrentThread, procedure
        begin
           LblNome.Text := fieldbyname('nome').asstring;
           LblUnidade.Text := fieldbyname('unidade').asstring;
           LblValor.Text := FormatFloat('R$#,##0.00', fieldbyname('preco').asfloat);
           LblValor.TagFloat := fieldbyname('preco').asfloat;
           LblDescricao.Text := fieldbyname('descricao').asstring;

        end);
        ImgFoto.TagString := fieldbyname('url_foto').asstring;
        LoadImageFromURL(ImgFoto.Bitmap, fieldbyname('url_foto').asstring);
     end;
  end);

  t.OnTerminate := ThreadDadosTerminate;
  t.Start;
end;

procedure TFrmProduto.FormShow(Sender: TObject);
begin
    CarregarDados;
end;

procedure TFrmProduto.ImgMenosClick(Sender: TObject);
begin
  Qtd(TImage(Sender).Tag);
end;

procedure TFrmProduto.ImgVoltarClick(Sender: TObject);
begin
  close;
end;

procedure TFrmProduto.ThreadDadosTerminate(Sender: TObject);
begin
   TLoading.Hide;

   if Sender is TThread then
   begin
     if Assigned(TThread(Sender).FatalException) then
     begin
      showmessage(Exception(TThread(Sender).FatalException).Message);
      exit;
     end;
   end;

   Opacity(1);
end;

end.
