-- Script Aula 5

USE hospital;


-- Sub-transa��es ou nested transactions?
-- N�O � POSS�VEL.
START TRANSACTION;
  DELETE FROM contatos_pacientes;
  DELETE FROM tipos_contato;
  START TRANSACTION;
    SELECT * FROM contatos_pacientes;
    SELECT * FROM tipos_contato;
  ROLLBACK;
COMMIT;
-- O Mysql n�o faz aninhamento

-- SAVEPOINTS.
START TRANSACTION;
  DELETE FROM contatos_pacientes;
  SAVEPOINT parte_1;
    DELETE FROM tipos_contato;
    SAVEPOINT parte_2;
      SELECT * FROM contatos_pacientes;
      SELECT * FROM tipos_contato;
      ROLLBACK TO parte_1; -- Retorna ao ponto salvo
COMMIT;


-- LIKE n�o � case sensitive
SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE 'An%';
SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE 'AN%';
-- For�ar a ser case sensitive
SELECT nome, nome_mae FROM pacientes WHERE nome_mae LIKE BINARY 'AN%';

-- LIKE com caracteres acentuados.
INSERT INTO pacientes VALUES (88776655443, 'Jos�', '1970-01-01', 'B�rbara', 'C�sar');
SELECT nome, nome_mae FROM pacientes WHERE nome LIKE '%jose%';

-- CHARSET e COLLATION?
-- Caracteristicas da tabela pacientes
SHOW TABLE STATUS WHERE name LIKE 'pacientes';
-- utf8mb4_0900_ai_ci:
   -- utf8mb4: 4 bytes por caracter em UTF8.
   -- 0900: vers�o do algoritmo utilizado para compara��o de caracteres.
   -- ai: accent insensitivity (letras acentuadas e n�o acentuadas s�o consideradas iguais 
   --     em compara��es e ordena��es).
   -- ci: case insensitivity (letras mai�sculas e min�sculas s�o consideradas iguais
   --     em compara��es e ordena��es).


-- -------------------------------------------------------------------------------------------------
-- Produto cartesiano.
-- -------------------------------------------------------------------------------------------------
-- Relembrar opera��es matem�ticas: multiplica��o como sequ�ncia de somas,
-- divis�o como sequ�ncia de subtra��es.
SELECT * FROM pacientes, contatos_pacientes;
SELECT * FROM pacientes, contatos_pacientes, tipos_contato;
SELECT *
  FROM pacientes
 CROSS JOIN contatos_pacientes
 CROSS JOIN tipos_contato;


-- Produto cartesiano com condi��es (chave prim�ria x chave estrangeira).
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


-- -------------------------------------------------------------------------------------------------
-- Jun��es (JOINs).
-- -------------------------------------------------------------------------------------------------
-- INNER JOIN (duas tabelas).
SELECT *
  FROM pacientes AS p
 INNER JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente;

-- INNER JOIN (tr�s tabelas).
SELECT *
  FROM pacientes AS p
 INNER JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente
 INNER JOIN tipos_contato AS tc ON cp.id_tipo_contato = tc.id;

-- INCORRETO: compara��o que n�o � de igualdade.
SELECT *
  FROM pacientes AS p
 INNER JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente
 INNER JOIN tipos_contato AS tc ON cp.id_tipo_contato > tc.id;

-- LEFT JOIN.
SELECT *
  FROM pacientes AS p
 LEFT JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente;

-- RIGHT JOIN.
SELECT *
  FROM contatos_pacientes AS cp
 RIGHT JOIN pacientes AS p ON cp.cpf_paciente = p.cpf;

-- FULL JOIN - n�o � suportado pelo  MySQL.
-- Como resolver: uni�o entre LEFT JOIN e RIGHT JOIN.
SELECT *
  FROM pacientes AS p
 LEFT JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente
UNION
SELECT *
  FROM pacientes AS p
 RIGHT JOIN contatos_pacientes AS cp ON p.cpf = cp.cpf_paciente;
