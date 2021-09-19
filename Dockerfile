FROM mcr.microsoft.com/dotnet/sdk:5.0 as build
RUN dotnet tool install --global dotnet-ef
ENV PATH="${PATH}:/root/.dotnet/tools"

COPY . /app
WORKDIR /app/
RUN dotnet ef database update
RUN dotnet publish -c Release -o output


FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
COPY --from=build /app/output .
COPY --from=build /app/Movies.db .
ENTRYPOINT ["dotnet", "FilmeApp.dll"]