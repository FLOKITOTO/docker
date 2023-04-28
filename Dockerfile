FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-stretch-slim AS base

WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.1-stretch AS build
WORKDIR /src
COPY "./Services/Identity.Api" "./Services/Identity.Api"
COPY "./Foundation/Events" "./Foundation/Events"

RUN dotnet restore "./Services/Identity.Api/identity.api.csproj"

COPY . .

WORKDIR /src/Services/Identity.Api

RUN dotnet build "identity.api.csproj" -c Release -o /app/build

FROM build AS publish

RUN dotnet publish "identity.api.csproj" -c Release -o /app/publish

FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENV RABBITMQ_HOST=rabbitmq

ENTRYPOINT ["dotnet", "identity.api.dll"]