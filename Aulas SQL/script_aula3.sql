-- Chave primária composta
CREATE TABLE contato_pacientes
(
	cpf_paciente BIGINT NOT NULL,
	contato VARCHAR(255) NOT NULL,
	CONSTRAINT contatos_pacientes_pk PRIMARY KEY (cpf_paciente, contato) 
);

DESCRIBE contato_pacientes;

-- Exemplo surrogate key

CREATE TABLE tipos_contato
(
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
	descricao VARCHAR(255) NOT NULL,
	maximo_por_pessoa TINYINT NOT NULL,
	CONSTRAINT tipos_contato_pk PRIMARY KEY (id)
);

-- Testar o auto incremento
INSERT INTO tipos_contato VALUES (NULL, 'Telefone Móvel', 2);
INSERT INTO tipos_contato VALUES (NULL, 'Telefone Fixo', 1);
INSERT INTO tipos_contato VALUES (NULL, 'Email', 2);

INSERT INTO tipos_contato VALUES (5, 'Facebook', 1);

INSERT INTO tipos_contato VALUES (NULL, 'Twitter', 2);
INSERT INTO tipos_contato VALUES (NULL, 'Instagram', 1);


SELECT * FROM tipos_contato


-------------------------------------------------------------------
--                 CHAVES ESTRANGEIRAS
-------------------------------------------------------------------


-- Cria chaveira estrangeira na tabela "contatos_paciente"
-- A chave criada irá apontar para o campo "cpf" da tabela "paciente"

ALTER TABLE contatos_pacientes
	ADD CONSTRAINT (cpf_paciente)
	REFERENCES pacientes (cpf)
	
	
select * from pacientes










