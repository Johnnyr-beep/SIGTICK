# Manual del Administrador del Sistema

**Mesa de Ayuda TI – Grupo Empresarial Santacruz**
*Plataforma: GLPI 11 – `https://helpdesk.grupo-santacruz.com`*

> Para: **Administrador del sistema (TI Santacruz)**
> Perfil del sistema: **Super-Admin**

---

## Tabla de contenido

1. [Tu rol como administrador](#1-tu-rol-como-administrador)
2. [Arquitectura del sistema](#2-arquitectura-del-sistema)
3. [Acceso administrativo](#3-acceso-administrativo)
4. [Gestión de usuarios](#4-gestión-de-usuarios)
5. [Gestión de perfiles y permisos](#5-gestión-de-perfiles-y-permisos)
6. [Gestión de entidades (empresas / sucursales)](#6-gestión-de-entidades-empresas--sucursales)
7. [Gestión de grupos](#7-gestión-de-grupos)
8. [Configuración de notificaciones por correo](#8-configuración-de-notificaciones-por-correo)
9. [Plantillas de correo](#9-plantillas-de-correo)
10. [Recolector de correo (Mail Collector)](#10-recolector-de-correo-mail-collector)
11. [Reglas de negocio](#11-reglas-de-negocio)
12. [Sistema de turnos automáticos](#12-sistema-de-turnos-automáticos)
13. [Tareas programadas (Cron)](#13-tareas-programadas-cron)
14. [Categorías ITIL, ubicaciones, dropdowns](#14-categorías-itil-ubicaciones-dropdowns)
15. [Plugins instalados](#15-plugins-instalados)
16. [Personalización visual (Login Santacruz)](#16-personalización-visual-login-santacruz)
17. [Migración local ↔ producción](#17-migración-local-↔-producción)
18. [Respaldo y recuperación](#18-respaldo-y-recuperación)
19. [Mantenimiento y rutinas](#19-mantenimiento-y-rutinas)
20. [Troubleshooting común](#20-troubleshooting-común)

---

## 1. Tu rol como administrador

Eres responsable de:
- ✅ Mantener el sistema operativo y seguro
- ✅ Crear/desactivar usuarios y asignar perfiles
- ✅ Configurar entidades (empresas del grupo)
- ✅ Gestionar plantillas de correo y notificaciones
- ✅ Mantener el sistema de asignación automática
- ✅ Hacer respaldos periódicos
- ✅ Investigar incidentes del sistema (caída, lentitud)
- ✅ Coordinar con el proveedor de hosting Azure
- ✅ Migrar cambios de local a producción

---

## 2. Arquitectura del sistema

```
┌─────────────────────────────────────────────────────┐
│  USUARIOS (navegador web)                          │
└───────────────────────┬─────────────────────────────┘
                        │ HTTPS
              ┌─────────▼─────────┐
              │  Azure Web App     │
              │  helpdesk.grupo-   │
              │  santacruz.com     │
              │  (PHP 8.x)         │
              └─────────┬──────────┘
                        │
              ┌─────────▼──────────┐
              │  GitHub Repo       │
              │  (deploy auto)     │
              └────────────────────┘
                        │
              ┌─────────▼──────────┐
              │  MySQL Cloud       │
              │  20.121.178.90     │
              │  DB: TICKETS_DB    │
              └────────────────────┘

  Local de desarrollo: XAMPP en c:\xampp\htdocs\glpi
```

### Datos clave

| Componente | Detalle |
|---|---|
| **URL producción** | `https://helpdesk.grupo-santacruz.com` |
| **BD producción** | `20.121.178.90` / DB `TICKETS_DB` / user `root` |
| **Versión GLPI** | 11.0.6 |
| **Versión PHP** | 8.x |
| **MySQL** | MariaDB |
| **SMTP saliente** | `smtp.gmail.com:587` con cuenta `tisantacruz48@gmail.com` |
| **IMAP entrante** | `imap.gmail.com:993` (Gmail SSL) |
| **Local dev** | XAMPP, MySQL local `c:\xampp\mysql` |

---

## 3. Acceso administrativo

### A la aplicación web

URL: `https://helpdesk.grupo-santacruz.com`
Usuario admin: `glpi` (o el que tengas como Super-Admin)
Perfil: **Super-Admin**

### A la base de datos directa (MariaDB cloud)

```powershell
& "C:\xampp\mysql\bin\mysql.exe" -h 20.121.178.90 -u root -pRoot TICKETS_DB
```

> ⚠️ Cuidado: tu `config/config_db.php` local **apunta a la BD de producción**. Cualquier cambio que hagas en tu local afecta a producción.

### A los archivos del servidor Azure

A través del **portal Azure** → tu Web App → SCM / Kudu / FTP, o mediante despliegue desde GitHub.

---

## 4. Gestión de usuarios

### Crear un usuario nuevo

#### Paso 1
Menú → **Administración → Usuarios → ➕ Añadir**

#### Paso 2
Llena los campos obligatorios:
- **Identificador (login)**: ej. `juan.perez` (usa minúsculas, punto entre nombre y apellido)
- **Apellido** (realname)
- **Nombre** (firstname)
- **Contraseña** (genera una temporal y pídele cambiarla)
- **Correo electrónico** (corporativo)
- **Número de registro** (cédula)
- **Título** (cargo)
- **Entidad** (a qué empresa pertenece)
- **Perfil** (Usuario / Technician / Supervisor / Super-Admin)

> 📷 **CAPTURA 4.1** – Formulario completo de creación de usuario.

#### Paso 3
Guarda → el sistema le envía correo de bienvenida si lo tienes configurado.

### Cambiar el perfil de un usuario

#### Paso 1
Usuarios → abre el usuario → pestaña **Habilitaciones**

#### Paso 2
- Quita el perfil actual (clic en la ❌)
- Añade el nuevo perfil con su entidad

#### Paso 3
Guarda.

### Desactivar (no borrar) un usuario

> ⚠️ **Nunca borres usuarios**. Si se va de la empresa, **desactívalo**. Borrar pierde el histórico.

#### Paso 1
Abre el usuario → pestaña **Principal** → desmarca **Activo**

#### Paso 2
Guarda. El usuario ya no puede iniciar sesión pero sus tickets quedan en histórico.

### Resetear contraseña de un usuario

Abre el usuario → en el campo **Contraseña**, escribe la nueva → marca **Forzar cambio en próximo login** → Guarda.

---

## 5. Gestión de perfiles y permisos

### Perfiles activos

| ID | Nombre | Para quién |
|---|---|---|
| 1 | Usuario | Empleados regulares |
| 2 | Observer | Solo lectura ampliada |
| 3 | Admin | Líder TI con permisos casi totales |
| 4 | Super-Admin | TÚ – administrador total |
| 5 | Hotliner | Recepción que registra casos |
| 6 | Technician | Julio, Marco, Sebastian, Anthony |
| 7 | Supervisor | Coordinador del equipo TI |
| 8 | Read-Only | Auditoría |

### Editar permisos de un perfil

#### Paso 1
Menú → **Administración → Perfiles → [nombre]**

#### Paso 2
Pestañas a la izquierda:
- **Activos** → permisos de inventario
- **Asistencia** → permisos de tickets/cambios/problemas
- **Gestión** → contratos, documentos
- **Herramientas** → KB, reservas
- **Administración** → usuarios, perfiles, entidades
- **Configuración** → solo Super-Admin

#### Paso 3
Marca/desmarca permisos (Crear, Leer, Actualizar, Borrar, Purgar) y guarda.

> 📷 **CAPTURA 5.1** – Matriz de permisos de un perfil.

### Crear un perfil nuevo

#### Paso 1
Perfiles → **➕ Añadir**

#### Paso 2
Nombre + interfaz (`Central` para técnicos, `Self-Service` para usuarios finales)

#### Paso 3
Una vez creado, asigna permisos pestaña por pestaña.

---

## 6. Gestión de entidades (empresas / sucursales)

Las **entidades** modelan la estructura organizacional del grupo.

### Estructura actual

```
GRUPO SANTACRUZ (id=0, raíz)
├── AGROPECUARIA (id=1)
├── CARNES SANTACRUZ (id=2)
│   ├── PDV-PEREIRA (id=5)
│   ├── PDV-SIMON BOLIVAR (id=9)
│   ├── PDV-CENTRO (id=10)
│   ├── ... (varios PDV)
│   └── OFICINAS CARNES SANTACRUZ (id=20)
├── INVERSIONES SERRANO MILLAN (id=3)
├── CONTABILIDAD (id=21)
├── DESPACHO (id=22)
├── FACTURACION (id=23)
├── MONTERIA (id=24)
├── MANTENIMIENTO (id=25)
└── PRODUCCION (id=26)
```

### Crear una entidad nueva

#### Paso 1
Menú → **Administración → Entidades**

#### Paso 2
Selecciona la entidad **padre** (ej. CARNES SANTACRUZ) → clic en **➕ Añadir hija**

#### Paso 3
Llena:
- **Nombre completo** (ej. `PDV-VALLEDUPAR`)
- **Información de la entidad** (dirección, teléfono)

#### Paso 4
Guarda.

> 📷 **CAPTURA 6.1** – Árbol de entidades.

### Configuración de entidad (visible solo para esa entidad)

Cada entidad puede tener:
- Logo propio (pestaña *Información de la entidad*)
- Configuración de notificaciones propias
- Calendario laboral propio
- Etc.

---

## 7. Gestión de grupos

Los grupos son agrupaciones funcionales (NO empresas, eso son las entidades).

### Grupos clave del sistema

| Grupo | Función |
|---|---|
| **Soporte TI** | Recibe todos los tickets para visibilidad colectiva |

### Crear un grupo

#### Paso 1
Menú → **Administración → Grupos → ➕ Añadir**

#### Paso 2
Llena:
- **Nombre**
- **Comentario**
- **Visibles en** (selecciona las casillas: solicitante, asignación, etc.)

#### Paso 3
Guarda.

#### Paso 4
Pestaña **Usuarios** → añade los miembros del grupo.

---

## 8. Configuración de notificaciones por correo

### Verificar el envío SMTP

#### Paso 1
Menú → **Configuración → Notificaciones → Configurar correo electrónico**

#### Paso 2
Datos actuales:

| Campo | Valor |
|---|---|
| Modo | SMTP+SSL/TLS |
| Servidor | `smtp.gmail.com` |
| Puerto | `587` |
| Usuario | `tisantacruz48@gmail.com` |
| Contraseña | (Gmail App Password, **no la del correo**) |
| Desde | `tisantacruz48@gmail.com` |
| Nombre desde | `Soporte Santacruz` |

#### Paso 3
Botón **Probar el envío de correo** → debe llegar a tu bandeja en segundos.

> 📷 **CAPTURA 8.1** – Pantalla de configuración SMTP.

### Si necesitas cambiar la contraseña de Gmail

1. Genera nuevo **App Password** en `https://myaccount.google.com/apppasswords`
2. Pégalo en el campo **Contraseña**
3. Guarda
4. Prueba el envío

---

## 9. Plantillas de correo

Hay 32 plantillas customizadas con branding Santacruz (verde corporativo, logo).

### Editar una plantilla

#### Paso 1
Menú → **Configuración → Notificaciones → Plantillas de notificaciones**

#### Paso 2
Selecciona la plantilla (ej. *"Tickets"* id=4 para tickets nuevos)

#### Paso 3
Pestaña **Traducciones** → selecciona el idioma → edita HTML

#### Paso 4
Variables disponibles (ejemplos):
- `##ticket.id##` – número del ticket
- `##ticket.title##` – título
- `##ticket.url##` – enlace directo
- `##ticket.requester##` – nombre del solicitante
- Lista completa: clic en el botón **"Etiquetas"** en la plantilla

> 📷 **CAPTURA 9.1** – Editor de plantilla con variables.

### ⚠️ Importante: si editas HTML directamente en BD

Las plantillas se guardan en `glpi_notificationtemplatetranslations.content_html`. NO uses la BD para esto — usa la UI. Si lo haces mal puede salir HTML escapado y los correos se ven con tags `<p>` literales.

---

## 10. Recolector de correo (Mail Collector)

GLPI revisa cada **10 minutos** un buzón Gmail para convertir correos entrantes en tickets.

### Configuración actual

| Campo | Valor |
|---|---|
| Nombre | `Buzon Soporte Gmail` |
| Servidor | `{imap.gmail.com:993/imap/ssl/validate-cert/notls/secure}INBOX` |
| Login | `tisantacruz48@gmail.com` |
| Contraseña | (Gmail App Password) |
| Solo no leídos | ✅ Sí |
| Borrar después | No (los marca como leídos) |

### Ver / editar el recolector

Menú → **Configuración → Recolectores → Buzon Soporte Gmail**

> 📷 **CAPTURA 10.1** – Configuración del mail collector.

### Forzar la recolección manualmente

#### Opción 1 – Desde UI
Ve a Recolectores → abre el collector → botón **"Recolectar correos ahora"**

#### Opción 2 – Por terminal local
```powershell
cd c:\xampp\htdocs\glpi
C:\xampp\php\php.exe front\cron.php --force mailgate
```

### Si llegan correos pero NO se crean tickets

1. Verifica que el correo entrante esté **No leído** en Gmail
2. Revisa los logs en `files/_log/php-errors.log`
3. Comprueba que la contraseña IMAP siga válida

---

## 11. Reglas de negocio

Las reglas se ejecutan al crear/modificar tickets.

### Ver reglas activas

Menú → **Administración → Reglas → Reglas de negocio para tickets**

Reglas Santacruz (uuid empieza con `SC-RR-`):

| ID | Nombre | Hora |
|---|---|---|
| SC-RR-1 | Julio (06:30-08:00) | L-V mañana temprano |
| SC-RR-2 | Marco (08:00-11:00) | L-V mañana media |
| SC-RR-3 | Sebastian (11:00-12:30) | L-V prealmuerzo |
| SC-RR-4 | Anthony (14:00-17:00) | L-V tarde |
| SC-RR-5 | Sebastian (17:00-20:00) | L-V noche |

> 📷 **CAPTURA 11.1** – Lista de reglas con sus criterios.

### Editar una regla por UI

#### Paso 1
Reglas → abre la regla → pestañas **Criterios** y **Acciones**

#### Paso 2
Modifica y guarda.

### Cómo funcionan estas reglas

Usan el criterio **"Fecha de creación es hora laboral en calendario"**.
Cada técnico tiene un *calendario personalizado* con sus horarios. Si la hora del ticket cae en su calendario → la regla asigna al técnico.

### Recrear las reglas desde cero

Si necesitas resetear todo, ejecuta:
```powershell
cmd /c "C:\xampp\mysql\bin\mysql.exe -h 20.121.178.90 -u root -pRoot TICKETS_DB < migration_prod\09_rules_v2.sql"
```

---

## 12. Sistema de turnos automáticos

### Concepto

Cada técnico tiene un **calendario personalizado** con su horario. El criterio de regla **"Fecha de creación es hora laboral en calendario"** compara la hora del ticket nuevo con cada calendario.

### Ver calendarios

Menú → **Configuración → Listas desplegables → Calendarios → buscar "SC-Turno"**

Calendarios actuales:
- `SC-Turno Julio (06:30-08:00 L-V)`
- `SC-Turno Marco (08:00-11:00 L-V)`
- `SC-Turno Sebastian AM (11:00-12:30 L-V)`
- `SC-Turno Anthony (14:00-17:00 L-V)`
- `SC-Turno Sebastian PM (17:00-20:00 L-V)`

### Cambiar el horario de un técnico

#### Opción A – Por UI (más simple para cambios chicos)
1. Abre el calendario del técnico → pestaña **Periodos de tiempo**
2. Edita las horas de cada día
3. Guarda
4. **Importante:** clic en **"Limpiar caché de calendarios"** (botón arriba)

#### Opción B – Por SQL (si son cambios grandes)
Edita `migration_prod\09_rules_v2.sql` y re-ejecútalo:
```powershell
cmd /c "C:\xampp\mysql\bin\mysql.exe -h 20.121.178.90 -u root -pRoot TICKETS_DB < migration_prod\09_rules_v2.sql"
```

> ⚠️ Después de cambiar calendarios, **limpia la caché** del sistema:
> ```powershell
> Remove-Item c:\xampp\htdocs\glpi\files\_cache\* -Recurse -Force
> ```

---

## 13. Tareas programadas (Cron)

GLPI usa **cron** para tareas en segundo plano.

### Tareas críticas configuradas

| Nombre | Frecuencia | Función |
|---|---|---|
| `queuednotification` | 60 s | Envía correos en cola |
| `queuednotificationclean` | 86400 s (diario) | Limpia cola vieja |
| `mailgate` | 600 s | Recolecta correos IMAP |
| `mailgateerror` | 86400 s | Reintenta correos fallidos |

### Ver estado del cron

Menú → **Configuración → Acciones automáticas**

> 📷 **CAPTURA 13.1** – Lista de cron tasks con estado y última ejecución.

### Forzar una tarea

Abre la tarea → botón **Ejecutar**

O por terminal:
```powershell
cd c:\xampp\htdocs\glpi
C:\xampp\php\php.exe front\cron.php --force <nombre_tarea>
```

### En producción (Azure)

El servidor Linux tiene crontab:
```bash
* * * * * /usr/bin/php /home/site/wwwroot/front/cron.php >/dev/null 2>&1
```

Confirma con el equipo Azure que esté activo.

---

## 14. Categorías ITIL, ubicaciones, dropdowns

### Categorías ITIL (tipos de problemas)

Menú → **Configuración → Listas desplegables → Categorías ITIL**

Recomendado mantener una jerarquía:
- Hardware
  - Computador
  - Impresora
  - Monitor
- Software
  - Sistema operativo
  - Office
  - SAP
- Red
  - WiFi
  - Cable
  - VPN
- Correo / Comunicaciones

### Ubicaciones

Menú → **Configuración → Listas desplegables → Ubicaciones**

Estructura sugerida:
```
GRUPO SANTACRUZ
├── PDV-PEREIRA (dirección, teléfono)
├── PDV-CENTRO
└── OFICINAS PRINCIPALES
    ├── Sala de reuniones
    ├── Bodega
    └── Recepción
```

---

## 15. Plugins instalados

| ID | Plugin | Versión | Estado | Función |
|---|---|---|---|---|
| 1 | Data Injection | 2.15.6 | ✅ Activo | Importar CSV masivos |
| 2 | Print to PDF | 4.1.2 | ✅ Activo | PDF con branding Santacruz |
| 3 | Behaviours | 3.0.7 | ✅ Activo | Reglas avanzadas de tickets |
| 4 | Additional Fields | 1.24.0 | ⚠️ State=4 | Campos custom |
| 7 | WhatsApp | 0.1.0 | ⚠️ State=2 (instalado, no activo) | Pendiente activar |
| 8 | Auto Inventario | 1.0.0 | ⚠️ State=2 | Inventario automático |

### Gestionar plugins

Menú → **Configuración → Plugins**

- **Instalar:** clic en "Instalar"
- **Activar / Desactivar:** botones de la lista
- **Configurar:** clic en el nombre del plugin

### Plugin PDF — Configuración Santacruz

- Logo personalizado: `plugins/pdf/custom/LOGOFINAL.jpeg`
- Permisos: Admin, Super-Admin, Technician, Supervisor → habilitado (rights=1)
- Color de cabecera de tablas: verde `RGB(46,125,50)`
- Acta de entrega completa para computadores en `plugins/pdf/inc/computer.class.php`

---

## 16. Personalización visual (Login Santacruz)

### Archivos clave

| Archivo | Función |
|---|---|
| `templates/layout/page_login_santacruz.html.twig` | Layout split-screen con hero verde |
| `templates/pages/login.html.twig` | Formulario de login en español |

### Logo del login

Se carga desde `pics/logos/logo-GLPI-100-white.png`. Si quieres cambiarlo:
1. Sube el nuevo logo a `public/pics/logos/`
2. Edita la ruta en `page_login_santacruz.html.twig` línea ~323

### Colores Santacruz

Definidos en `:root` del layout:
```css
--sc-green: #2E7D32;
--sc-green-dark: #1B5E20;
--sc-green-light: #66BB6A;
--sc-green-soft: #E8F5E9;
```

### Después de cualquier cambio Twig

```powershell
Remove-Item c:\xampp\htdocs\glpi\files\_cache\* -Recurse -Force
```

Luego `Ctrl+F5` en el navegador.

---

## 17. Migración local ↔ producción

### Flujo de trabajo recomendado

1. **Desarrollas en local** (XAMPP con BD local)
2. Cuando algo está listo:
   - Si fueron cambios de UI (templates, CSS): commit + push a GitHub → Azure auto-despliega
   - Si fueron cambios de BD (categorías, reglas, etc.): genera SQL e impórtalo a producción

### Generar SQL de cambios

```powershell
cd c:\xampp\htdocs\glpi\migration_prod
powershell -ExecutionPolicy Bypass -File .\export_full.ps1
```

Genera `full_export.sql` con todas las tablas críticas (sin contraseñas).

### Aplicar SQL a producción

```powershell
cmd /c "C:\xampp\mysql\bin\mysql.exe -h 20.121.178.90 -u root -pRoot TICKETS_DB < full_export.sql"
```

### Scripts existentes en `migration_prod/`

| Script | Para qué |
|---|---|
| `00_apply_all.sql` | Maestro: aplica todo en orden |
| `01_notification_templates.sql` | Plantillas de correo |
| `02_smtp_config.sql` | Configuración SMTP |
| `03_mailcollector.sql` | Mail collector |
| `05_activate_notifications.sql` | Activa notificaciones |
| `06_activate_crons.sql` | Activa cron tasks |
| `07_rules_round_robin.sql` | Reglas turnos (v1) |
| `08_weekend_rules.sql` | Reglas fines de semana |
| `09_rules_v2.sql` | Reglas turnos (v2 vigente) |
| `10_pdf_plugin_install.sql` | Reparación del plugin PDF |
| `full_export.sql` | Export completo automático |

---

## 18. Respaldo y recuperación

### Backup manual de la BD

```powershell
$ts = Get-Date -Format "yyyyMMdd_HHmmss"
& "C:\xampp\mysql\bin\mysqldump.exe" -h 20.121.178.90 -u root -pRoot TICKETS_DB > "c:\backups\glpi_$ts.sql"
```

### Backup de archivos (logo, custom, etc.)

```powershell
$ts = Get-Date -Format "yyyyMMdd_HHmmss"
Compress-Archive -Path c:\xampp\htdocs\glpi\plugins\pdf\custom, c:\xampp\htdocs\glpi\files\_pictures -DestinationPath "c:\backups\glpi_archivos_$ts.zip"
```

### Restauración de BD

```powershell
cmd /c "C:\xampp\mysql\bin\mysql.exe -h 20.121.178.90 -u root -pRoot TICKETS_DB < backup_xxxx.sql"
```

### Backup automático recomendado

Configura una **tarea programada** semanal con el script anterior. Guarda en una ubicación externa (OneDrive corporativo, Azure Blob).

### Backups ya realizados

| Fecha | Archivo |
|---|---|
| 2026-06-03 | `migration_prod\backup_cloud_20260603_163538.sql` |

---

## 19. Mantenimiento y rutinas

### Diaria
- ✅ Revisar tickets sin asignar (puede haber del finde)
- ✅ Verificar que el cron `mailgate` se ejecute (UI o logs)

### Semanal
- ✅ Backup de BD producción
- ✅ Revisar logs en `files/_log/`
- ✅ Verificar correos rechazados (Configuración → Notificaciones → Cola de correos)
- ✅ Limpiar caché si hubo deploy: `Remove-Item files/_cache/* -Recurse`

### Mensual
- ✅ Revisar usuarios inactivos y desactivar si corresponde
- ✅ Actualizar plugins si hay nueva versión
- ✅ Revisar estadísticas: tickets por categoría/técnico
- ✅ Actualizar artículos KB con nuevas soluciones recurrentes

### Anual
- ✅ Rotar contraseñas (admin, SMTP, IMAP)
- ✅ Renovar app passwords de Gmail
- ✅ Auditoría de permisos por perfil
- ✅ Backup completo + test de restauración

---

## 20. Troubleshooting común

### Los correos no se envían

1. Verifica que `use_notifications=1` y `notifications_mailing=1` en `glpi_configs`
2. Prueba SMTP desde **Configurar correo electrónico** → botón Test
3. Verifica el cron `queuednotification`:
   ```powershell
   C:\xampp\php\php.exe front\cron.php --force queuednotification
   ```
4. Revisa logs PHP: `files/_log/php-errors.log`

### Los tickets no se crean desde correo

1. Verifica que el cron `mailgate` esté activo
2. Confirma que los correos están **No leídos** en Gmail
3. Verifica la contraseña IMAP (Gmail App Password)
4. Logs: `files/_log/mail.log`

### Los tickets no se asignan automáticamente

1. Verifica que las reglas `SC-RR-*` estén **activas**
2. Verifica que los calendarios `SC-Turno*` existan
3. Re-ejecuta el script:
   ```powershell
   cmd /c "C:\xampp\mysql\bin\mysql.exe -h 20.121.178.90 -u root -pRoot TICKETS_DB < migration_prod\09_rules_v2.sql"
   ```
4. Limpia caché

### El PDF no muestra logo Santacruz

1. Verifica que existe el archivo: `plugins/pdf/custom/LOGOFINAL.jpeg`
2. Si no existe en producción, súbelo
3. En BD: `SELECT use_branding_logo FROM glpi_plugin_pdf_configs;` debe ser `0`

### Aparece "Unable to load plugin xxx"

```sql
DELETE FROM glpi_plugins WHERE directory='nombre_plugin';
```
Luego limpia caché.

### Login no carga el diseño Santacruz

1. Verifica que existan los archivos Twig
2. Limpia caché: `Remove-Item files/_cache/* -Recurse -Force`
3. `Ctrl+F5` en navegador

### Sesión expira muy rápido

Menú → **Configuración → General → Configuración de la sesión** → ajustar duración.

### "Acceso denegado" en una pantalla

Verifica perfil del usuario en **Mi configuración**. Cambia con el dropdown si tiene varios perfiles.

---

## Contacto del proveedor de hosting

> Completar con datos del responsable Azure:
> - Persona contacto:
> - Email:
> - Tel:
> - URL portal Azure:

---

## Comandos de referencia rápida

| Acción | Comando |
|---|---|
| Conectar BD producción | `& "C:\xampp\mysql\bin\mysql.exe" -h 20.121.178.90 -u root -pRoot TICKETS_DB` |
| Backup BD | `mysqldump -h 20.121.178.90 -u root -pRoot TICKETS_DB > backup.sql` |
| Restaurar BD | `cmd /c "mysql ... < backup.sql"` |
| Limpiar caché | `Remove-Item c:\xampp\htdocs\glpi\files\_cache\* -Recurse -Force` |
| Forzar cron mailgate | `C:\xampp\php\php.exe front\cron.php --force mailgate` |
| Forzar cron notificaciones | `C:\xampp\php\php.exe front\cron.php --force queuednotification` |
| Generar export full | `powershell migration_prod\export_full.ps1` |

---

*Documento generado para el administrador del Grupo Empresarial Santacruz.*
*Versión 1.0 – 2026*
