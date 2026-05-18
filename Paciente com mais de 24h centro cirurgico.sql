create or replace PROCEDURE        DBAGLA.PRC_PACIENTES_COM_MAIS_24H_CENTRO_CIRURGICO AS

   VCORPOEMAIL CLOB;
   V_QTD_REGISTROS NUMBER := 0;

BEGIN

   /* =========================================================
      CABEÇALHO HTML
   ========================================================= */

   VCORPOEMAIL := '
   <div style="
      font-family: Arial, Helvetica, sans-serif;
      font-size: 13px;
      color: rgb(68,68,68);
      width: 100%;
      max-width: 900px;
      margin: 0 auto;
      padding: 20px;
      box-sizing: border-box;
   ">';

   VCORPOEMAIL := VCORPOEMAIL || '
      <div style="
         font-size: 20px;
         font-weight: bold;
         margin-bottom: 20px;
      ">
      </div>';

   VCORPOEMAIL := VCORPOEMAIL || '
      <div align="right" style="
         font-family: Arial;
         margin-bottom: 20px;
      ">
         ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI') || '
      </div>';

   VCORPOEMAIL := VCORPOEMAIL || '
      <div style="
         font-size: 16px;
         font-weight: bold;
         margin-bottom: 10px;
      ">
         Pacientes com mais de 24h no Centro Cirúrgico
      </div>';

   /* =========================================================
      TABELA
   ========================================================= */

   VCORPOEMAIL := VCORPOEMAIL || '

      <table style="
         width: 100%;
         border: 1px solid rgb(204,204,204);
         border-collapse: collapse;
         table-layout: fixed;
      ">

         <thead>

            <tr style="
               background-color: rgb(220,233,249);
            ">
               <th style="
                  border: 1px solid rgb(204,204,204);
                  padding: 10px;
                  text-align: left;
                  width: 25%;
               ">
                  Sala Cirúrgica
               </th>     
                
               <th style="
                  border: 1px solid rgb(204,204,204);
                  padding: 10px;
                  text-align: left;
                  width: 25%;
               ">
                  Paciente
               </th>

               <th style="
                  border: 1px solid rgb(204,204,204);
                  padding: 10px;
                  text-align: left;
                  width: 15%;
               ">
                  Atendimento
               </th>
               
               <th style="
                  border: 1px solid rgb(204,204,204);
                  padding: 10px;
                  text-align: left;
                  width: 15%;
               ">
                  Tipo Atendimento
               </th>

               <th style="
                  border: 1px solid rgb(204,204,204);
                  padding: 10px;
                  text-align: left;
                  width: 20%;
               ">
                  Data Atendimento
               </th>

               <th style="
                  border: 1px solid rgb(204,204,204);
                  padding: 10px;
                  text-align: left;
                  width: 15%;
               ">
                  Aviso Cirurgia
               </th>

               <th style="
                  border: 1px solid rgb(204,204,204);
                  padding: 10px;
                  text-align: left;
                  width: 25%;
               ">
                  Entrada RPA
               </th>

            </tr>

         </thead>

         <tbody>
   ';

   /* =========================================================
      LOOP - SOMENTE AS LINHAS
   ========================================================= */

   FOR R_ITENS IN (

      SELECT TMP.*
        FROM (
               SELECT SC.CD_SAL_CIR AS SALA,
                      MCR.CD_ATENDIMENTO AS ATENDIMENTO,
                      COALESCE(DECODE(A.TP_ATENDIMENTO,'A','AMBULATÓRIO','E','EXTERNO','I','INTERNAÇÃO','U','URGÊNCIA'),A.TP_ATENDIMENTO) AS TIPO_ATENDIMENTO,
                      A.HR_ATENDIMENTO,
                      FN_IDADE(P.DT_NASCIMENTO, 'a') AS IDADE,
                      TSX.NM_SEXO,
                      AC.CD_AVISO_CIRURGIA,
                      P.CD_PACIENTE,
                      P.NM_PACIENTE,
                      MCR.DT_ENTRADA_RPA
                 FROM MOVIMENTO_CENTRO_CIRURGICO MCR
           INNER JOIN AVISO_CIRURGIA AC     ON AC.CD_AVISO_CIRURGIA = MCR.CD_AVISO_CIRURGIA
           INNER JOIN SALA SC            ON SC.CD_SAL_CIR = AC.CD_SAL_CIR
           INNER JOIN CLIENTE P            ON P.CD_PACIENTE = AC.CD_PACIENTE
           INNER JOIN ATENDIMENTOS A            ON A.CD_ATENDIMENTO = MCR.CD_ATENDIMENTO
           INNER JOIN DBAMV.TIPO_SEXO TSX   ON P.TP_SEXO = TSX.TP_SEXO
                WHERE AC.TP_SITUACAO = 'R'
                  AND AC.DT_CANCELAMENTO IS NULL
                  AND AC.DT_REALIZACAO IS NOT NULL
                  AND MCR.DT_SAIDA_CC IS NULL
                  AND DBAGLA.FN_DATEDIFF(TRUNC(MCR.DT_CHAMADA_TRANSF),TRUNC(SYSDATE),'HORA') >= 24
             ) TMP

       WHERE TRUNC(TMP.DT_ENTRADA_RPA) >= TO_DATE('10/05/2026','DD/MM/YYYY')

       ORDER BY TMP.SALA, TMP.ATENDIMENTO

   ) LOOP

      V_QTD_REGISTROS := V_QTD_REGISTROS + 1;
     
      VCORPOEMAIL := VCORPOEMAIL || '

         <tr>

            <td style="
               border: 1px solid rgb(204,204,204);
               padding: 10px;
               text-align: left;
            ">
               ' || NVL(R_ITENS.SALA,'') || '
            </td>
            
            <td style="
               border: 1px solid rgb(204,204,204);
               padding: 10px;
               text-align: left;
            ">
               <b>' || NVL(R_ITENS.NM_PACIENTE,'') || '</b>
               <br>
               <span style="font-size:11px;color:#666;">
                  Idade: ' || NVL(R_ITENS.IDADE,'') || '
                  - Sexo: ' || NVL(R_ITENS.NM_SEXO,'') || '
               </span>
            </td>

            <td style="
               border: 1px solid rgb(204,204,204);
               padding: 10px;
               text-align: left;
            ">
               ' || NVL(R_ITENS.ATENDIMENTO,'') || '
            </td>
            
            <td style="
               border: 1px solid rgb(204,204,204);
               padding: 10px;
               text-align: left;
            ">
               ' || NVL(R_ITENS.TIPO_ATENDIMENTO,'') || '
            </td>

            <td style="
               border: 1px solid rgb(204,204,204);
               padding: 10px;
               text-align: left;
            ">
               ' || NVL(TO_CHAR(R_ITENS.HR_ATENDIMENTO,'DD/MM/YYYY HH24:MI:SS'),'') || '
            </td>

            <td style="
               border: 1px solid rgb(204,204,204);
               padding: 10px;
               text-align: left;
            ">
               ' || NVL(R_ITENS.CD_AVISO_CIRURGIA,'') || '
            </td>

            <td style="
               border: 1px solid rgb(204,204,204);
               padding: 10px;
               text-align: left;
            ">
               ' || NVL(TO_CHAR(R_ITENS.DT_ENTRADA_RPA,'DD/MM/YYYY HH24:MI:SS'),'') || '
            </td>

         </tr>

      ';

   END LOOP;

   /* =========================================================
      FECHAMENTO HTML
   ========================================================= */

   VCORPOEMAIL := VCORPOEMAIL || '

         </tbody>

      </table>

      <br>

      <div align="right" style="
         font-size: 11px;
         color: #666;
      ">
         Mensagem automática; por favor não responda.
      </div>

      <div align="right" style="
         font-size: 11px;
         color: #666;
      ">
         Contém INFORMAÇÃO [ ] PÚBLICA [X] INTERNA [ ] CONFIDENCIAL.
      </div>

   </div>

   ';
   
   IF V_QTD_REGISTROS > 0 THEN

	   INSERT INTO DBAGLA.URC_ESCUTAMAIL (
		  APLICACAOORIGEM,
		  ORIGEMNOME,
		  ORIGEMENDERECO,
		  DESTINONOME,
		  DESTINOENDERECO,
		  ASSUNTO,
		  MENSAGEM,
		  TIPOMENSAGEM

	   ) VALUES (

		  'PRC_PACIENTES_COM_MAIS_24H_CENTRO_CIRURGICO',
		  'Sistemas',
		  'sistemas@algumacoisa.com.br',
		  'sistemas',
		  'sistemas@algumacoisa.com.br',
		  'Pacientes com mais de 24h - centro cirurgico',
		  VCORPOEMAIL,
		  'Text/Html'

	   );

END IF;

EXCEPTION

   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('');

   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);

END;
