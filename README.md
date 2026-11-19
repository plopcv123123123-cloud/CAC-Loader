# CAC Mass Exporter — Loader público

Este repositorio es **el punto de entrada permanente** de CAC Mass Exporter Premium. Aquí solo guardamos el cargador; **el exportador privado y las claves de administrador NO se publican aquí**.

## Un único comando para todas las versiones

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/plopcv123123123-cloud/CAC-Loader/main/loader.lua"))()
```

La URL usa la rama `main`, no un archivo etiquetado con una versión. Cuando actualicemos `loader.lua`, los usuarios recibirán ese loader en una ejecución posterior, una vez que la caché se haya renovado.

### ¿Cómo se actualiza CAC Mass Exporter?

**Loader o pantalla de activación:** hacemos un commit de `loader.lua` a este repositorio público. **Exportador principal:** publicamos la versión probada en el almacenamiento privado `RELEASES` de Cloudflare; el endpoint `/load` comprueba una sesión autorizada y entrega la release `cac:stable`.

**El comando de los usuarios no cambia**; no es necesario publicar el exportador principal en este repositorio. Las actualizaciones se cargan en la *siguiente ejecución*; no sustituyen por sí solas una sesión de Roblox ya abierta.

### Publicación y control de versiones

1. Guardar los cambios del exportador en un repositorio **privado** de GitHub (pendiente de crear).
2. Probar primero la versión candidata, especialmente la exportación RBXM y los accesorios.
3. Publicar el archivo privado en Cloudflare KV (`cac:stable`) mediante un despliegue autorizado.
4. Registrar la versión y sus cambios en `CHANGELOG.md`; actualizar este loader solo si cambia su interfaz o protocolo.
5. Si falla una versión, volver a publicar la última release estable.

Podemos configurar GitHub Actions en el repositorio **privado** para publicar automáticamente en Cloudflare después de aprobar los cambios; no debe utilizarse una publicación automática de cada edición sin pruebas.

## Estado actual — pendiente de integración

- [x] URL permanente y loader público publicado
- [x] GitHub conectado para realizar futuros commits
- [ ] Servidor de licencias Cloudflare desplegado y verificado
- [ ] Binding KV `RELEASES` configurado
- [ ] Módulo privado publicado como `cac:stable`
- [ ] Primera key de prueba activada y reanudación verificada
- [ ] Exportación RBXM validada desde el loader
- [ ] Repositorio privado y despliegue automatizado configurados

**La versión v1.7 BETA está preparada para pruebas locales, NO está publicada como release estable.** No anunciarla como actualización instalada hasta superar las comprobaciones.

## Seguridad

- Nunca guardar `ADMIN_TOKEN`, keys de clientes o código privado en este repositorio público.
- El identificador guardado en el cliente no es un HWID seguro y el código recibido puede inspeccionarse. La licencia y su revocación se verifican en el servidor.
- GitHub y Cloudflare pueden tener cachés; las actualizaciones no se propagan de forma instantánea en todas las ubicaciones.
- Revisa la licencia del serializador de terceros y los términos de las plataformas involucradas antes de distribuirlo.
