# Laboratório AWS: Notificações de Eventos S3 com SNS e SQS (AWS CLI)

☁️ Este projeto demonstra como monitorar eventos de upload e exclusão em um bucket S3 da AWS, utilizando SNS para notificações por e-mail e SQS para registro de eventos assíncronos.

---

## 🎯 Objetivo

- Enviar notificações por e-mail (via SNS) sempre que um arquivo for carregado ou excluído no bucket S3.
- Registrar eventos de upload e exclusão em uma fila SQS para auditoria ou processamento posterior.

---

## 🏗️ Estrutura do Projeto

A estrutura de arquivos é otimizada para segurança, separando o código de infraestrutura (versionado) das variáveis sensíveis e credenciais (ignoradas via `.gitignore`).
```bash

├── .gitignore # Arquivos e dados sensíveis ignorados pelo Git
├── README.md # Documentação do projeto
├── cleanup.sh # Script para remover recursos AWS
├── s3-notification-config.json # Configuração de notificação S3 → SNS
├── sns-policy.json # Política de acesso do tópico SNS
├── sqs-policy.json # Política de acesso da fila SQS
└── setup-lab.sh # Script principal de configuração

```

## ⚠️ Configuração e Segurança

### Pré-requisitos

- Conta AWS ativa.
- AWS CLI configurada e autenticada.
- Permissões IAM para `s3:`, `sns:`, e `sqs:`.

### Variáveis de Ambiente

Antes de executar qualquer script, você deve definir as variáveis de ambiente necessárias. Você pode criar um arquivo temporário de ambiente ou apenas definir no terminal (recomendado).

```bash
# =======================================================
# 1. VARIÁVEIS SENSÍVEIS (NÃO suba para o Git)
# =======================================================
export CONTA_ID="SEU_ID_DE_CONTA_AWS_DE_12_DIGITOS" 
export EMAIL="seu-email-valido@dominio.com"

# =======================================================
# 2. VARIÁVEIS DO PROJETO
# =======================================================
export REGION="us-east-1"
export NOME_BASE="seunome-data-exemplo" 

# Nomes de Recursos (Serão gerados com base no NOME_BASE)
export BUCKET_NAME="eventos-s3-$NOME_BASE"
export TOPIC_NAME="notificacoes-s3-$NOME_BASE"
export QUEUE_NAME="fila-eventos-s3-$NOME_BASE"
```
---


## 🚀 Uso e Execução

### 1. Criar e Configurar a Infraestrutura

Execute o script de setup para criar e configurar todos os recursos:
```
./setup-lab.sh 
```
2. Confirmação da Assinatura.
   
Após a execução do setup, você receberá um e-mail da AWS. 
É obrigatório clicar no link de confirmação no e-mail para ativar a notificação por e-mail.3. 
Teste do Fluxo de EventosUse os seguintes comandos para verificar se a notificação e o registro estão funcionando:

Teste 3.1: Upload de Arquivo (PUT)
```Bash
echo "Teste de Upload para S3" > test-upload.txt
aws s3 cp test-upload.txt s3://$BUCKET_NAME/test-upload.txt
```
<img width="1902" height="985" alt="Captura de tela 2025-10-29 192405" src="https://github.com/user-attachments/assets/4ad29afc-e453-4d5a-baac-856829f95575" />

## Verificação SQS:

```
echo "Verificando se a mensagem está na fila SQS..."
aws sqs receive-message --queue-url $QUEUE_URL --max-number-of-messages 1 --wait-time-seconds 5
```
Teste 3.2: Exclusão de Arquivo (DELETE)
```Bash
aws s3 rm s3://$BUCKET_NAME/test-upload.txt
```
## Verificação SQS:
```
echo "Verificando se a mensagem de exclusão está na fila SQS..."
aws sqs receive-message --queue-url $QUEUE_URL --max-number-of-messages 1 --wait-time-seconds 5
```
Em ambos os testes, você deve receber um e-mail da AWS e a fila SQS deve conter um payload JSON com o evento.
<img width="1234" height="422" alt="Captura de tela 2025-10-29 192523" src="https://github.com/user-attachments/assets/532a520b-06e9-4c0b-8976-03037d471e9c" />

## 🧹 Limpeza dos Recursos
Para evitar cobranças, execute o script de limpeza após o término dos testes.
```Bash
# Certifique-se de que as variáveis $BUCKET_NAME, $QUEUE_URL, e $TOPIC_ARN estão definidas
./cleanup.sh
```
---

<img width="1008" height="664" alt="limpeza" src="https://github.com/user-attachments/assets/44922135-3ac2-47bc-ae7b-89bc968a5583" />

