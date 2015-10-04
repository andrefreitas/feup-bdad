-- Drop if exists
drop table funcionarioreparacao;
drop table funcionario;
drop table especialidade;
drop table pecamodelo;
drop table reparacaopeca;
drop table peca;
drop table reparacao;
drop table carro;
drop table cliente;
drop table codpostal;
drop table modelo;
drop table marca;

-- Tables creation
create table Marca(
  idMarca number(4),
  nome nvarchar2(30),
  constraint pk_Marca primary key (idMarca)
  );
  
create table Modelo(
  idModelo number(4),
  nome nvarchar2(30),
  idMarca number(4),
  constraint pk_Modelo primary key (idModelo),
  constraint fk_Modelo_idMarca foreign key (idMarca) references Marca(idMarca)
  );
  
create table CodPostal(
  codPostal1 number(4),
  localidade nvarchar2(30),
  constraint pk_codPostal primary key (codPostal1)
  );
  
create table Cliente(
  idCliente number(4),
  nome nvarchar2(30),
  morada nvarchar2(30),
  codPostal1 number(4),
  codPostal2 number(3),
  telefone number(9),
  constraint pk_Cliente primary key (idCliente),
  constraint fk_Cliente_codPostal1 foreign key (codPostal1) references CodPostal(codPostal1)
  );
    
create table Carro(
  idCarro number(4),
  matricula nvarchar2(10),
  idModelo number(4),
  idCliente number(4),
  constraint pk_Carro primary key (idCarro),
  constraint fk_Carro_idModelo foreign key (idModelo) references Modelo(idModelo),
  constraint fk_Carro_idCliente foreign key (idCliente) references Cliente(idCliente)
  );
  
create table Reparacao(
  idReparacao number(4),
  dataInicio date,
  dataFim date,
  idCliente number(4),
  idCarro number(4),
  constraint pk_Reparacao primary key (idReparacao),
  constraint fk_Reparacao_idCliente foreign key (idCliente) references Cliente(idCliente),
  constraint fk_Reparacao_idCarro foreign key (idCarro) references Carro(idCarro)
  );
  
create table Peca(
  idPeca number(4),
  codigo nvarchar2(30),
  designacao nvarchar2(30),
  custoUnitario number(10,2),
  quantidade number(5),
  constraint pk_Peca primary key (idPeca)
  );
  
create table ReparacaoPeca(
  idReparacao number(4),
  idPeca number(4),
  quantidade number(3),
  constraint pk_ReparacaoPeca primary key (idReparacao,idPeca),
  constraint fk_ReparacaoPeca_idReparacao foreign key (idReparacao) references Reparacao(idReparacao),
  constraint fk_ReparacaoPeca_idPeca foreign key (idPeca) references Peca(idPeca)
  );
  
create table PecaModelo(
  idPeca number(4),
  idModelo number(4),
  constraint pk_PecaModelo primary key (idPeca,idModelo),
  constraint fk_PecaModelo_idPeca foreign key (idPeca) references Peca(idPeca),
  constraint fk_PecaModelo_idModelo foreign key (idModelo) references Modelo(idModelo)
  );
  
create table Especialidade(
  idEspecialidade number(4),
  nome nvarchar2(30),
  custoHorario number(4,2),
  constraint pk_Especialidade primary key (idEspecialidade)
  );
  
create table Funcionario(
  idFuncionario number(4),
  nome nvarchar2(30),
  morada nvarchar2(30),
  codPostal1 number(4),
  codPostal2 number(3),
  telefone number(9),
  idEspecialidade number(4),
  constraint pk_Funcionario primary key (idFuncionario),
  constraint fk_Funcionario_codPostal1 foreign key (codPostal1) references CodPostal(codPostal1),
  constraint fk_Funcionario_idEspecialidade foreign key (idEspecialidade) references Especialidade(idEspecialidade)
  );
  
create table FuncionarioReparacao(
  idFuncionario number(4),
  idReparacao number(4),
  numHoras number(4,2),
  constraint pk_FuncionarioReparacao primary key (idFuncionario, idReparacao),
  constraint fk_FReparacao_idFuncionario foreign key (idFuncionario) references Funcionario(idFuncionario),
  constraint fk_FReparacao_idReparacao foreign key (idReparacao) references Reparacao(idReparacao)
  );