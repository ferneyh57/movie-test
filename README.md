# Movie & Series App

## Demo

![Demo](demo.gif)

Flutter app que consume la [TMDB API](https://developers.themoviedb.org/) para explorar películas y series.

## Features

- Películas y series categorizadas por Popular y Top Rated, con paginación infinita
- Detalle de película y serie
- Buscador por nombre (películas y series), con paginación en resultados
- Shimmer skeletons en todos los estados de carga — sin `CircularProgressIndicator`
- Banner destacado con rotación automática y puntos animados
- Hero animations entre lista y detalle
- Scroll horizontal suave (placeholder e imagen comparten el mismo tamaño fijo)

## Arquitectura

Clean Architecture con tres capas:

```
data/
  datasources/   → Clientes Retrofit + implementaciones de datasource
  models/        → Modelos Freezed + JSON serializable (espeja la respuesta de la API)
  repositories/  → Implementa interfaces del dominio, mapea modelos a entidades
  mappers/       → Conversión Model → Entity

domain/
  entities/      → Clases Dart simples (Movie, Series)
  repositories/  → Interfaces abstractas
  usecases/      → Casos de uso de responsabilidad única

presentation/
  cubit/         → Un Cubit por carrusel/feature; el estado contiene el response model de la API
  pages/         → Widgets stateless/stateful, BlocBuilder por sección
```

El estado de cada cubit contiene directamente `MovieListResponseModel` / `SeriesListResponseModel` — sin wrapper intermedio — de modo que los datos de paginación (`page`, `totalPages`) fluyen sin transformación desde el datasource hasta la UI. `hasMore` y el mapeo a entidades se exponen como getters en la clase de estado Freezed.

## Bibliotecas

| Biblioteca | Propósito |
|---|---|
| `flutter_bloc` | State management (Cubit) |
| `dio` + `retrofit` | Cliente HTTP con cliente API generado |
| `get_it` | Inyección de dependencias |
| `freezed` | Modelos y estados inmutables con `copyWith` |
| `go_router` | Navegación y routing |
| `cached_network_image` | Cache de imágenes |
| `shimmer` | Skeletons de carga |
| `bloc_test` + `mocktail` | Tests unitarios |

> El ejercicio recomienda Riverpod y Fluro. Se eligió BLoC/Cubit por su encaje natural con Clean Architecture (cada cubit tiene una sola responsabilidad) y GoRouter por su soporte oficial en el ecosistema Flutter.

## Setup

Requiere un Access Token de TMDB (Bearer token, distinto de la API key).

```bash
flutter pub get
flutter run --dart-define=TMDB_ACCESS_TOKEN=your_token
```

## Tests

```bash
flutter test
```

Cobertura actual:
- `MovieListState` — getter `hasMore` (casos límite) y mapeo `movies`
- `PopularMoviesCubit` — carga inicial (éxito/fallo), `loadMore` (acumulación, guard última página, guard llamadas concurrentes)
- `SearchCubit` — carga popular inicial, búsqueda por query, clear query, `loadMoreMovies`, `loadMoreSeries`

## Qué agregaría con más tiempo

**Más cobertura de tests**
- `SeriesListState` y los cubits restantes (`TopRatedMoviesCubit`, `PopularSeriesCubit`, `TopRatedSeriesCubit`) comparten lógica idéntica con el cubit ya testeado.
- Tests de repositorios (mock del datasource, verificar mapping).
- Widget tests para `MediaCarousel`, `MediaCard` y `FeaturedBanner`.

**Estados de error**
- Los cubits del home (`MovieListState`, `SeriesListState`) fallan silenciosamente — emiten estado vacío. `SearchState` sí tiene campo `errorMessage` pero la UI no lo muestra aún. Falta: mostrar el error al usuario y agregar botón de reintento en ambos flujos.

**Soporte offline**
- Cachear respuestas localmente con `Hive` o `drift` para que la app funcione sin conectividad.

**Filtros**
- Filtrar por género, año o rating — TMDB los soporta como query params.

**Accesibilidad**
- Labels semánticos en `MediaCard` y widgets `Hero`.
- Auditoría de contraste de colores.

## Uso de IA

Se utilizó Claude (Anthropic) como asistente de código a través de Claude Code (CLI). La colaboración abarcó:

- Scaffolding inicial y estructura de Clean Architecture
- Implementación del patrón BLoC/Cubit con cubits por fila
- Componentes shimmer skeleton y fix del sizing del placeholder en `CachedNetworkImage`
- Fix del bug de Hero animations (tags duplicados entre carruseles)
- Propagación de paginación: threading de `MovieListResponseModel` / `SeriesListResponseModel` a través de todas las capas para que los cubits usen `page < totalPages`
- Scaffolding de tests unitarios con `bloc_test` y `mocktail`

Todo el código generado fue revisado y refinado iterativamente. Las decisiones arquitectónicas (usar el response model directamente en lugar de un wrapper genérico `Page<T>`, un cubit por carrusel en lugar de un `HomeCubit` compartido) se tomaron colaborativamente priorizando simplicidad y mantenibilidad.
