# Resultados Elecciones Perú 2026

App nativa de iOS para seguir **en tiempo real** los resultados de las Elecciones Generales del Perú 2026, con datos oficiales de la **ONPE**. Incluye un **widget** de pantalla de inicio con el conteo de la segunda vuelta.

<p align="left">
  <img alt="iOS" src="https://img.shields.io/badge/iOS-17%2B-black?logo=apple">
  <img alt="Swift" src="https://img.shields.io/badge/Swift-5.0-orange?logo=swift">
  <img alt="SwiftUI" src="https://img.shields.io/badge/SwiftUI-WidgetKit-blue">
</p>

## Características

- 📊 **Resultados** — porcentaje por candidato, ordenados, con logo y color de partido.
- 📈 **Avance** — porcentaje de actas contabilizadas y participación.
- ℹ️ **Proceso** — detalle del proceso electoral activo + datos del proyecto.
- 🧩 **Widget** (pequeño y mediano) con el marcador de la segunda vuelta, refrescado cada 5 min.
- 🔄 Auto-refresco cada 5 minutos y *pull-to-refresh*.

## Stack

- **SwiftUI** + **WidgetKit** (iOS 17+).
- Arquitectura **MVVM** con `@Observable`.
- Networking con `URLSession` y `async/await`, sin dependencias externas.
- Datos compartidos entre app y widget vía **App Group**.

```
resultados-elecciones/
├── Models/        # Candidato, Totales, ProcesoElectoral, RespuestaAPI
├── Services/      # ClienteHTTP, ONPEServicio, Compartido (App Group)
├── ViewModels/    # ResultadosViewModel
├── Views/         # Resultados, Avance, Proceso, componentes
└── Theme/         # colores por partido
ResultadosWidget/  # extensión WidgetKit
```

## Datos

La app consume el backend público de resultados de la ONPE:

```
https://resultadosegundavuelta.onpe.gob.pe/presentacion-backend
```

Endpoints usados: `resumen-general/participantes`, `resumen-general/totales` y `proceso/proceso-electoral-activo`. Las peticiones envían cabeceras de navegador (Chrome) para pasar el WAF del servidor.

## Compilar y ejecutar

**Requisitos:** macOS con **Xcode 16+** y un dispositivo o simulador con **iOS 17+**.

1. Clona el repo:
   ```bash
   git clone https://github.com/Fabrizzio20k/resultados-elecciones.git
   cd resultados-elecciones
   ```
2. Abre el proyecto:
   ```bash
   open resultados-elecciones.xcodeproj
   ```
3. En **Signing & Capabilities**, selecciona tu propio **Team** de desarrollo y cambia el **Bundle Identifier** por uno único (ej. `com.tuusuario.resultados-elecciones`). Haz lo mismo para el target del widget.
4. Verifica que el **App Group** sea el mismo en la app y en el widget (necesario para que el widget lea los datos).
5. Elige un simulador o tu iPhone y pulsa **Run** (`⌘R`).

> El proyecto no requiere dependencias ni `pod install` / SPM — compila tal cual.

## Autor

Desarrollado por **Fabrizzio Vilchez** — [@Fabrizzio20k](https://github.com/Fabrizzio20k)

## Aviso

Proyecto independiente y **sin fines de lucro**, sin afiliación con la ONPE. Los datos pertenecen a la Oficina Nacional de Procesos Electorales (ONPE) y se usan solo con fines informativos.
