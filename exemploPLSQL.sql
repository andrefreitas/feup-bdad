-- Criação da tabela pessoa
create table pessoa(
  idPessoa number(10) primary key,
  nome nvarchar2(30),
  idade number(10)
  );
  
-- Criação da Tabela de idades
create table idades(
  idade number(3)
  );
  
-- Inserção de dados
insert into  pessoa(idpessoa, nome, idade) values(10,'Carlos',20);
insert into  pessoa(idpessoa, nome, idade) values(11,'Laura',20);
insert into  pessoa(idpessoa, nome, idade) values(12,'Maria',22);
insert into  pessoa(idpessoa, nome, idade) values(13,'Nuno',24);

-- Criação do procedimento que preenche a tabela idades com todas as idades
CREATE OR REPLACE PROCEDURE
preencheidades AS
idade number(10);
cursor idades is (select idade from pessoa);
BEGIN
  open idades;
  loop
    fetch idades into idade;
    insert into idades(idade) values(idade);
    exit when idades%NOTFOUND;
  end loop;
  close idades;
END;

