FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY Shorten/Shorten.sln ./Shorten/
COPY Shorten/src/Shorten.csproj ./Shorten/src/
RUN dotnet restore ./Shorten/src/Shorten.csproj
COPY Shorten ./Shorten
RUN dotnet publish ./Shorten/src/Shorten.csproj -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Shorten.dll"]
