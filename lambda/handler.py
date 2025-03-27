import json
import boto3
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
tabela = dynamodb.Table('EventosPortao')

headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Allow-Methods": "*"
}

def lambda_handler(event, context):
    print("Evento recebido:", json.dumps(event))

    method = event.get("httpMethod")
    path = event.get("path")

    if method == "GET" and "/estado" in path:
        return get_estado()

    elif method == "POST" and "/fechar" in path:
        return acionar_fechamento()

    elif method == "POST" and "/abrir" in path:
        return acionar_abertura()

    else:
        return {
            "statusCode": 404,
            "headers": headers,
            "body": json.dumps({ "erro": "Rota não encontrada" })
        }

def get_estado():
    try:
        response = tabela.scan()
        items = response.get("Items", [])
        print(f"Itens encontrados: {len(items)}")

        if not items:
            return {
                "statusCode": 200,
                "headers": headers,
                "body": json.dumps({ "estado": "desconhecido", "timestamp": None })
            }

        ultimo = sorted(items, key=lambda x: x.get("timestamp", ""), reverse=True)[0]
        print("Último item:", ultimo)

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({
                "estado": ultimo.get("estado", "desconhecido"),
                "timestamp": ultimo.get("timestamp")
            })
        }

    except Exception as e:
        print("Erro ao obter estado:", e)
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({ "erro": "Erro no processamento" })
        }

def acionar_fechamento():
    try:
        item = {
            "id": str(uuid.uuid4()),
            "estado": "fechado",
            "timestamp": datetime.utcnow().isoformat()
        }
        tabela.put_item(Item=item)
        print("Item inserido (fechar):", item)

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({ "sucesso": True })
        }

    except Exception as e:
        print("Erro ao inserir item:", e)
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({ "erro": "Erro ao salvar no banco" })
        }

def acionar_abertura():
    try:
        item = {
            "id": str(uuid.uuid4()),
            "estado": "aberto",
            "timestamp": datetime.utcnow().isoformat()
        }
        tabela.put_item(Item=item)
        print("Item inserido (abrir):", item)

        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({ "sucesso": True })
        }

    except Exception as e:
        print("Erro ao inserir item (abrir):", e)
        return {
            "statusCode": 500,
            "headers": headers,
            "body": json.dumps({ "erro": "Erro ao salvar no banco" })
        }
