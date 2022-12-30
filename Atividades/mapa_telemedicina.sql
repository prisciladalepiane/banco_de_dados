-- Criar database
CREATE DATABASE telemedicina;

-- Usar database telemedicina
USE telemedicina;

-- Criar as tabelas
CREATE TABLE pais (
  id SMALLINT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(200),
  PRIMARY KEY (id)
);

CREATE TABLE estado (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(200) NOT NULL,
  id_pais SMALLINT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_pais) REFERENCES pais(id)
);

CREATE TABLE cidade (
  id INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(200) NOT NULL,
  id_estado INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_estado) REFERENCES estado(id)
);

CREATE TABLE endereco (
  id INT NOT NULL AUTO_INCREMENT,
  logradouro VARCHAR(300) NOT NULL,
  numero INT,
  complemento VARCHAR(100),
  CEP CHAR(9),
  id_cidade INT NOT NULL,
  id_estado INT NOT NULL,
  id_pais SMALLINT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_estado) REFERENCES estado(id),
  FOREIGN KEY (id_pais) REFERENCES pais(id),
  FOREIGN KEY (id_cidade) REFERENCES cidade(id)
);

CREATE TABLE tipo_contato (
  id 		TINYINT NOT NULL AUTO_INCREMENT,
  nome_tipo VARCHAR(100),
  PRIMARY KEY (id)
);

CREATE TABLE contato (
  id 				INT NOT NULL AUTO_INCREMENT,
  id_tipo_contato 	TINYINT,
  contato 			VARCHAR(100),
  PRIMARY KEY (id),
  FOREIGN KEY (id_tipo_contato) REFERENCES tipo_contato(id)
);

CREATE TABLE usuario (
  id 			INT NOT NULL AUTO_INCREMENT,
  nome 			VARCHAR(200) NOT NULL,
  sexo 			CHAR,
  id_endereco 	INT NOT NULL,
  atualizacao	DATE,
  PRIMARY KEY (id)
);

CREATE TABLE usuario_contato (
  id INT NOT NULL AUTO_INCREMENT,
  id_contato INT NOT NULL,
  id_usuario INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id),
  FOREIGN KEY (id_contato) REFERENCES contato(id)
);


CREATE TABLE profissional (
  id 			INT NOT NULL AUTO_INCREMENT,
  id_usuario 	INT NOT NULL,
  numero_registro_profissional INT,
  PRIMARY KEY (id)
);


CREATE TABLE especialidade (
  id 					SMALLINT NOT NULL AUTO_INCREMENT,
  nome_especialidade 	VARCHAR(200) NOT NULL,
  PRIMARY KEY (id)
); 


CREATE TABLE profissional_especialidade (
  id 				INT NOT NULL AUTO_INCREMENT,
  id_profissional 	INT NOT NULL,
  id_especialidade 	SMALLINT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_profissional) REFERENCES profissional (id),
  FOREIGN KEY (id_especialidade) REFERENCES especialidade (id)
);


CREATE TABLE estabelecimento_saude (
  id 			INT NOT NULL AUTO_INCREMENT,
  nome_registro VARCHAR(100) NOT NULL,
  nome_fantasia VARCHAR(100),
  id_endereco 	INT NOT NULL,
  id_contato    INT NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE estabelecimento_saude
  ADD CONSTRAINT estabelecimento_endereco_fk
  	FOREIGN KEY (id_endereco)
  	REFERENCES endereco (id),
  ADD CONSTRAINT estabelecimento_contato_fk
  	FOREIGN KEY (id_contato)
  	REFERENCES contato (id);
  
CREATE TABLE usuario_estabelecimento_saude (
  id 				INT  	NOT NULL AUTO_INCREMENT,
  id_usuario 		INT 	NOT NULL,
  id_estabelecimento_saude INT NOT NULL,
  data_cadastro 	INT,
  PRIMARY KEY (id),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id),
  FOREIGN KEY (id_estabelecimento_saude) REFERENCES estabelecimento_saude(id)
);
  
CREATE TABLE permicao_estabelecimento (
  id 				 INT NOT NULL AUTO_INCREMENT,
  id_profissional 	 INT NOT NULL,
  id_estabelecimento INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (id_estabelecimento) REFERENCES estabelecimento_saude(id),
  FOREIGN KEY (id_profissional)    REFERENCES profissional(id)
);


CREATE TABLE laudo (
  id 			  INT NOT NULL AUTO_INCREMENT,
  data_laudo 	  DATE NOT NULL,
  id_profissional INT NOT NULL,
  observacao 	  VARCHAR(600),
  tratamento      VARCHAR(600),
  PRIMARY KEY (id),
  FOREIGN KEY (id_profissional) REFERENCES profissional(id)
);


CREATE TABLE exame (
  id 			 INT NOT NULL AUTO_INCREMENT,
  id_usuario 	 INT NOT NULL,
  id_tipo_exame  INT NOT NULL,
  data_exame 	 DATE NOT NULL,
  observacao 	 VARCHAR(300),
  primeiro_laudo INT,
  segundo_laudo  INT,
  PRIMARY KEY (id),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

ALTER TABLE exame
  ADD CONSTRAINT exame_primeiro_laudo_fk
  	FOREIGN KEY (primeiro_laudo)
  	REFERENCES laudo (id),
  ADD CONSTRAINT exame_segundo_laudo_fk
  	FOREIGN KEY (segundo_laudo)
  	REFERENCES laudo (id);
  
CREATE TABLE tipo_exame (
  id 			INT NOT NULL AUTO_INCREMENT,
  tipo_exame 	VARCHAR(100) NOT NULL,
  id_preco 		INT NOT NULL,
  PRIMARY KEY (id)
);

ALTER TABLE exame
  ADD CONSTRAINT exame_tipo_exame_fk
  	FOREIGN KEY (id_tipo_exame)
  	REFERENCES tipo_exame (id);

CREATE TABLE preco (
  id 			INT NOT NULL,
  valor_preco 	FLOAT NOT NULL,
  data_inicial 	DATE,
  data_validade DATE,
  PRIMARY KEY (id)
);

ALTER TABLE tipo_exame
  ADD CONSTRAINT preco_tipo_exame_fk
  	FOREIGN KEY (id_preco)
  	REFERENCES preco (id);



