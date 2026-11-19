# CAC Mass Exporter — Historial de versiones

> **Aviso:** una versión desarrollada no significa que esté publicada en Cloudflare ni disponible para compradores.

## v1.7.0 BETA — En pruebas locales (NO desplegada)

- Nueva interfaz negra y azul y búsqueda por `Ctrl+F`.
- Vista 3D, zoom, rotación, fondos y cámaras.
- Player Dumper, Code Dumper y búsqueda dentro de outfits capturados.
- Temas, favoritos y filtros guardados localmente.
- Exportación RBXM preservada a partir de la versión anterior.
- Pendientes: PNG 2048px, búsqueda global, códigos no cargados y poses `AnimationConstraint`.

## v1.6 — Loader público (GitHub)

- Pantalla de activación y reanudación de sesión.
- Solicitudes `/activate`, `/session/resume` y `/load` al Worker de licencias.
- La licencia sigue siendo permanente mientras esté autorizada y el servidor permita reanudar sesiones.
- El servicio Cloudflare aún necesita terminarse y validarse en producción.

## Política de actualización

El archivo `loader.lua` público puede recibir commits cuando cambie la lógica del cargador. Las versiones del **exportador privado** se publicarán desde un repositorio privado a Cloudflare KV después de pasar pruebas. El comando de ejecución público permanece igual; una actualización del exportador no requiere cambiarlo.

Las actualizaciones no modifican automáticamente sesiones de Roblox ya abiertas.
