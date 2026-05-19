# JOB - Envia email com paciente a mais de 24h no centro cirúrgico
Este projeto contém uma procedure (função no banco de dados Oracle) que envia um e-mail com informações referentes aos pacientes que se encontram a mais de 24h no centro cirúrgico.

## Objetivo

O objetivo principal desta procedure é enviar ** Enviar email para notificar a gestão responsável pelo centro cirúrgico com os pacientes que ainda tiveram o procedimento realizado
e ainda não tiveram alta do centro cirúrgico ** com dados como:

- Atendimento do paciente,
- Idade e data de nascimento do paciente,
- Nome do paciente,
- Data do atendimento
- Data da realização da cirúrgica,
- Data de entrada no centro cirúrgico.


Essas informações são mostradas em um modelo de e-mail em HTML, pronto para ser enviado.

## Como funciona

A procedure do banco de dados é chamada uma vez ao dia(6h AM), onde é montado o email com as informações mencionada acima.
Tudo isso é feito de forma automática, sem precisar escrever o e-mail manualmente.

## Tecnologias utilizadas

- Oracle PL/SQL
- Banco de dados relacional
- HTML para formatar o e-mail

## Uso

Esta procedure pode ser útil para sistemas que:

- Setores que fazem o controle do cuidado do paciente
- Precisam enviar relatórios por e-mail
- Querem automatizar esse processo e ganhar tempo

---
⚠️ Atenção: este código é genérico e não utiliza dados reais de atendimentos, paciente. Foi adaptado para fins de exemplo.

Autor
Desenvolvido por Gabriel Lisboa Alves👨‍💻
