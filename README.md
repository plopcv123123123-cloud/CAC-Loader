# CAC Mass Exporter — Public Loader

Este repositorio contiene exclusivamente `loader.lua`, el cargador público. **No contiene el exportador original, las licencias de clientes ni secretos administrativos.**

## Uso (solo cuando se complete el servidor)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/plopcv123123123-cloud/CAC-Loader/main/loader.lua"))()
```

## Estado

- [x] Loader público publicado
- [x] URL del Worker configurada
- [ ] Worker Cloudflare v1.6 instalado y probado
- [ ] Binding `RELEASES` (Workers KV) configurado
- [ ] Módulo privado publicado a través de la API administrativa
- [ ] Activación, reanudación y revocación de una licencia de prueba verificadas
- [ ] Exportación RBXM validada desde el loader

El loader **no funcionará completamente** hasta completar los pasos pendientes. No publiques `ADMIN_TOKEN` ni el código fuente privado aquí.

## Seguridad

El identificador local usado por el loader **no es un HWID seguro**; puede copiarse. El código entregado a los clientes puede inspeccionarse. La verificación de licencias y revocaciones debe permanecer en el servidor. No se garantiza protección absoluta contra la copia o la ingeniería inversa.

Usa únicamente con autorización y teniendo en cuenta los términos de Roblox, Xeno y cualquier dependencia de terceros.
