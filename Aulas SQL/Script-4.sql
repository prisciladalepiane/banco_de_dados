-- Script Aula 4

USE hospital;

-- Inserir campo na tabela "contatos_pacientes" para o tipo de contato.
ALTER TABLE contatos_pacientes ADD COLUMN id_tipo_contato TINYINT UNSIGNED;

-- Inserir chave estrangeira na tabela "contatos_pacientes", referenciando a tabela "tipos_contato".
ALTER TABLE contatos_pacientes
  ADD CONSTRAINT contatos_pacientes_id_tipo_contato_fk
  FOREIGN KEY (id_tipo_contato)
  REFERENCES tipos_contato (id)
    ON DELETE RESTRICT    -- Nao permite apagar
    ON UPDATE RESTRICT;   -- Nao permite update

-- Como est� o conte�do da tabela "contatos_pacientes"?
SELECT * FROM contatos_pacientes;

-- O campo "id_tipo_contato" est� com todos os valores nulos.
-- Como � poss�vel, se esse campo � uma chave estrangeira?
-- RESPOSTA: � poss�vel porque o campo da chave estrangeira aceita valores nulos.
-- NULL permite a quebra da integridade referencial.

-- Alterar o conte�do do campo "id_tipo_contato" para 3 ("E-mail").
UPDATE contatos_pacientes SET id_tipo_contato = 3 WHERE cpf_paciente = 76543210472;

-- Tentar excluir o tipo de contato = 3 "E-mail" da tabela de tipos de contato.
DELETE FROM tipos_contato WHERE id = 3;


-- -------------------------------------------------------------------------------------------------
-- DDL (Data Definition Language)
-- -------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------------
-- DML (Data Manipulation Language)
-- -------------------------------------------------------------------------------------------------
-- Inser��o sem especifica��o de campos (DEVE seguir a ordem da tabela).
INSERT INTO contatos_pacientes VALUES (98765432109, '+5512345678901', 1);

-- Inser��o com especifica��o de campos (PODE seguir a ordem da tabela ou assumir outra ordem qualquer).
INSERT INTO contatos_pacientes (cpf_paciente, contato, id_tipo_contato)
VALUES (76543210472, '+559876543210', 2);

-- Inser��o sem especifica��o de campos (DEVE seguir a ordem da tabela).
INSERT INTO tipos_contato VALUES (DEFAULT, 'Pager', 1);

-- -------------------------------------------------------------------------------------------------
-- DTL (Data Transaction Language)
-- -------------------------------------------------------------------------------------------------
START TRANSACTION; -- Come�a uma transa��o
  DELETE FROM contatos_pacientes;
  DELETE FROM tipos_contato;
  SELECT * FROM contatos_pacientes;
  SELECT * FROM tipos_contato;
ROLLBACK; -- Desfaz altera��es feitas apartir do START


START TRANSACTION;
  DELETE FROM contatos_pacientes;
  DELETE FROM tipos_contato;
  SELECT * FROM contatos_pacientes;
  SELECT * FROM tipos_contato;
COMMIT; -- Confirma transa��o








