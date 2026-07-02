# Despliegue de SIGTICK (GLPI) en producción

Guía del despliegue de **SIGTICK / GLPI 11** en **Dokploy** (Docker Swarm + Traefik),
con base de datos **MariaDB** interna y **Cloudflare** al frente.

- **URL producción:** https://sigtick.grupo-santacruz.com/
- **Repo:** https://github.com/Johnnyr-beep/SIGTICK (rama `master`)
- **Servidor:** `20.121.178.90` (Dokploy)

---

## Arquitectura

```
Navegador
   │  HTTPS (🔒 cert de Cloudflare)
   ▼
Cloudflare  ──(SSL Flexible solo para sigtick, vía Page Rule)──►  HTTP :80
   │
   ▼
Traefik (Docker Swarm, en el servidor)
   │  router "web" → service
   ▼
Contenedor App GLPI  (servicio Dokploy  ticketapp-...-hn58lt, Apache :80)
   │  mysqli
   ▼
MariaDB  (servicio Dokploy  ticketapp-...-vnbz4n : 3306, base  TICKETS_DB)
```

- **App:** imagen construida desde el `Dockerfile` del repo (`php:8.2-apache`, DocumentRoot `/public`).
- **BD:** servicio MariaDB de Dokploy en la misma red privada. Host interno:
  `ticketapp-aplicacion-de-tickets-de-soporte-vnbz4n:3306`, base `TICKETS_DB`.

---

## Variables de entorno (Dokploy → servicio App → Environment)

Los secretos **no** van en el repo: se inyectan por variables de entorno y el
`docker-entrypoint.sh` genera `config/config_db.php` al arrancar.

```
GLPI_DB_HOST=ticketapp-aplicacion-de-tickets-de-soporte-vnbz4n
GLPI_DB_PORT=3306
GLPI_DB_USER=root
GLPI_DB_PASSWORD=********           # ver credenciales del servicio MariaDB en Dokploy
GLPI_DB_NAME=TICKETS_DB
GLPI_CRYPT_KEY_B64=****************  # base64 de config/glpicrypt.key (descifra SMTP/LDAP)
```

> Alternativa: `GLPI_DB_URL=mariadb://user:pass@host:3306/db` (el entrypoint también lo parsea).

### Cómo obtener `GLPI_CRYPT_KEY_B64`
La llave `config/glpicrypt.key` son 32 bytes binarios; hay que pasarla en base64:
```bash
base64 -w0 < config/glpicrypt.key
```

---

## Cómo arranca el contenedor (`docker-entrypoint.sh`)

En cada arranque el entrypoint:
1. Genera `config/config_db.php` a partir de `GLPI_DB_*` (o de una URL `*_URL`).
2. Restaura `config/glpicrypt.key` desde `GLPI_CRYPT_KEY_B64` (base64) — clave para
   que GLPI pueda **descifrar** las contraseñas guardadas (SMTP, IMAP, LDAP).
3. Si la plataforma inyecta `$PORT` distinto de 80, reconfigura Apache a ese puerto
   (en Dokploy no aplica: Apache queda en :80).

Logs esperados al arrancar:
```
[entrypoint] Generando config_db.php -> host=...-vnbz4n:3306 db=TICKETS_DB
[entrypoint] glpicrypt.key restaurada desde GLPI_CRYPT_KEY_B64 (base64).
AH00094: Command line: 'apache2 -D FOREGROUND'
```

---

## Enrutado en Traefik (Dokploy → servicio App → Advanced → Traefik)

La app se sirve por el entrypoint **web (80)**. Cloudflare pone el HTTPS público.
Config que funciona (nombres `-18` son los que genera Dokploy para el dominio):

```yaml
http:
  routers:
    ticketapp-aplicacion-de-tickets-de-soporte-hn58lt-router-18:
      rule: Host(`sigtick.grupo-santacruz.com`)
      service: ticketapp-aplicacion-de-tickets-de-soporte-hn58lt-service-18
      entryPoints:
        - web
  services:
    ticketapp-aplicacion-de-tickets-de-soporte-hn58lt-service-18:
      loadBalancer:
        servers:
          - url: http://ticketapp-aplicacion-de-tickets-de-soporte-hn58lt:80
        passHostHeader: true
```

> ⚠️ **Importante:** NO usar `middlewares: [redirect-to-https]` ni
> `tls: { certResolver: letsencrypt }`. Con el dominio detrás de Cloudflare, Let's
> Encrypt **no valida** y Traefik deja de crear la ruta → **404**. Este fue el bug.

---

## Cloudflare

- El dominio `grupo-santacruz.com` está proxeado por Cloudflare (nube naranja).
- El **modo SSL global** del dominio **NO se cambió** (sigue como estaba para no afectar
  las otras apps: routeplanner, helpdesk, etc.).
- Para `sigtick` se creó una **Page Rule**:
  - **URL:** `sigtick.grupo-santacruz.com/*`
  - **Setting:** `SSL` → **`Flexible`**
  - Así Cloudflare conecta al origen por **HTTP :80** solo para este subdominio.

---

## Actualizar / re-desplegar

1. `git push` a `master` en el repo SIGTICK.
2. En Dokploy: servicio App → **Deployments → Redeploy** (o el webhook configurado).

> ⚠️ La config de Traefik del Advanced es **manual**. Si un redeploy la regenera con
> `redirect-to-https` + `letsencrypt`, el sitio vuelve a dar 404. En ese caso, reaplica
> el YAML de arriba (botón **Modify**) o deja el dominio en el UI con **HTTPS OFF / Cert None**.

---

## Solución de problemas

| Síntoma | Causa probable | Fix |
|---|---|---|
| `404 page not found` (de Traefik) | No hay ruta para el host | Revisar el YAML de Traefik (sin redirect/letsencrypt) |
| 404 solo vía Cloudflare, `curl` directo :80 = 200 | Cloudflare en modo Full pega al :443 | Page Rule SSL → Flexible para el subdominio |
| Pantalla de instalación de GLPI | Falta `config_db.php` / variables `GLPI_DB_*` | Poner las variables en Environment y redeploy |
| Notificaciones/SMTP no descifran | Falta `glpicrypt.key` correcta | Setear `GLPI_CRYPT_KEY_B64` con la llave original |

Verificación rápida desde fuera:
```bash
# Origen directo (salta Cloudflare): debe dar 200 y HTML de GLPI
curl -s -o /dev/null -w "%{http_code}\n" -H "Host: sigtick.grupo-santacruz.com" http://20.121.178.90/

# Público (vía Cloudflare): debe dar 200
curl -s -o /dev/null -w "%{http_code}\n" https://sigtick.grupo-santacruz.com/
```

---

## Pendientes de seguridad

El repo estuvo **público unos minutos** con secretos en el historial antes de purgarlo
(`git filter-branch`). Por precaución, **rotar**:

- [ ] Contraseña de la BD (`Root` → una fuerte) y actualizar `GLPI_DB_PASSWORD`.
- [ ] Regenerar `config/glpicrypt.key` (implica re-guardar contraseñas SMTP/LDAP en GLPI)
      y actualizar `GLPI_CRYPT_KEY_B64`.
- [ ] Regenerar las llaves OAuth (`config/oauth.pem` / `oauth.pub`).
