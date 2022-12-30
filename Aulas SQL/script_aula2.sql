CREATE DATABASE cadastro;

USE cadastro;

DROP TABLE pacientes;

-- Cria a tabela pacientes
CREATE TABLE pacientes
(
	cpf				BIGINT UNSIGNED NOT NULL,
	nome 			VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL,
	nome_mae		VARCHAR(255) NOT NULL,
	nome_pai 		VARCHAR(255)
);

DESCRIBE pacientes

-- Alterar tabela pacientes com inclusão  da chave primaria para o campo 'cpf'.
-- CONSTRAINS são restrições (ou regras) que o SGBD passa a verificar no momento da 
-- manutenção dos dados de uma tabela.
ALTER TABLE pacientes
ADD CONSTRAINT pacientes_pk PRIMARY KEY (cpf);

-- Testa a regra da obrigatoriedade da chave primaria
INSERT INTO pacientes 
VALUES (12345678912, 'Maria', '2000-01-02', 'Joana', 'Lucas');

SELECT * FROM pacientes

-- Nao insere NULL 
INSERT INTO pacientes 
VALUES (NULL, 'Joana', '2000-01-02', 'Joana', 'Lucas')

-- Não repete o numero da primary key
INSERT INTO pacientes 
VALUES (12345678912, 'Maria', '2000-01-02', 'Joana', 'Lucas')

-- Alteração na tabela 'pacientes' com a inclusão de uma chave opcional (secundaria)
-- 'nome', 'data_nascimento', 'nome_mae'
-- UNIQUE indica que o SGBD não aceita duplicidades para a combinação de valores 
ALTER TABLE pacientes 
ADD CONSTRAINT pacientes_sk1 UNIQUE (nome, data_nascimento, nome_mae);

DESCRIBE pacientes

-- Refaz a chave secundaria, agora incluindo o pai
ALTER TABLE pacientes DROP CONSTRAINT pacientes_sk1;
ALTER TABLE pacientes ADD CONSTRAINT pacientes_sk1 UNIQUE (nome, data_nascimento, nome_mae, nome_pai);

INSERT INTO pacientes VALUES (1321313464, 'Priscila', '1994-11-11', 'Jussara', NULL);
INSERT INTO pacientes VALUES (1321313964, 'Priscila', '1994-11-11', 'Jussara', NULL);

-- NULL = NULL -> FALSO














