# Image de base utilisée: sqlserver2017
FROM mcr.microsoft.com/mssql/server:2017-latest

# définit la variable d'environnement "SA_PASSWORD" à la valeur "Pass@word". 
ENV SA_PASSWORD=Pass@word

# accepter le contrat de licence de l'utilisateur final (EULA) lors de la création du serveur SQL.
ENV ACCEPT_EULA=Y

# Les 3 fichiers fournis sont a copier dans le conteneur.
COPY entrypoint.sh entrypoint.sh
COPY SqlCmdStartup.sh SqlCmdStartup.sh
COPY SqlCmdScript.sql SqlCmdScript.sql

# Cette ligne modifie les autorisations du fichier "SqlCmdStartup.sh" pour le rendre exécutable à l'intérieur du conteneur Docker.
# Le fichier SqlCmdStartup.sh doit être éxécuter avant le démarrage du conteneur afin de préparer les données dans la base de données.
RUN chmod +x ./SqlCmdStartup.sh

# commande par défaut à exécuter lorsque le conteneur Docker est lancé
# signifie que le fichier "entrypoint.sh" sera exécuté avec le shell Bash.
CMD /bin/bash ./entrypoint.sh

# Le conteneur expose le port sqlserver 1433, à l'extérieur du conteneur Docker
# permet aux applications externes de se connecter au serveur SQL exécuté à l'intérieur du conteneur Docker.
EXPOSE 1433/tcp