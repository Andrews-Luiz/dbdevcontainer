-- cadastra as pessoas
INSERT INTO Pessoa (nome, email, cpf, data_nasc, endereco, telefone) VALUES
    ('Pedro I',   'pp@email.com', '002', '1479-01-10', 'R. Vasco',    NULL),
    ('Pedro II',  'ps@email.com', '003', '1516-02-10', 'R. Flamengo', '5501'),
    ('D João VI', 'dj@email.com', '001', '1415-12-01', 'R. Portugal', NULL),
    ('JJ Xavier', 'jj@email.com', '004', '1746-11-12', 'R. Minas',    '5502');
-- cadastra os pacientes
INSERT INTO Paciente (cpf, senha, plano_saude) VALUES
    ('002', 'senha1', FALSE),
    ('003', 'senha2', TRUE);
-- cadastra os médicos
INSERT INTO Medico (cpf, crm) VALUES
    ('001', '111'),
    ('004', '112');
-- cadastra as especialidades
INSERT INTO Especialidade (descricao) VALUES
    ('Pediatra'),
    ('Cardiologista'),
    ('Ortopedista');
-- liga cada médico às suas especialidades
INSERT INTO Medico_Especialidade (cpf_medico, id_especialidade) VALUES
    ('001', (SELECT id FROM Especialidade WHERE descricao = 'Pediatra')),
    ('004', (SELECT id FROM Especialidade WHERE descricao = 'Cardiologista')),
    ('004', (SELECT id FROM Especialidade WHERE descricao = 'Ortopedista'));
-- cadastra os agendamentos
INSERT INTO Agendamento (cpf_paciente, cpf_medico, dt_consulta, dt_agendamento, valor_consulta) VALUES
    ('002', '001', '1782-04-14 16:00:00', '1782-03-14 10:04:45',  80.00),
    ('002', '004', '1782-04-15 10:00:00', '1782-03-14 10:04:45', 100.00),
    ('002', '004', '1783-05-17 08:00:00', '1783-05-10 16:32:00', 100.00),
    ('003', '001', '1783-05-17 08:30:00', '1783-05-09 09:05:56',   0.00);

-- corrige a data de nascimento de D João VI
UPDATE Pessoa SET data_nasc = '1416-12-01' WHERE nome = 'D João VI';
-- troca telefone e e-mail de Pedro I
UPDATE Pessoa SET telefone = '5503', email = 'pf@email.com' WHERE nome = 'Pedro I';
-- coloca o dígito 9 no início dos telefones
UPDATE Pessoa SET telefone = '9' || telefone WHERE telefone IS NOT NULL;
-- adia as consultas de 17-05-1783 para o dia 19 e muda o valor para 150
UPDATE Agendamento
   SET dt_consulta = dt_consulta + INTERVAL '2 days', valor_consulta = 150.00
 WHERE CAST(dt_consulta AS DATE) = '1783-05-17';
-- JJ Xavier deixa de ser cardiologista e passa a ser pediatra
UPDATE Medico_Especialidade
   SET id_especialidade = (SELECT id FROM Especialidade WHERE descricao = 'Pediatra')
 WHERE cpf_medico = (SELECT cpf FROM Pessoa WHERE nome = 'JJ Xavier')
   AND id_especialidade = (SELECT id FROM Especialidade WHERE descricao = 'Cardiologista');

-- Pedro I cancela a consulta do dia 19-05-1783
DELETE FROM Agendamento
 WHERE cpf_paciente = (SELECT cpf FROM Pessoa WHERE nome = 'Pedro I')
   AND CAST(dt_consulta AS DATE) = '1783-05-19';
-- remove os agendamentos de D João VI com valor 0
DELETE FROM Agendamento
 WHERE cpf_medico = (SELECT cpf FROM Pessoa WHERE nome = 'D João VI')
   AND valor_consulta = 0;
-- remove pacientes com plano de saúde ou sem telefone
DELETE FROM Paciente
 WHERE plano_saude = TRUE OR cpf IN (SELECT cpf FROM Pessoa WHERE telefone IS NULL);
-- remove o médico JJ Xavier
DELETE FROM Medico WHERE cpf = (SELECT cpf FROM Pessoa WHERE nome = 'JJ Xavier');
