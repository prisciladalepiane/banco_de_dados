-- Script Aula 3

USE hospital;


-- Descreve a estrutura da tabela 'contatos_pacientes'.
DESCRIBE contatos_pacientes;

DROP TABLE tipos_contato; 

-- Cria tabela para o cadastro de tipos de contato.
-- Nesta tabela está prevista uma chave substituta (surrogate key).
CREATE TABLE tipos_contato
(
  id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  descricao VARCHAR(255) NOT NULL,
  maximo_por_pessoa TINYINT NOT NULL,
  CONSTRAINT tipos_contato_pk PRIMARY KEY (id)
);

-- Descreve a estrutura da tabela 'tipos_contato'.
DESCRIBE tipos_contato;

-- Testa o auto-incremento da chave primária.
INSERT INTO tipos_contato VALUES (NULL, 'Telefone móvel', 2);
INSERT INTO tipos_contato VALUES (NULL, 'Telefone fixo', 1);
INSERT INTO tipos_contato VALUES (NULL, 'E-mail', 2);

-- Informa um valor para o campo de auto-incremento.
INSERT INTO tipos_contato VALUES (5, 'Facebook', 1);

-- Os valores seguintes gerados pelo SGBD consideram o valor informado
-- (e geram uma lacuna na sequência de chaves primárias).
INSERT INTO tipos_contato VALUES (NULL, 'Instagram', 1);
INSERT INTO tipos_contato VALUES (NULL, 'Twitter', 1);

SELECT * FROM tipos_contato 

-- ---------------------------------------------------------------------------
-- CHAVES ESTRANGEIRAS
-- ---------------------------------------------------------------------------

-- Cria chave estrangeira na tabela "contatos_pacientes".
-- A chave criada irá apontar para o campo "cpf" da tabela "paciente"
-- Opções válidas para os valores "ON DELETE" e "ON UPDATE":
-- RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT .
ALTER TABLE contatos_pacientes
  ADD CONSTRAINT contatos_pacientes_cpf_paciente_fk
  FOREIGN KEY (cpf_paciente)
  REFERENCES pacientes (cpf)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
 -- Ao usar o DELETE/UPDATE CASCADE quando um valor é atualizado/apagado na tabela pai, também é apagado no filho
   
 DESCRIBE contatos_pacientes
    
-- Testando se a chave estrangeira funciona.
INSERT INTO contatos_pacientes VALUES (000000000019, 'teste@teste.com.br');

-- Inserindo chaves estrangeiras que existem na tabela referenciada.
INSERT INTO contatos_pacientes VALUES (12345678901, 'maria@maria.com.br');
INSERT INTO contatos_pacientes VALUES (76543210472, 'tamara@tamara.com.br');

SELECT * FROM contatos_pacientes 

-- Alterando o CPF de um paciente que possui um contato.
-- O que acontece com o CPF na tabela de contatos?
UPDATE pacientes SET cpf = 12345678902 WHERE cpf = 12345678901;

-- Excluindo um paciente que possui um contato.
-- O que acontece com o contato?
DELETE FROM pacientes WHERE cpf = 12345678902;

