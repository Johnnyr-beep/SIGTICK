# Migración GLPI a Producción — Paquete SQL

Este paquete contiene todos los cambios de base de datos hechos en el entorno
local que deben aplicarse en el servidor de Azure (`helpdesk.grupo-santacruz.com`).

## Contenido

| Archivo | Descripción |
|---|---|
| `00_apply_all.sql`             | Script maestro que ejecuta todos los demás en orden. |
| `01_notification_templates.sql`| 32 plantillas de notificación corregidas + plantilla "Tickets" rediseñada con branding Santacruz. |
| `02_smtp_config.sql`           | Configuración SMTP de Gmail + direcciones de correo + firma. |
| `03_mailcollector.sql`         | Recolector IMAP de Gmail (lee `tisantacruz48@gmail.com`). |
| `05_activate_notifications.sql`| Activa las 82 notificaciones del sistema. |
| `06_activate_crons.sql`        | Activa las tareas cron de correo. |

## Pre-requisitos en el servidor de producción

1. **GLPI 11.0.x** ya instalado y funcionando.
2. **Backup completo** de la base de datos antes de aplicar.
3. Extensiones PHP habilitadas: `imap`, `sockets`, `intl`, `mysqli`, `curl`, `gd`, `mbstring`, `xml`.
4. Firewall de Azure permitiendo:
   - **Salida** TCP 587 (SMTP Gmail).
   - **Salida** TCP 993 (IMAP Gmail).
5. Credencial de Gmail: contraseña de aplicación de 16 caracteres
   (generada en https://myaccount.google.com/apppasswords con 2FA activo).

## Cómo aplicar

### Paso 1: Backup
```bash
mysqldump -u root -p glpi > glpi_backup_$(date +%Y%m%d_%H%M%S).sql
```

### Paso 2: Subir el paquete
Copiar la carpeta `migration_prod/` al servidor.

### Paso 3: Ejecutar el SQL
Desde la carpeta:
```bash
cd migration_prod
mysql -u root -p glpi < 00_apply_all.sql
```

(Si MySQL pide la contraseña, ingresarla. Verás al final `Migracion aplicada correctamente.`)

### Paso 4: Configurar contraseñas (manual, vía UI)

Por seguridad, las contraseñas NO van en el SQL. Hay que entrar a GLPI como
super-administrador y completar:

#### 4.1 Contraseña SMTP saliente
- Menú: **Configuración → Notificaciones → Configuración de notificaciones por correo electrónico**.
- Campo: **Contraseña SMTP** → escribir la app password de 16 caracteres.
- Click en **Guardar** y luego en **Enviar un correo de prueba** para validar.

#### 4.2 Contraseña IMAP entrante
- Menú: **Configuración → Recolectores de correo → Buzon Soporte Gmail**.
- Sección "Autenticación" → campo **Contraseña** → escribir la misma app password.
- Click en **Guardar** y luego en **Probar la conexión**.

### Paso 5: Configurar el cron del sistema operativo

#### Si el servidor es Linux (Ubuntu/Debian):
```bash
sudo crontab -u www-data -e
```
Agregar:
```
* * * * * /usr/bin/php /var/www/html/glpi/front/cron.php >/dev/null 2>&1
```
(Ajustar la ruta según donde esté instalado GLPI).

#### Si el servidor es Windows:
Ejecutar en PowerShell **como Administrador**:
```powershell
$action = New-ScheduledTaskAction -Execute 'C:\php\php.exe' -Argument 'C:\inetpub\wwwroot\glpi\front\cron.php'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 10) -MultipleInstances IgnoreNew
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName "GLPI_Cron" -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force
```
(Ajustar las rutas de PHP y GLPI).

## Validación post-migración

1. **SMTP saliente:** botón "Enviar un correo de prueba" → debe llegar al admin_email.
2. **IMAP entrante:** botón "Obtener los correos electrónicos" → debe procesar la bandeja.
3. **Cron activo:** menú **Configuración → Acciones automáticas** → tareas
   `queuednotification`, `mailgate`, `queuednotificationclean`, `mailgateerror`
   deben mostrar "Activado" y haberse ejecutado en el último minuto/hora.
4. **Plantilla rediseñada:** crear un caso de prueba → la notificación
   "Nuevo caso" debe llegar con cabecera verde, logo, bloque del usuario solicitante.

## Rollback

Si algo sale mal, restaurar el backup:
```bash
mysql -u root -p glpi < glpi_backup_FECHA.sql
```

## Notas

- Las plantillas vienen con el logo apuntando a
  `https://helpdesk.grupo-santacruz.com/pics/logos/logo-GLPI-250-white.png`.
  Es el logo blanco que ya está en `public/pics/logos/`. Si en producción
  cambiaron el logo de marca, actualizar la plantilla "Tickets" desde la UI
  (Configuración → Notificaciones → Plantillas → Tickets).
- El correo desde el que GLPI envía/lee es `tisantacruz48@gmail.com`.
  Si en producción se decide usar otro buzón corporativo, basta con cambiar
  los valores en `02_smtp_config.sql` y `03_mailcollector.sql` antes de aplicar.
