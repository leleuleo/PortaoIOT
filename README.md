## 🔗 API Gateway - Portão IoT

> ⚠️ Este projeto é um **protótipo funcional** com fins educacionais. Foram **ignorados intencionalmente padrões básicos de segurança**, como autenticação, limitação de acesso, criptografia e segregação de ambientes.

Este serviço expõe uma API REST para monitoramento e controle de um portão via AWS Lambda + DynamoDB, com integração com AWS IoT.

---

### 🔗 **Base URL**

```
https://<API_ID>.execute-api.us-east-1.amazonaws.com/prod
```

> Exemplo real:  
> `https://2ux1taym89.execute-api.us-east-1.amazonaws.com/prod`

---

### 📘 Endpoints

#### ✅ GET `/estado`

Retorna o estado mais recente registrado no DynamoDB, incluindo a data/hora do evento.

- **Response**:

```json
{
  "estado": "aberto",
  "timestamp": "2025-03-25T15:00:00Z"
}
```

- **Códigos de resposta**:
  - `200 OK`
  - `500 Internal Server Error`

---

#### 🚪 POST `/fechar`

Registra um evento de **fechamento do portão** e atualiza o estado no DynamoDB.

- **Response**:

```json
{
  "sucesso": true
}
```

- **Códigos de resposta**:
  - `200 OK`
  - `500 Internal Server Error`

---

#### 🚪 POST `/abrir`

Registra um evento de **abertura do portão** e atualiza o estado no DynamoDB.

- **Response**:

```json
{
  "sucesso": true
}
```

- **Códigos de resposta**:
  - `200 OK`
  - `500 Internal Server Error`

---

### 🛡️ CORS

Todos os endpoints possuem CORS habilitado para:

```http
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: *
Access-Control-Allow-Methods: *
```

---

### 🧪 Exemplos de Testes com VSCode REST Client

```http
### Consultar estado do portão
GET https://2ux1taym89.execute-api.us-east-1.amazonaws.com/prod/estado

### Acionar fechamento do portão
POST https://2ux1taym89.execute-api.us-east-1.amazonaws.com/prod/fechar
Content-Type: application/json

{}

### Acionar abertura do portão
POST https://2ux1taym89.execute-api.us-east-1.amazonaws.com/prod/abrir
Content-Type: application/json

{}
```

---

### 🧩 Arquitetura Simplificada

```
[API Gateway]
     │
 └──► [Lambda] ──► DynamoDB (Estado)
     │
     ▼
[React Frontend]
```

---

## 📄 Infraestrutura como Código (Terraform)

A infraestrutura da solução é totalmente provisionada usando Terraform.

### Estrutura de diretórios:

```
infra/
├── api_gateway.tf
├── lambda.tf
├── dynamodb.tf
├── sns.tf
├── iot.tf
├── iam.tf
├── outputs.tf
├── variables.tf
├── main.tf
└── lambda/
    └── handler.py
```

### Passos para provisionamento

1. **Inicializar o Terraform:**

```bash
cd infra
terraform init
```

2. **Validar a configuração:**

```bash
terraform validate
```

3. **Visualizar o plano de execução:**

```bash
terraform plan
```

4. **Aplicar a infraestrutura:**

```bash
terraform apply -auto-approve
```

5. **Outputs esperados:**

- URL da API Gateway
- Nome da função Lambda
- Nome da tabela DynamoDB

### Principais recursos criados

- `aws_lambda_function.portao_handler`
- `aws_api_gateway_rest_api.portao_api`
- `aws_api_gateway_resource` e `aws_api_gateway_method` para `/estado`, `/abrir`, `/fechar`
- `aws_dynamodb_table.EventosPortao`
- `aws_iot_topic_rule.fechamento_portao`
- `aws_sns_topic.alerta_portao`

### Políticas IAM recomendadas

- Lambda com permissão para `dynamodb:PutItem`, `dynamodb:Scan`
- IoT com `iot:CreateTopicRule`, `iot:ListTopicRules`
- SNS com permissão de publicação

### Upload do código da Lambda

Zipar o handler:

```bash
cd lambda
zip lambda_function_payload.zip handler.py
```

E referenciar no Terraform com:

```hcl
filename         = "../lambda/lambda_function_payload.zip"
source_code_hash = filebase64sha256("../lambda/lambda_function_payload.zip")
```

---

## 📌 Como Deletar Todos os Recursos

Caso queira remover toda a infraestrutura provisionada:

```powershell
terraform destroy -auto-approve
```

Isso apagará todos os recursos criados na AWS.

---

## 📌 Contribuições

Se quiser melhorar este projeto, sinta-se à vontade para abrir issues ou fazer pull requests.

---

## 📜 Licença

Este projeto é de código aberto e distribuído sob a licença MIT.

