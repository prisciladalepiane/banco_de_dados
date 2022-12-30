-- Script Aula 5

USE hospital;

-- -------------------------------------------------------------------------------------------------
-- DTL (Data Transaction Language)
-- -------------------------------------------------------------------------------------------------
START TRANSACTION;
  DELETE FROM contatos_pacientes;
  DELETE FROM tipos_contato;
  SELECT * FROM contatos_pacientes;
  SELECT * FROM tipos_contato;
ROLLBACK;

START TRANSACTION;
  DELETE FROM contatos_pacientes;
  DELETE FROM tipos_contato;
  SELECT * FROM contatos_pacientes;
  SELECT * FROM tipos_contato;
COMMIT;

-- -------------------------------------------------------------------------------------------------
-- DQL (Data Query Language)
-- -------------------------------------------------------------------------------------------------
-- Uso de '*' como curinga (significando 'todos os campos').
-- ATEN��O: avaliar a real necessidade de usar esse tipo de comando por motivos de desempenho e
-- consumo de recursos (acesso a disco, rede).
SELECT * FROM pacientes;

-- Especifica��o de campos e inclus�o de filtros (cl�usula WHERE).
-- ATEN��O: observar quais s�o os operadores suportados pelos tipos de dados dos campos
-- utilizados nos filtros.
SELECT nome, data_nascimento FROM pacientes WHERE data_nascimento > '2007-01-01';
SELECT nome, data_nascimento FROM pacientes WHERE data_nascimento BETWEEN '2007-01-01' AND '2007-12-31';

-- Pesquisas utilizando padr�es (comumente em campos textuais).
SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE 'An%';
SELECT nome, nome_mae FROM pacientes WHERE REGEXP_LIKE(nome_mae, '^An'); 

SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE '%ne';
SELECT nome, nome_mae FROM pacientes WHERE REGEXP_LIKE(nome_mae, 'ne$');

SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE '%n%';
SELECT nome, nome_mae FROM pacientes WHERE REGEXP_LIKE(nome_mae, 'n');

SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE 'J%e';
SELECT nome, nome_mae FROM pacientes WHERE REGEXP_LIKE(nome_mae, '^J.*e$');

-- Pesquisas utilizando NULL.
-- Forma incorreta utilizando operadores de igualdade e diferen�a:
SELECT nome, nome_pai FROM pacientes WHERE nome_pai = NULL;
SELECT nome, nome_pai FROM pacientes WHERE nome_pai != NULL;

-- Forma correta utilizando IS NULL e IS NOT NULL:
SELECT nome, nome_pai FROM pacientes WHERE nome_pai IS NULL;
SELECT nome, nome_pai FROM pacientes WHERE nome_pai IS NOT NULL;


-- -------------------------------------------------------------------------------------------------
-- Produto cartesiano
-- -------------------------------------------------------------------------------------------------
-- Reinserir os dados nas tabelas.
INSERT INTO tipos_contato VALUES (1, 'Telefone m�vel', 2);
INSERT INTO tipos_contato VALUES (2, 'Telefone fixo', 1);
INSERT INTO tipos_contato VALUES (3, 'E-mail', 2);
INSERT INTO tipos_contato VALUES (5, 'Facebook', 1);
INSERT INTO tipos_contato VALUES (6, 'Instagram', 1);
INSERT INTO tipos_contato VALUES (7, 'Twitter', 1);
INSERT INTO contatos_pacientes VALUES (53534677456, 'tamara@tamara.com.br', 3);
INSERT INTO contatos_pacientes VALUES (98765432109, 'alex@alex.com.br', 3);

-- Relembrar opera��es matem�ticas: multiplica��o como sequ�ncia de somas,
-- divis�o como sequ�ncia de subtra��es.
SELECT * FROM pacientes, contatos_pacientes;
SELECT * FROM pacientes, contatos_pacientes, tipos_contato;

-- Produto cartesiano com condi��es (PK X FK)
SELECT *
	FROM pacientes, contatos_pacientes 
	WHERE pacientes.cpf = contatos_pacientes.cpf_paciente;

-- Produto cartesiano com condi��es + apelidos (alias) (chave prim�ria x chave estrangeira).
SELECT *
  FROM pacientes AS p, contatos_pacientes AS cp, tipos_contato AS tc
 WHERE p.cpf = cp.cpf_paciente
   AND cp.id_tipo_contato = tc.id;

-- INCORRETO: produto cartesiano com condi��es (outros campos).
SELECT *
  FROM pacientes AS p, contatos_pacientes AS cp
 WHERE p.nome = cp.contato;
