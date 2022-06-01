unit DataModule.Mercado;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DataSet.Serialize.Config, RESTRequest4D;

type
  TDmMercado = class(TDataModule)
    TabMercado: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ListarMercado(busca, ind_entrega, ind_retira: string);
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

     resp := TRequest.New.BaseURL('http://localhost:3000')
             .Resource('mercados')
             .DataSetAdapter(TabMercado)
             .AddParam('busca', busca)
             .AddParam('ind_entrega', ind_entrega)
             .AddParam('ind_retira', ind_retira)
             .Accept('application/json')
             .BasicAuthentication('99coders', '123456').Get;

     if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content);

end;

end.
