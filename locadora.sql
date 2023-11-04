CREATE DATABASE locadora
GO 
USE locadora

GO
CREATE TABLE filme(
id              INT            NOT NULL,
titulo          VARCHAR(40)    NOT NULL,
ano             INT            NULL CHECK(ano <= 2021)
PRIMARY KEY(id)
)

GO
CREATE TABLE dvd(
num                    INT            NOT NULL,
data_fabricacao        DATE           NOT NULL,
id                     INT            NOT NULL
PRIMARY KEY(num)
FOREIGN KEY(id) REFERENCES filme(id)
)

SELECT *
FROM dvd
WHERE data_fabricacao < GETDATE();

GO
CREATE TABLE estrela(
id_estrela        INT            NOT NULL,
nome              VARCHAR(50)    NOT NULL
PRIMARY KEY(id_estrela)
)

GO
CREATE TABLE cliente(
num_cadastro            INT            NOT NULL,   
nome                    VARCHAR(70)    NOT NULL,
logradouro              VARCHAR(150)   NOT NULL,
num                     INT            NOT NULL CHECK(num > 0),
cep                     CHAR(8)		   NOT NULL CHECK(LEN(cep) = 8 OR cep = '')
PRIMARY KEY(num_cadastro)
)


GO
CREATE TABLE  locacao(
num                 INT            NOT NULL,
num_cadastro        INT            NOT NULL, 
data_locacao        DATE           NOT NULL, 
data_devolucao      DATE           NOT NULL,
valor               DECIMAL(7,2)   NOT NULL CHECK(valor>0)
PRIMARY KEY(num, num_cadastro, data_locacao)
FOREIGN KEY(num) REFERENCES dvd(num),
FOREIGN KEY(num_cadastro)REFERENCES cliente(num_cadastro),
CONSTRAINT chk_dt_dev CHECK((UPPER(data_devolucao ) > data_locacao))  
)

SELECT data_locacao, CONVERT(CHAR(10), GETDATE(), 103) AS hoje
FROM locacao;

GO
CREATE TABLE filme_estrela(
id                INT            NOT NULL,
id_estrela        INT            NOT NULL
PRIMARY KEY(id, id_estrela)
FOREIGN KEY(id) REFERENCES filme(id)
)

ALTER TABLE estrela
ADD nome_real VARCHAR(50)   NOT NULL;

SELECT titulo, CONVERT(VARCHAR(80), titulo)AS converted_titulo
FROM filme;

INSERT INTO filme VALUES
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível', 2014),
(1006, 'Sing', 2016)

INSERT INTO estrela VALUES
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone'),
(9903, 'Miles Teller', ''),
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

INSERT INTO filme_estrela VALUES
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

INSERT INTO dvd VALUES
(10001, '2020-12-02', 1001),
(10002, '2019-10-18', 1002),
(10003, '2020-04-03', 1003),
(10004, '2020-12-02', 1001),
(10005, '2019-10-18', 1004),
(10006, '2020-04-03', 1002),
(10007, '2020-12-02', 1005),
(10008, '2019-10-18', 1002),
(10009, '2020-04-03', 1003)

INSERT INTO cliente VALUES
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110'),
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169, ''),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36, ''),
(5505, 'Rosa Cerqueira',  'Rua Arnaldo Simões Pinto', 135, '02917110')

INSERT INTO locacao VALUES
(10001, 5502, '2021-02-18','2021-02-21',3.50),
(10009, 5502, '2021-02-18','2021-02-21',3.50),
(10002, 5503, '2021-02-18','2021-02-19',3.50),
(10002, 5505, '2021-02-20','2021-02-23',3.00),
(10004, 5505, '2021-02-20','2021-02-23',3.00),
(10005, 5505, '2021-02-20','2021-02-23',3.00),
(10001, 5501, '2021-02-24','2021-02-26',3.50),
(10008, 5501, '2021-02-24','2021-02-26',3.50)

UPDATE cliente
SET cep = '08411150'
WHERE num_cadastro = 5503

UPDATE cliente
SET cep = '02918190'
WHERE num_cadastro = 5504

UPDATE locacao
SET valor = 3.25
WHERE  data_locacao = '2021-02-18' AND num_cadastro = 5502

UPDATE locacao
SET valor = 3.10
WHERE  data_locacao = '2021-02-24' AND num_cadastro = 5501

UPDATE dvd
SET data_fabricacao = '2019-07-14'
WHERE  num = 10005

UPDATE estrela
SET nome_real = 'Miles Alexander Teller'
WHERE  nome = 'Miles Teller'

DELETE filme
WHERE titulo = 'Sing'

--Fazer um select que retorne os nomes dos filmes de 2014
SELECT titulo
FROM filme
WHERE ano = 2014

--Fazer um select que retorne o id e o ano do filme Birdman
SELECT id, ano
FROM filme
WHERE titulo = 'Birdman'

--Fazer um select que retorne o id e o ano do filme que tem o nome terminado por plash
SELECT id, ano
FROM filme
WHERE titulo LIKE '%plash'

--Fazer um select que retorne o id, o nome e o nome_real da estrela cujo nome começa com Steve
SELECT id_estrela, nome, nome_real
FROM estrela
WHERE nome LIKE 'Steve%'

-- Fazer um select que retorne FilmeId e a data_fabricação em formato (DD/MM/YYYY) (apelidar de fab) dos filmes fabricados a partir de 01-01-2020
SELECT id, CONVERT(CHAR(10), data_fabricacao, 103) AS fab
FROM dvd
WHERE data_fabricacao >= '2020-01-01'

-- Fazer um select que retorne DVDnum, data_locacao, data_devolucao, valor e valor com multa de acréscimo de 2.00 da locação do cliente 5505
SELECT num,
    data_locacao,
    data_devolucao,
    'R$ ' + CAST(valor AS VARCHAR(8)) AS valor,
    'R$ ' + CAST(CAST(valor + 2.00 AS DECIMAL(7, 2)) AS VARCHAR(8)) AS valor_multa
FROM
    locacao
WHERE
    num_cadastro = 5505;

-- Fazer um select que retorne Logradouro, num e CEP de Matilde Luz
SELECT logradouro, num, cep
FROM cliente
WHERE nome = 'Matilde Luz'

--Fazer um select que retorne Nome real de Michael Keaton
SELECT nome_real
FROM estrela
WHERE nome = 'Michael Keaton'

--Fazer um select que retorne o num_cadastro, o nome e o endereço completo, concatenando (logradouro, numero e CEP), apelido end_comp, dos clientes cujo ID é maior ou igual 5503
SELECT num_cadastro,
     nome,
	 logradouro +' '+ CAST(num AS VARCHAR) + ' ' + cep AS end_comp
FROM cliente
WHERE num_cadastro >= 5503

--Fazer uma consulta que retorne ID, Ano, nome do Filme (Caso o nome do filme tenha
--mais de 10 caracteres, para caber no campo da tela, mostrar os 10 primeiros
--caracteres, seguidos de reticências ...) dos filmes cujos DVDs foram fabricados depois
--de 01/01/2020

SELECT f.id,
        CAST(ano AS INT),
	  CASE
        WHEN LEN(titulo) > 10 THEN LEFT(titulo, 10) + '...'
		ELSE titulo
		END
FROM filme AS f
JOIN dvd AS d ON num = num
WHERE data_fabricacao>  '2020-01-01';

--Fazer uma consulta que retorne num, data_fabricacao, qtd_meses_desde_fabricacao
--(Quantos meses desde que o dvd foi fabricado até hoje) do filme Interestelar

SELECT num,
        data_fabricacao,
	    DATEDIFF(MONTH, data_fabricacao, GETDATE()) AS quant_meses_hoje
FROM filme AS f
JOIN dvd AS d ON num = num
WHERE titulo>  'Interestelar';

--Fazer uma consulta que retorne num_dvd, data_locacao, data_devolucao,
--dias_alugado(Total de dias que o dvd ficou alugado) e valor das locações da cliente que
--tem, no nome, o termo Rosa
SELECT d.num,
        l.data_locacao,
		l.data_devolucao,
		l.valor,
	    DATEDIFF(DAY, data_locacao, GETDATE()) AS quant_dias_alugado
FROM locacao AS l
JOIN dvd AS d ON l.num = d.num
JOIN cliente c ON l.num_cadastro = c.num_cadastro
WHERE nome LIKE  '%Rosa%';

--Nome, endereço_completo (logradouro e número concatenados), cep (formato
--XXXXX-XXX) dos clientes que alugaram DVD de num 10002.
SELECT c.nome,
       c.logradouro + ' ' + CAST(c.num AS VARCHAR(10)) AS end_completo,
	   SUBSTRING(c.cep,1,5) + '-' + SUBSTRING(c.cep,6,3) AS cep
FROM locacao AS l
JOIN dvd AS d ON l.num = d.num
JOIN cliente c ON l.num_cadastro = c.num_cadastro
WHERE d.num = 10002;



