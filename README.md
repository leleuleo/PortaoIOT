📡 API Gateway - Portão IoT
Este serviço expõe uma API REST para monitoramento e controle de um portão via AWS Lambda + DynamoDB, com integração com AWS IoT.


https://<API_ID>.execute-api.us-east-1.amazonaws.com/prod

Exemplo real:
https://2ux1taym89.execute-api.us-east-1.amazonaws.com/prod


📘 Endpoints
✅ GET /estado
Retorna o estado mais recente registrado no DynamoDB.

Response:

{
  "estado": "aberto"
}

Códigos de resposta:

200 OK

500 Internal Server Error


🚪 POST /fechar
Registra um evento de fechamento do portão e atualiza o estado no DynamoDB.

Response:

{
  "sucesso": true
}

Códigos de resposta:

200 OK

500 Internal Server Error

🚪 POST /abrir
Registra um evento de abertura do portão e atualiza o estado no DynamoDB.

Response: