# Dockerfile para Railway - FORÇA REBUILD COMPLETO
# Last updated: 2025-11-02
FROM python:3.11-slim

# Atualiza pacotes e instala dependências necessárias
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Verifica instalação do Node.js e mostra o caminho
RUN node --version && npm --version && which node

# Define diretório de trabalho
WORKDIR /app

# Copia arquivos de dependências
COPY requirements.txt package*.json ./

# Instala dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Instala dependências Node.js
RUN npm install --production

# Copia o resto dos arquivos
COPY . .

# Expõe porta (Railway define a variável PORT automaticamente)
# PORT será definido pelo Railway em tempo de execução
EXPOSE 8080

# Define PATH explicitamente para garantir que node seja encontrado
ENV PATH="/usr/bin:$PATH"

# Comando de inicialização
# Railway injeta PORT automaticamente via variável de ambiente
CMD ["node", "start.js"]

