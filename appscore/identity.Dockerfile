# Depuis l'image mcr.microsoft... qui vous nomerez "base",
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim AS base

# créer un répertoire /app et exposer les ports 80 et 443
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Depuis l'image mcr.microsoft.com/do...vous nomerez "build", 
FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch AS build

# créer un répertoire /src.
WORKDIR /src

# Copier les dossiers Services/(dossier qui contient le fichier csproj) 
# et Foundation/Events dans le répertoire /src.
# COPY Services/Identity.Api Services/Identity.Api
# COPY Foundation/Events Foundation/Events
COPY "./Services/Identity.Api" "./Services/Identity.Api"
COPY "./Foundation/Events" "./Foundation/Events"

# Exécuter la commande "dotnet restore {nom_du_projet.csproj}"
RUN dotnet restore "./Services/Identity.Api/identity.api.csproj"

# Faites une copie intégrale
COPY . .

# Placez vous dans le dossier du projet (dossier qui contient le fichier csproj)
WORKDIR /src/Services/Identity.Api

# Exécuter commande "dotnet build "{nom_du_projet.csproj}" -c Release -o /app/build"
RUN dotnet build "identity.api.csproj" -c Release -o /app/build

# Depuis l'image build vers une nouvelle image qui vous nomerez "publish"
FROM build AS publish

# éxécuter la commande "dotnet publish "{nom_du_projet.csproj}" -c Release -o /app/publish"
RUN dotnet publish "identity.api.csproj" -c Release -o /app/publish


# Depuis l'image base vers une nouvelle image qui vous nomerez "final"
FROM base AS final

# placez-vous dans le dossier /app,
WORKDIR /app

# copier ce que vous avez créer dans l'image publish vers le dossier /app/publish de l'image final.
COPY --from=publish /app/publish .

# Exécuter le entrypoint suivant: ["dotnet", "{nom_du_projet.dll}"]
ENTRYPOINT ["dotnet", "identity.api.dll"]