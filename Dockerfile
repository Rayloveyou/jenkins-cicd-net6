FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80



FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["WebApi.csproj", "."]
RUN dotnet restore "./WebApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "WebApi.csproj" -c Release -o /app/build



FROM build AS publish

RUN dotnet publish "WebApi.csproj" -c Release -o /app/publish /p:UseAppHost-false



FROM base AS final

RUN addgroup --system --gid 1001 fullstack
RUN adduser --system --uid 1001 fullstack

WORKDIR /app

COPY --from=publish /app/publish .

RUN chown -R fullstack:fullstack /app

USER fullstack

ENTRYPOINT [ "dotnet", "WebApi.dll" ]
