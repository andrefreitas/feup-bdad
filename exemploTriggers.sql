/** Exemplo de Triggers **/

-- Criação da Tabela pessoa
create table pessoa(
  idPessoa number(10) primary key,
  nome nvarchar2(30),
  idade number(10)
  );

-- Criação da Tabela de logs
  CREATE TABLE LOGSAUDIT(	
    IDLOG NUMBER(10,0), 
    MSG NVARCHAR2(50)
   );


-- Gatilho
create or replace
trigger logsPessoa
after insert on pessoa
BEGIN
  insert into logsaudit(msg) values('Adicionado registo em pessoa');
END;

insert into pessoa (idpessoa, nome, idade) values(0,'joao',12);
insert into pessoa (idpessoa, nome, idade) values(1,'Marta',14);

-- Conferir
select * from logsaudit;
