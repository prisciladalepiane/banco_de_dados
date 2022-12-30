-- Atividade 3: Criação do banco físico utilizando DDL

CREATE DATABASE escola;

USE escola;

START TRANSACTION;

-- Criar tabela 'instrutor'
CREATE TABLE instrutor
(
	idinstrutor INT NOT NULL AUTO_INCREMENT,
	RG INT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	nascimento DATE,
	titulacao INT,
	CONSTRAINT instrutor_pk PRIMARY KEY (idinstrutor)
)

DESCRIBE instrutor;

-- Criar tabela telefone_instrutor
CREATE TABLE telefone_instrutor
(
	idtelefone INT AUTO_INCREMENT,
	numero INT NOT NULL,
	tipo VARCHAR(45),
	instrutor_idinstrutor INT NOT NULL,
	CONSTRAINT telefone_instrutor_pk PRIMARY KEY(idtelefone),
	CONSTRAINT telefone_instrutor_idinstrutor_fk
	FOREIGN KEY (instrutor_idinstrutor)
	REFERENCES instrutor (idinstrutor)
);

DESCRIBE telefone_instrutor;

-- Criar tabela atividades
CREATE TABLE atividade
(
	idatividade INT AUTO_INCREMENT,
	nome VARCHAR(100) NOT NULL,
	CONSTRAINT atividade_pk PRIMARY KEY (idatividade)
);

DESCRIBE atividade;

-- Criar tabela turma
CREATE TABLE turma
(
	idturma INT AUTO_INCREMENT,
	horario TIME NOT NULL,
	duracao INT NOT NULL,
	dataInicio DATE NOT NULL,
	dataFim DATE NOT NULL,
	atividade_idatividade INT,
	instrutor_idinstrutor INT,
	CONSTRAINT turma_pk PRIMARY KEY (idturma),
	CONSTRAINT turma_idatividade_fk
		FOREIGN KEY (atividade_idatividade)
		REFERENCES atividade (idatividade),
	CONSTRAINT turma_idinstrutor_fk
		FOREIGN KEY (instrutor_idinstrutor)
		REFERENCES instrutor (idinstrutor)
);

DESCRIBE turma;

-- Criar tabela aluno
CREATE TABLE aluno
(
	codMatricula INT,
	turma_idturma INT,
	dataMatricula DATE NOT NULL,
	nome VARCHAR(45) NOT NULL, 
	endereco TEXT, 
	telefone INT,
	dataNascimento DATE, 
	altura FLOAT,
	peso INT,
	CONSTRAINT aluno_pk PRIMARY KEY (codMatricula),
	CONSTRAINT aluno_idturma_fk FOREIGN KEY (turma_idturma)
		REFERENCES turma (idturma)
);


DESCRIBE aluno;

-- Criar tabela matricula
CREATE TABLE matricula
(
	aluno_codMatricula INT NOT NULL,
	turma_idturma INT NOT NULL,
	CONSTRAINT matricula_aluno_turma_pk
		PRIMARY KEY (aluno_codMatricula, turma_idturma)
)

-- Adicionar referencias na tabela matricula
ALTER TABLE matricula
  ADD CONSTRAINT matricula_aluno_codMatricula_fk
 	 FOREIGN KEY (aluno_codMatricula)
	 REFERENCES aluno (codMatricula),
  ADD CONSTRAINT matricula_idturma_fk
 	 FOREIGN KEY (turma_idturma)
 	 REFERENCES turma (idturma);

DESCRIBE matricula;

-- Criar tabela chamada
CREATE TABLE chamada 
(
	idchamada INT AUTO_INCREMENT,
	data_chamada DATE NOT NULL,
	presente BOOL NOT NULL,
	matricula_aluno_codMatricula INT NOT NULL,
	matricula_turma_idturma INT NOT NULL,
	CONSTRAINT chamada_pk PRIMARY KEY (idchamada),
	CONSTRAINT chamada_matricula_codMatricula_fk 
		FOREIGN KEY (matricula_aluno_codMatricula)
		REFERENCES matricula (aluno_codMatricula),
	CONSTRAINT chamada_matricula_idturma_fk
		FOREIGN KEY (matricula_turma_idturma) 
		REFERENCES matricula (turma_idturma)
);

DESCRIBE chamada;



