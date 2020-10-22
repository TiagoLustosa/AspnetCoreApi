FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /src
COPY ["ProductCatalog.csproj", "./"]
RUN dotnet restore "ProductCatalog.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ProductCatalog.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ProductCatalog.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ProductCatalog.dll"]
