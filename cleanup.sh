#!/bin/bash

# Este script executa a limpeza completa dos recursos do laboratório AWS.
# Ele depende das variáveis de ambiente (BUCKET_NAME, QUEUE_URL, TOPIC_ARN) 
# definidas durante a execução do setup.

echo "Iniciando processo de limpeza dos recursos AWS..."

# 1. Limpeza do S3 (Esvaziar e Excluir Bucket)
echo "Esvaziando e excluindo o bucket S3: $BUCKET_NAME..."
aws s3 rm s3://$BUCKET_NAME --recursive

# Exclui o bucket S3
aws s3 rb s3://$BUCKET_NAME

# 2. Limpeza do SQS (Excluir Fila)
echo "Excluindo a fila SQS: $QUEUE_NAME..."
aws sqs delete-queue --queue-url $QUEUE_URL

# 3. Limpeza do SNS (Excluir Tópico e Assinaturas)
echo "Excluindo o tópico SNS: $TOPIC_NAME (e todas as assinaturas)..."
aws sns delete-topic --topic-arn $TOPIC_ARN

# 4. Limpeza de arquivos temporários e de teste
echo "Removendo arquivos temporários locais..."
rm -f testfile.txt
rm -f *.tmp

echo "✅ Limpeza concluída. Todos os recursos do laboratório foram removidos."
