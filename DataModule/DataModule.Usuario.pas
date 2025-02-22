unit DataModule.Usuario;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DataSet.Serialize.Config, RESTRequest4D, System.JSON, uConsts,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.FMXUI.Wait, System.IOUtils, FireDAC.DApt,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite;

type
  TDmUsuario = class(TDataModule)
    TabUsuario: TFDMemTable;
    conn: TFDConnection;
    QryGeral: TFDQuery;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    QryUsuario: TFDQuery;
    TabPedido: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure connBeforeConnect(Sender: TObject);
    procedure connAfterConnect(Sender: TObject);
  private

    { Private declarations }
  public
    procedure Login(email, senha: string);
    procedure CriarConta(nome, email, senha, endereco, bairro,
                         cidade, uf, cep: string);
    procedure SalvarUsuarioLocal(id_usuario : integer; email,
                                 nome, endereco, bairro,
                                 cidade, uf,cep: string);
    procedure ListarUsuarioLocal;
    procedure Logout;
    procedure ListarPedido(id_usuario: integer);
    procedure ListarUsuarioId(id_usuario: integer);
    procedure EditarUsuario(id_usuario: integer; nome, email, senha, endereco,
                            bairro, cidade, uf, cep: string);
    function JsonPedido(id_pedido: integer): TJsonObject;
    { Public declarations }
  end;

var
  DmUsuario: TDmUsuario;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmUsuario.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  conn.Connected := true;
end;

procedure TDmUsuario.Login(email, senha : string);
var
  resp: Iresponse;
  json: TJSONObject;
begin
   try
     json := TJSONObject.Create;
     json.AddPair('email', email);
     json.AddPair('senha', senha);

     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('usuarios/login')
             .DataSetAdapter(TabUsuario)
             .AddBody(json.ToJSON)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Post;

     if (resp.StatusCode = 401) then
      raise Exception.Create('Email ou senha inv�lida!')
     else if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content);

   finally
     json.DisposeOf;
   end;
end;

procedure TDmUsuario.connAfterConnect(Sender: TObject);
begin
  conn.ExecSQL('CREATE TABLE IF NOT EXISTS '+
               'TAB_USUARIO(ID_USUARIO INTEGER NOT NULL PRIMARY KEY, '+
               'EMAIL VARCHAR(100), NOME VARCHAR(100), '+
               'ENDERECO VACHAR(100), BAIRRO VACHAR(100), CIDADE VACHAR(100), '+
               'UF VACHAR(100), CEP VACHAR(100))');
  conn.ExecSQL('CREATE TABLE IF NOT EXISTS '+
               'TAB_CARRINHO(ID_MERCADO INTEGER NOT NULL PRIMARY KEY, NOME_MERCADO VARCHAR(100), '+
               'ENDERECO_MERCADO VARCHAR(100), TAXA_ENTREGA DECIMAL(9,2))');
  conn.ExecSQL('CREATE TABLE IF NOT EXISTS '+
               'TAB_CARRINHO_ITEM(ID_PRODUTO INTEGER, URL_FOTO VACHAR, '+
               'NOME_PRODUTO VARCHAR(100), UNIDADE VARCHAR(100), '+
               'QTD DECIMAL(9,2), VALOR_UNITARIO DECIMAL(9,2), VALOR_TOTAL DECIMAL(9,2))');
end;

procedure TDmUsuario.connBeforeConnect(Sender: TObject);
begin
  conn.DriverName := 'SQLite';

  {$IFDEF MSWINDOWS}
  conn.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco.db';
  {$ELSE}
  conn.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
  {$ENDIF}
end;

procedure TDmUsuario.CriarConta(nome, email, senha, endereco, bairro,
                                 cidade, uf, cep : string);
var
  resp: Iresponse;
  json: TJSONObject;
begin
   try
     json := TJSONObject.Create;
     json.AddPair('nome', nome);
     json.AddPair('email', email);
     json.AddPair('senha', senha);
     json.AddPair('endereco', endereco);
     json.AddPair('bairro', bairro);
     json.AddPair('cidade', cidade);
     json.AddPair('uf', uf);
     json.AddPair('cep', cep);

     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('usuarios/cadastro')
             .DataSetAdapter(TabUsuario)
             .AddBody(json.ToJSON)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Post;

     if (resp.StatusCode = 401) then
      raise Exception.Create('Usuario n�o autorizado!')
     else if (resp.StatusCode <> 201) then
      raise Exception.Create(resp.Content);

   finally
     json.DisposeOf;
   end;
end;

procedure TDmUsuario.ListarPedido(id_usuario: integer);
var
  resp: Iresponse;
  json: TJSONObject;
begin
     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('pedidos')
             .AddParam('id_usuario', id_usuario.ToString)
             .DataSetAdapter(TabPedido)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Get;

     if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content);
end;

function TDmUsuario.JsonPedido(id_pedido: integer): TJsonObject;
var
  resp: Iresponse;
  json: TJSONObject;
begin
     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('pedidos')
             .ResourceSuffix(id_pedido.ToString)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Get;

     if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content)
     else
      Result := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(resp.Content), 0) as TJsonObject;
end;

procedure TDmUsuario.SalvarUsuarioLocal(id_usuario : integer; email,
                                        nome, endereco,
                                        bairro, cidade, uf,
                                        cep: string);
begin
  with QryUsuario do
  begin
    Active := false;
    SQL.Clear;
    SQL.Add('INSERT OR REPLACE INTO TAB_USUARIO('+
            'ID_USUARIO, EMAIL, NOME, ENDERECO, BAIRRO, CIDADE, '+
            'UF, CEP) VALUES(:ID_USUARIO, :EMAIL, :NOME, :ENDERECO, '+
            ':BAIRRO, :CIDADE, :UF, :CEP)');

    ParamByName('ID_USUARIO').Value := id_usuario;
    ParamByName('EMAIL').Value := email;
    ParamByName('NOME').Value := nome;
    ParamByName('ENDERECO').Value := endereco;
    ParamByName('BAIRRO').Value := bairro;
    ParamByName('CIDADE').Value := cidade;
    ParamByName('UF').Value := uf;
    ParamByName('CEP').Value := cep;

    ExecSQL;
  end;
end;

procedure TDmUsuario.ListarUsuarioLocal;
begin
  with QryUsuario do
  begin
    Active := false;
    SQL.Clear;
    SQL.Add('SELECT * FROM TAB_USUARIO');
    Active := true;
  end;
end;

procedure TDmUsuario.Logout;
begin
  with QryGeral do
  begin
    Active := false;
    SQL.Clear;
    SQL.Add('DELETE FROM TAB_USUARIO');
    ExecSQl;

    Active := false;
    SQL.Clear;
    SQL.Add('DELETE FROM TAB_CARRINHO');
    ExecSQl;

    Active := false;
    SQL.Clear;
    SQL.Add('DELETE FROM TAB_CARRINHO_ITEM');
    ExecSQl;
  end;
end;

procedure TDmUsuario.ListarUsuarioId(id_usuario: integer);
var
  resp: Iresponse;
begin
     TabUsuario.FieldDefs.Clear;

     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('usuarios')
             .ResourceSuffix(id_usuario.ToString)
             .DataSetAdapter(TabUsuario)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Get;

     if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content);
end;

procedure TDmUsuario.EditarUsuario(id_usuario: integer;
                                   nome, email, senha, endereco,
                                   bairro, cidade, uf, cep: string);
var
  resp: Iresponse;
  json: TJSONObject;
begin
  try
     json := TJSONObject.Create;
     json.AddPair('nome', nome);
     json.AddPair('email', email);
     json.AddPair('senha', senha);
     json.AddPair('endereco', endereco);
     json.AddPair('bairro', bairro);
     json.AddPair('cidade', cidade);
     json.AddPair('uf', uf);
     json.AddPair('cep', cep);

     resp := TRequest.New.BaseURL(BASE_URL)
             .Resource('usuarios')
             .ResourceSuffix(id_usuario.ToString)
             .DataSetAdapter(TabUsuario)
             .AddBody(json.ToJSON)
             .Accept('application/json')
             .BasicAuthentication(USER_NAME, PASSWORD).Put;

     if (resp.StatusCode <> 200) then
      raise Exception.Create(resp.Content);
  finally
     json.DisposeOf;
  end;
     
end;

end.
