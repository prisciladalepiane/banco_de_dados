-- Script Aula 2

-- Comando enviado ao MySQL para utilizar o BD 'hospital'.
USE hospital;

-- Alteração da tabela 'pacientes' com a inclusão da chave primária para o campo 'cpf'.
-- CONSTRAINTS são restrições (ou regras) que o SGBD passa a verificar no momento da manutenção dos 
-- dados de uma tabela.
ALTER TABLE pacientes ADD CONSTRAINT pacientes_pk PRIMARY KEY (cpf);

-- Descreve a estrutura da tabela 'pacientes'.
DESCRIBE pacientes;

-- Obrigatoriedade da chave primária.
INSERT INTO pacientes VALUES (12345678901, 'Maria', '2000-01-02', 'Joana', 'Lucas');
-- Erro pois a chave primária é nula
INSERT INTO pacientes VALUES (NULL, 'Joana', '2010-03-05', 'Maria', 'Mário');


-- Erro por causa da duplicidade da chave primária.
INSERT INTO pacientes VALUES (12345678901, 'Joana', '2010-03-05', 'Maria', 'Mário');

-- Alteração da tabela 'pacientes' com a inclusão de uma chave opcional (ou secundária) para os campos
-- 'nome', 'data_nascimento' e 'nome_mae'.
-- UNIQUE indica ao SGBD não aceitar duplicidades para a combinação de valores desses campos.
ALTER TABLE pacientes ADD CONSTRAINT pacientes_sk1 UNIQUE (nome, data_nascimento, nome_mae);

-- Descreve a estrutura da tabela 'pacientes'.
DESCRIBE pacientes;

-- Testa a regra de duplicidade da chave opcional (secundária).
INSERT INTO pacientes VALUES (98765432109, 'Alex', '2003-05-02', 'Ana', 'Paulo');
INSERT INTO pacientes VALUES (87654321098, 'Alex', '2003-05-02', 'Ana', 'Paulo');
-- Obs: A combinação de nome, data_nascimento e nome pai, não pode ser igual

-- Refaz a chave secundária (agora, incluindo o nome do pai como componente).
ALTER TABLE pacientes DROP CONSTRAINT pacientes_sk1;
ALTER TABLE pacientes ADD CONSTRAINT pacientes_sk1 UNIQUE (nome, data_nascimento, nome_mae, nome_pai);

-- Testa a regra de duplicidade da chave opcional (secundária).
INSERT INTO pacientes VALUES (76543210472, 'Tamara', '2007-03-01', 'Jane', NULL);
INSERT INTO pacientes VALUES (53534677456, 'Tamara', '2007-03-01', 'Jane', NULL);
-- Obs: Não retornou erro porque o sql entende que um NULL é diferente de outro NULL

-- Cria tabela para o cadastro de contatos para os pacientes, com uma chave primária composta.
CREATE TABLE contatos_pacientes
(
  cpf_paciente BIGINT NOT NULL,
  contato VARCHAR(255) NOT NULL,
  CONSTRAINT contatos_pacientes_pk PRIMARY KEY (cpf_paciente, contato)
);

DESCRIBE contatos_pacientes;

-- Cria tabela para o cadastro de tipos de contato.
-- Nesta tabela está prevista uma chave substituta (surrogate key).
CREATE TABLE tipos_contato
(
  id TINYINT NOT NULL AUTO_INCREMENT,
  descricao VARCHAR(255) NOT NULL,
  maximo_por_pessoa TINYINT NOT NULL,
  CONSTRAINT tipos_contato_pk PRIMARY KEY (id)
);

DESCRIBE tipos_contato;

-- Testa o auto-incremento da chave primária.
INSERT INTO tipos_contato VALUES (NULL, 'Telefone móvel', 2);
INSERT INTO tipos_contato VALUES (NULL, 'Telefone fixo', 1);
INSERT INTO tipos_contato VALUES (NULL, 'E-mail', 2);

SELECT * FROM tipos_contato 

