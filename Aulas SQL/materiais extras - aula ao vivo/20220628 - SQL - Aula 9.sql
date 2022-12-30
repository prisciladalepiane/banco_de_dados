-- Comando enviado ao MySQL para utilizar o BD 'hospital'.
USE hospital;

-- SELECT com JOINs e WHERE.
SELECT *
  FROM pacientes p
INNER JOIN contatos_pacientes cp ON p.cpf = cp.cpf_paciente
INNER JOIN tipos_contato tc ON cp.id_tipo_contato = tc.id
WHERE tc.id = 3 AND p.nome like 'a%';

-- Listar triggers de um BD.
SHOW TRIGGERS;

-- -------------------------------------------------------------------------------------------------
-- TRIGGERS.
-- -------------------------------------------------------------------------------------------------
-- Validar CPF antes da atualização.
delimiter $
CREATE TRIGGER pacientes_cpf_upd_trg
  BEFORE UPDATE ON pacientes
  FOR EACH ROW
BEGIN

  SET @cpf = lpad(cast(NEW.cpf AS char), 11, '0');
  
  CALL validar_cpf(@cpf, @retorno, @motivo);
  IF @retorno = 0 THEN
    -- SQLSTATE 45000: “unhandled user-defined exception”.
    SIGNAL SQLSTATE '45000'
      SET message_text = @motivo;
  END IF;
  
END
$

-- Atualização de paciente com CPF inválido.
  -- Error Code: 1644 ("Unhandled user-defined exception condition").
UPDATE pacientes SET cpf = 31352643007 WHERE cpf = 6738343019;

-- -------------------------------------------------------------------------------------------------

-- Verificar se o número de contatos de um determinado tipo está sendo respeitado.
delimiter $
CREATE TRIGGER contatos_pacientes_tipo_ins_trg
  BEFORE INSERT ON contatos_pacientes
  FOR EACH ROW
BEGIN
  DECLARE numero_maximo int;
  DECLARE ja_cadastrados int;

  -- Seleciona o número máximo de contatos para um determinado tipo.
  SELECT maximo_por_pessoa INTO numero_maximo
    FROM tipos_contato
   WHERE id = NEW.id_tipo_contato;
   
  -- Seleciona o número de contatos do paciente já cadastrados para o tipo.
  SELECT count(*) INTO ja_cadastrados
    FROM contatos_pacientes
   WHERE cpf_paciente = NEW.cpf_paciente
     AND id_tipo_contato = NEW.id_tipo_contato;
     
  -- Caso o número de contatos cadastrados já atinja o número permitido, bloqueia novas ionclusões.
  IF ja_cadastrados = numero_maximo THEN
    -- SQLSTATE 45000: “unhandled user-defined exception”.
    SIGNAL SQLSTATE '45000'
      SET message_text = 'O número máximo de contatos permitidos para este tipo já foi atingido!';
  END IF;
   
END
$

-- Inserção de um contato válido.
  -- Telefone fixo: só aceita 1 (um) contato para cada pessoa.
INSERT INTO contatos_pacientes VALUES (6738343019, '+551234567890', 2);

-- Inserção de um contato válido (extrapola o número máximo permitido).
  -- Telefone fixo: só aceita 1 (um) contato para cada pessoa.
INSERT INTO contatos_pacientes VALUES (6738343019, '+550987654321', 2);


-- -------------------------------------------------------------------------------------------------
-- VIEWS.
-- -------------------------------------------------------------------------------------------------
-- Criação de view para recuperar dados de pacientes que possuem contatos além de endereços de e-mail.
CREATE VIEW view_pacientes_outros_contatos_email AS
  SELECT *
    FROM pacientes
   WHERE cpf IN (SELECT cpf_paciente
                   FROM contatos_pacientes
                   WHERE id_tipo_contato NOT IN (SELECT id
                                                   FROM tipos_contato
                                                  WHERE descricao NOT LIKE '%mail%')
                 );

-- Seleção de dados a partir da view.
SELECT * FROM view_pacientes_outros_contatos_email;

-- Criação de view para totalizar tipos de contato por paciente.
CREATE VIEW view_total_tipos_contato_pacientes AS
  SELECT p.nome, tc.descricao, count(*)
    FROM pacientes p
   INNER JOIN contatos_pacientes cp ON p.cpf = cp.cpf_paciente
   INNER JOIN tipos_contato tc ON cp.id_tipo_contato = tc.id
  GROUP BY 1, 2
  ORDER BY 1, 2;

-- Seleção de dados a partir da view.
SELECT * FROM view_total_tipos_contato_pacientes WHERE nome like 'a%';

-- Cria usuário com acesso limitado aos objetos do BD.
CREATE USER 'relatorio'@'localhost' IDENTIFIED BY 'root';

-- Libera acesso à view "view_total_tipos_contato_pacientes" no BD "hospital" para o novo usuário.
GRANT SELECT ON hospital.view_total_tipos_contato_pacientes TO 'relatorio'@'localhost';
FLUSH PRIVILEGES;
