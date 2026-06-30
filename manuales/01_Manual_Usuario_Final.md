# Manual del Usuario Final

**Mesa de Ayuda TI – Grupo Empresarial Santacruz**
*Plataforma: GLPI – `https://helpdesk.grupo-santacruz.com`*

---

## Tabla de contenido

1. [Introducción](#1-introducción)
2. [Ingresar al sistema](#2-ingresar-al-sistema)
3. [Conoce tu panel](#3-conoce-tu-panel)
4. [Crear un ticket](#4-crear-un-ticket)
5. [Crear un ticket por correo](#5-crear-un-ticket-por-correo)
6. [Seguir el avance de tu ticket](#6-seguir-el-avance-de-tu-ticket)
7. [Responder al técnico (seguimientos)](#7-responder-al-técnico-seguimientos)
8. [Aprobar o rechazar una solución](#8-aprobar-o-rechazar-una-solución)
9. [Buscar en la base de conocimiento (FAQ)](#9-buscar-en-la-base-de-conocimiento-faq)
10. [Configurar tu perfil y notificaciones](#10-configurar-tu-perfil-y-notificaciones)
11. [Buenas prácticas](#11-buenas-prácticas)
12. [Contacto y soporte directo](#12-contacto-y-soporte-directo)

---

## 1. Introducción

GLPI es la **mesa de ayuda TI** del Grupo Santacruz. Aquí puedes:

- Reportar problemas con tu computador, impresora, internet, software, etc.
- Solicitar instalación de equipos o programas nuevos.
- Consultar el estado de tus reportes.
- Acceder a la base de conocimiento (preguntas frecuentes).

Cada reporte se llama un **ticket** y se asigna automáticamente al técnico que esté de turno.

> 📷 **CAPTURA 1.1** – Página de inicio del sistema (`https://helpdesk.grupo-santacruz.com`)

---

## 2. Ingresar al sistema

### Paso 1
Abre tu navegador (Chrome, Edge, Firefox) y entra a:

```
https://helpdesk.grupo-santacruz.com
```

### Paso 2
Verás la pantalla de inicio Santacruz:

- A la izquierda: información de la mesa de ayuda y botones de WhatsApp, correo y teléfono.
- A la derecha: el formulario de inicio de sesión.

> 📷 **CAPTURA 2.1** – Pantalla de login con el panel verde y el formulario blanco.

### Paso 3
Escribe tu **usuario** (ejemplo: `juan.perez`) y tu **contraseña**.

### Paso 4
Clic en **Ingresar**.

### ¿Olvidaste tu contraseña?
1. Clic en **¿Olvidó su contraseña?**
2. Escribe tu correo electrónico corporativo.
3. Te llegará un correo con un enlace para restablecerla.

> 📷 **CAPTURA 2.2** – Formulario de recuperación de contraseña.

---

## 3. Conoce tu panel

Cuando ingresas verás el **Panel Principal** con:

| Sección | Para qué sirve |
|---|---|
| **Menú lateral izquierdo** | Acceso rápido a Asistencia, Base de conocimiento, Reservas |
| **Tablero (Dashboard)** | Resumen de tus tickets activos |
| **Campana 🔔 (arriba derecha)** | Notificaciones de novedades en tus tickets |
| **Tu nombre (arriba derecha)** | Configurar tu perfil, cerrar sesión |

> 📷 **CAPTURA 3.1** – Panel principal completo con flechas señalando cada sección.

---

## 4. Crear un ticket

### Opción A — Botón rápido "Crear un ticket"

#### Paso 1
En el menú superior, busca el botón **➕ "Crear un ticket"** o entra por **Asistencia → Tickets → ➕ Añadir**.

> 📷 **CAPTURA 4.1** – Ubicación del botón "Crear un ticket".

#### Paso 2
Llena el formulario:

| Campo | Cómo llenarlo |
|---|---|
| **Tipo** | `Incidencia` si algo está fallando · `Solicitud` si pides algo nuevo |
| **Categoría** | Selecciona la que mejor describa: *Hardware*, *Software*, *Red*, *Impresora*, *Correo*, etc. |
| **Título** | Frase corta y clara: *"PC de facturación PDV-Pereira no enciende"* |
| **Descripción** | Detalla qué pasa, desde cuándo, qué intentaste, qué error muestra |
| **Urgencia** | `Muy alta` (afecta operación) · `Alta` · `Media` (por defecto) · `Baja` |
| **Ubicación** | Sede / PDV donde está el problema |
| **Documentos** | Adjunta capturas o fotos del problema |

> 📷 **CAPTURA 4.2** – Formulario de creación de ticket con todos los campos.

#### Paso 3
Clic en **Añadir** (o **Enviar mensaje**) al final del formulario.

#### Paso 4
Verás un mensaje verde de confirmación con el **número de ticket** asignado, ejemplo: *"Ticket #1234 creado."*

> 📷 **CAPTURA 4.3** – Mensaje de confirmación con el número de ticket.

---

### ⚠️ Importante: NO hagas esto

- ❌ No asignes técnico (el sistema lo hace según el turno)
- ❌ No cambies el estado (déjalo en *Nuevo*)
- ❌ No pongas fecha de vencimiento

---

## 5. Crear un ticket por correo

Si no quieres entrar al sistema, también puedes crear un ticket por correo electrónico.

### Pasos

1. Abre tu correo Outlook / Gmail / etc.
2. **Para:** `tisantacruz48@gmail.com`
3. **Asunto:** título corto del problema
   - Ejemplo: *"Impresora de oficina no imprime"*
4. **Cuerpo:** descripción detallada del problema
5. **Adjuntos:** fotos, capturas, etc.
6. Envía el correo.

### Qué pasa después

- En máximo **10 minutos** el sistema crea el ticket automáticamente
- Te llega un correo de confirmación con el número de ticket
- El técnico de turno lo atiende

> 📷 **CAPTURA 5.1** – Ejemplo de correo bien escrito.

---

## 6. Seguir el avance de tu ticket

### Por el sistema

#### Paso 1
Menú lateral → **Asistencia → Tickets**

> 📷 **CAPTURA 6.1** – Ubicación de la lista de tickets.

#### Paso 2
Verás la lista con:
- **#ID** – número del ticket
- **Título**
- **Estado** (Nuevo / En curso / Resuelto / Cerrado)
- **Fecha**
- **Técnico asignado**

> 📷 **CAPTURA 6.2** – Lista de tickets propios con códigos de color por estado.

#### Paso 3
Clic en el ticket para abrirlo. Verás pestañas:

| Pestaña | Para qué |
|---|---|
| **Procesamiento del ticket** | Lo que el técnico ha hecho |
| **Seguimientos** | Comentarios y mensajes |
| **Documentos** | Archivos adjuntos |
| **Solución** | Cuando se resuelva, aparece aquí |

> 📷 **CAPTURA 6.3** – Vista interna de un ticket con pestañas señaladas.

### Por correo

Cada cambio importante te llega como correo electrónico:
- Cuando el técnico se asigna
- Cuando añade un seguimiento
- Cuando lo resuelve
- Cuando lo cierra

---

## 7. Responder al técnico (seguimientos)

Si el técnico te pide más información o quieres añadir algo:

### Paso 1
Abre el ticket → pestaña **Seguimientos**

### Paso 2
Clic en **➕ Añadir un nuevo seguimiento**

### Paso 3
Escribe tu mensaje. Puedes:
- Adjuntar archivos
- Dar formato (negrita, listas)
- Mencionar a otra persona (con `@`)

### Paso 4
Clic en **Añadir**.

> 📷 **CAPTURA 7.1** – Formulario de nuevo seguimiento.

El técnico recibirá una notificación automática.

---

## 8. Aprobar o rechazar una solución

Cuando el técnico marca tu ticket como **Resuelto**, recibes un correo y debes:

### Si la solución te sirvió ✅

#### Paso 1
Abre el ticket → verás botón **"Aprobar la solución"** arriba

#### Paso 2
Clic en **Aprobar** → el ticket pasa a *Cerrado*

> 📷 **CAPTURA 8.1** – Botón de aprobación de solución.

### Si la solución NO te sirvió ❌

#### Paso 1
Abre el ticket → botón **"Rechazar la solución"**

#### Paso 2
Escribe brevemente **por qué no funcionó**

#### Paso 3
Clic en **Rechazar** → el ticket vuelve a *En curso* y el técnico es notificado

> 📷 **CAPTURA 8.2** – Formulario de rechazo con razón.

> 💡 Si no apruebas ni rechazas en **5 días**, el ticket se cierra automáticamente.

---

## 9. Buscar en la base de conocimiento (FAQ)

Antes de crear un ticket, puedes buscar si ya hay respuesta a tu duda.

### Paso 1
Menú lateral → **Herramientas → Base de conocimiento**

### Paso 2
Usa la barra de búsqueda arriba.
- Escribe palabras clave: *"impresora"*, *"correo no envía"*, *"contraseña"*

### Paso 3
Lee el artículo. Si responde tu duda, ¡problema resuelto sin esperar técnico!

> 📷 **CAPTURA 9.1** – Vista de un artículo de la base de conocimiento.

---

## 10. Configurar tu perfil y notificaciones

### Cambiar tu contraseña

1. Clic en tu nombre (arriba derecha) → **Mi configuración**
2. Pestaña **Personalización**
3. Escribe la contraseña nueva dos veces
4. Clic en **Guardar**

> 📷 **CAPTURA 10.1** – Vista de "Mi configuración".

### Cambiar tu correo electrónico

1. Misma pantalla → pestaña **Principal**
2. Edita el campo **Correo electrónico**
3. Guarda

### Notificaciones por correo

Por defecto recibes correos de:
- Nuevo ticket creado
- Cambios en tus tickets
- Solución propuesta
- Cierre

Si quieres más o menos correos, contacta a TI.

---

## 11. Buenas prácticas

### ✅ Sí hacer

- **Título claro:** *"PC del PDV-Pereira no enciende"* es mejor que *"PC dañado"*.
- **Un problema por ticket:** no mezcles 3 cosas distintas en un mismo ticket.
- **Adjunta capturas:** una foto vale mil palabras.
- **Explica qué intentaste:** *"Ya apagué y prendí el equipo, sigue sin internet."*
- **Indica urgencia real:** marca **Alta** solo si afecta la operación.

### ❌ No hacer

- Títulos vagos: *"Ayuda"*, *"No funciona"*, *"Problema"*.
- Crear tickets duplicados — mejor agrega un seguimiento al que ya existe.
- Cerrar tú mismo el ticket — espera la solución del técnico.
- Reportar al técnico por WhatsApp si ya hay ticket abierto — usa los seguimientos.

---

## 12. Contacto y soporte directo

| Medio | Datos |
|---|---|
| 💬 **WhatsApp** | `+57 314 647 2332` |
| 📧 **Correo** | `tisantacruz48@gmail.com` |
| 📞 **Teléfono** | `+57 314 647 2332` |
| 🌐 **Sistema** | `https://helpdesk.grupo-santacruz.com` |

### Horarios de atención automática

| Día | Horario | Técnico |
|---|---|---|
| Lunes a Viernes | 06:30 – 08:00 | Julio Bovea |
| Lunes a Viernes | 08:00 – 11:00 | Marco Bruges |
| Lunes a Viernes | 11:00 – 12:30 | Sebastian Zarache |
| Lunes a Viernes | 14:00 – 17:00 | Anthony Redondo |
| Lunes a Viernes | 17:00 – 20:00 | Sebastian Zarache |
| Sábados / Domingos | – | El técnico de turno toma manualmente |

> Hora de almuerzo (12:30 – 14:00) y fuera de horario: los tickets quedan en cola hasta que un técnico los tome.

---

*Documento generado para el Grupo Empresarial Santacruz.*
*Versión 1.0 – 2026*
