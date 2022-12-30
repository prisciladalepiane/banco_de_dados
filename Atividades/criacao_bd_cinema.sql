CREATE DATABASE cinema;

USE cinema;

CREATE TABLE cinema.funcionario
(
	idfuncionario INT NOT NULL AUTO_INCREMENT,
	nome VARCHAR(45) NOT NULL,
	carteiraTrabalho INT NOT NULL,
	dataContratacao DATE NOT NULL,
	salario FLOAT NOT NULL,
	PRIMARY KEY(idfuncionario)
);

CREATE TABLE cinema.funcao
(
	idfuncao INT NOT NULL AUTO_INCREMENT,
	nome VARCHAR(45) NOT NULL,
	PRIMARY KEY(idfuncao)
);


CREATE TABLE cinema.horario
(
	idhorario INT NOT NULL AUTO_INCREMENT,
	horario TIME NOT NULL,
	PRIMARY KEY(idhorario)
);

DESCRIBE cinema.horario

CREATE TABLE cinema.horario_trabalho_funcionario
(
	horario_idhorario INT NOT NULL,
	funcionario_idfuncionario INT NOT NULL,
	funcao_idfuncao INT NOT NULL,
	PRIMARY KEY(horario_idhorario , funcionario_idfuncionario),
	CONSTRAINT fk_horario_horario
	FOREIGN KEY(horario_idhorario) REFERENCES cinema.horario(idhorario),
	CONSTRAINT fk_horario_funcionario
	FOREIGN KEY(funcionario_idfuncionario) REFERENCES cinema.funcionario(idfuncionario),
	CONSTRAINT fk_horario_funcao FOREIGN KEY(funcao_idfuncao)
	REFERENCES cinema.funcao(idfuncao)
);


CREATE TABLE cinema.diretor
(
	idDiretor INT NOT NULL AUTO_INCREMENT, 
	nome VARCHAR(45) NOT NULL,
	PRIMARY KEY(idDiretor)
);

CREATE TABLE cinema.genero
(
	idgenero INT NOT NULL AUTO_INCREMENT,
	nome VARCHAR(45) NOT NULL,
	PRIMARY KEY(idgenero)
);

CREATE TABLE cinema.sala
(
	idSala INT NOT NULL AUTO_INCREMENT,
	nome VARCHAR(45) NOT NULL,
	capacidade INT NOT NULL,
	PRIMARY KEY(idSala)
);


CREATE TABLE cinema.premiacao
(
	idpremiacao INT NOT NULL AUTO_INCREMENT, 
	nome VARCHAR(45) NOT NULL,
	ano INT NOT NULL,
	PRIMARY KEY(idpremiacao)
);


CREATE TABLE cinema.filme
(
	idfilme INT NOT NULL,
	nomeBR VARCHAR(45) NOT NULL,
	nomeEN VARCHAR(45) NOT NULL,
	anoLancamento INT NOT NULL,
	diretor_idDiretor INT NOT NULL,
	sinopse TEXT NOT NULL,
	genero_idgenero INT NOT NULL,
	PRIMARY KEY(idfilme),
	CONSTRAINT fk_filme_diretor
	FOREIGN KEY(diretor_idDiretor) REFERENCES cinema.diretor(idDiretor),
	CONSTRAINT fk_filme_genero
	FOREIGN KEY(genero_idgenero) REFERENCES cinema.genero(idgenero)
);

CREATE TABLE cinema.filme_exibido_sala
(
	filme_idfilme int NOT NULL,
	sala_idSala int NOT NULL,
	horario_idhorario int NOT NULL,
	PRIMARY KEY(filme_idfilme ,
	sala_idSala ,
	horario_idhorario),
	CONSTRAINT fk_exibido_filme
	FOREIGN KEY(filme_idfilme)
	REFERENCES cinema.filme(idfilme),
	CONSTRAINT fk_exibido_sala
	FOREIGN KEY(sala_idSala)
	REFERENCES cinema.sala(idSala),
	CONSTRAINT fk_exibido_horario
	FOREIGN KEY(horario_idhorario)
	REFERENCES cinema.horario(idhorario)
);


CREATE TABLE cinema.filme_has_premiacao
(
	filme_idfilme int NOT NULL,
	premiacao_idpremiacao int NOT NULL,
	ganhou bool NOT NULL,
	PRIMARY KEY(filme_idfilme ,premiacao_idpremiacao),
	CONSTRAINT fk_premiacao_filme
	FOREIGN KEY(filme_idfilme)
	REFERENCES cinema.filme(idfilme),
	CONSTRAINT fk_premiacao_premiacao
	FOREIGN KEY(premiacao_idpremiacao) REFERENCES cinema.premiacao(idpremiacao)
);

DESCRIBE cinema.horario_trabalho_funcionario









