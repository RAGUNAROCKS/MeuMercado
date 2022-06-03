unit DataModule.Mercado;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DataSet.Serialize.Config, RESTRequest4D, uConsts;

type
  TDmMercado = class(TDataModule)
    TabMercado: TFDMemTable;
    TabCategoria: TFDMemTable;
    TabProduto: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private

    { Private declarations }
  public
    procedure ListarMercado(busca, ind_entrega, ind_retira: string);
    procedure ListarMercadoId(id_mercado: integer);
    procedure ListarCategoria(id_mercado: integer);
    procedure ListarProduto(id_mercado, id_categoria: integer);
    { Public declarations }
  end;

var
  DmMercado: TDmMercado;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmMercado.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
end;

procedure TDmMercado.ListarMercado(busca, ind_entrega, ind_retira : string);
var
  resp: Iresponse;
begin

     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('mercados')
             .DataSetAdapter(TabMercado)
             .AddParam('busca', busca)
             .AddParam('ind_entrega', ind_entrega)
             .AddParam('ind_retira', ind_retira)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Get;

     if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content);

end;

procedure TDmMercado.ListarMercadoId(id_mercado : integer);
var
  resp: Iresponse;
begin

     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('mercados')
             .ResourceSuffix(id_mercado.ToString)
             .DataSetAdapter(TabMercado)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Get;

     if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content);

end;

procedure TDmMercado.ListarCategoria(id_mercado : integer);
var
  resp: Iresponse;
begin

     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('mercados')
             .ResourceSuffix(id_mercado.ToString + '/categorias')
             .DataSetAdapter(TabCategoria)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Get;

     if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content);

end;

procedure TDmMercado.ListarProduto(id_mercado, id_categoria : integer);
var
  resp: Iresponse;
begin

     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('mercados')
             .ResourceSuffix(id_mercado.ToString + '/produtos')
             .AddParam('id_categoria', id_categoria.ToString)
             .DataSetAdapter(TabProduto)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Get;

     if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content);

end;

end.
