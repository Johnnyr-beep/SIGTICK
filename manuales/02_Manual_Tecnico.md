# Manual del Técnico de Soporte

**Mesa de Ayuda TI – Grupo Empresarial Santacruz**
*Plataforma: GLPI – `https://helpdesk.grupo-santacruz.com`*

> Para: **Julio Bovea, Marco Bruges, Sebastian Zarache, Anthony Redondo**
> Perfil del sistema: **Technician**

---

## Tabla de contenido

1. [Tu rol como técnico](#1-tu-rol-como-técnico)
2. [Ingresar al sistema](#2-ingresar-al-sistema)
3. [Tu panel de trabajo](#3-tu-panel-de-trabajo)
4. [Sistema de asignación automática por turnos](#4-sistema-de-asignación-automática-por-turnos)
5. [Atender un ticket nuevo](#5-atender-un-ticket-nuevo)
6. [Comunicarte con el solicitante](#6-comunicarte-con-el-solicitante)
7. [Crear tareas internas](#7-crear-tareas-internas)
8. [Solicitar aprobación o información](#8-solicitar-aprobación-o-información)
9. [Resolver un ticket](#9-resolver-un-ticket)
10. [Tomar un ticket sin asignar (fines de semana / almuerzo)](#10-tomar-un-ticket-sin-asignar-fines-de-semana--almuerzo)
11. [Reasignar tickets](#11-reasignar-tickets)
12. [Gestionar inventario](#12-gestionar-inventario)
13. [Generar PDF de entrega de equipos (Acta)](#13-generar-pdf-de-entrega-de-equipos-acta)
14. [Crear y editar artículos de la base de conocimiento](#14-crear-y-editar-artículos-de-la-base-de-conocimiento)
15. [Reportes y estadísticas](#15-reportes-y-estadísticas)
16. [Buenas prácticas](#16-buenas-prácticas)

---

## 1. Tu rol como técnico

Eres responsable de:
- ✅ Atender los tickets que el sistema te asigna automáticamente
- ✅ Atender los tickets que tomas manualmente (fuera de turno)
- ✅ Comunicarte con el solicitante (claro y oportuno)
- ✅ Documentar la solución para futuras consultas
- ✅ Mantener actualizado el inventario de equipos
- ✅ Generar actas de entrega cuando entregas un equipo

### Tu perfil tiene acceso a:

| Función | Acceso |
|---|---|
| Tickets, cambios, problemas, proyectos | ✅ Completo |
| Inventario (computadores, monitores, impresoras, redes, software, periféricos, teléfonos) | ✅ Crear/editar |
| Contratos, documentos, contactos | ✅ Lectura/edición |
| Base de conocimiento | ✅ Crear artículos |
| Generación de PDF (Acta Santacruz) | ✅ Habilitado |
| Reservas de equipos | ✅ Habilitado |
| Configuración del sistema | ❌ Solo el admin |

---

## 2. Ingresar al sistema

### Paso 1
Entra a `https://helpdesk.grupo-santacruz.com`

### Paso 2
Usa tu usuario:
- Julio → `julio.tech`
- Marco → `marco.tech`
- Sebastian → `sebastian.tech`
- Anthony → `anthony.tech`

### Paso 3
Clic en **Ingresar**.

> 📷 **CAPTURA 2.1** – Pantalla de login Santacruz.

---

## 3. Tu panel de trabajo

Al entrar verás tu **Dashboard de Técnico** con:

| Sección | Qué muestra |
|---|---|
| **Tickets nuevos** | Los que acaban de llegarte sin abrir |
| **Tickets en curso** | Los que estás trabajando |
| **Tickets pendientes** | Esperando información o aprobación |
| **Mi planificación** | Tareas y citas del día |
| **Estadísticas rápidas** | Gráfico de tickets por estado |

> 📷 **CAPTURA 3.1** – Dashboard completo del técnico con cada bloque señalado.

### Menú lateral
- **Asistencia** → Tickets, Cambios, Problemas, Proyectos
- **Activos** → Computadores, Impresoras, Redes, etc.
- **Herramientas** → Base de conocimiento, Reservas, Notas
- **Administración** → Usuarios, Grupos, Entidades (limitado)

---

## 4. Sistema de asignación automática por turnos

El sistema te asigna tickets automáticamente según la hora de creación.

### Horarios L-V

| Hora | Técnico asignado |
|---|---|
| 06:30 – 08:00 | **Julio** |
| 08:00 – 11:00 | **Marco** |
| 11:00 – 12:30 | **Sebastian** |
| 12:30 – 14:00 | **ALMUERZO** (sin asignar) |
| 14:00 – 17:00 | **Anthony** |
| 17:00 – 20:00 | **Sebastian** |

### Fines de semana y horas no cubiertas

Los tickets llegan **sin técnico asignado** al grupo *Soporte TI*. El técnico de turno los toma manualmente (ver [sección 10](#10-tomar-un-ticket-sin-asignar-fines-de-semana--almuerzo)).

### Cómo te enteras de un ticket nuevo

1. **Correo electrónico** automático
2. **Campana 🔔** del sistema (esquina superior derecha)
3. Aparece en la **lista "Tickets nuevos"** de tu dashboard

---

## 5. Atender un ticket nuevo

### Paso 1 – Abrir el ticket

Menú → **Asistencia → Tickets** → clic en el ticket asignado

> 📷 **CAPTURA 5.1** – Vista interna de un ticket recién asignado.

### Paso 2 – Cambiar estado a "En curso (asignado)"

- Estado: cambia de **Nuevo** → **En curso (asignado)**
- Esto le indica al solicitante que ya lo estás trabajando
- Clic en **Guardar**

### Paso 3 – Revisar la información

Lee detenidamente:
- **Título** y **descripción**
- **Documentos adjuntos** (capturas, fotos)
- **Categoría** y **ubicación**
- **Elementos asociados** (si menciona un equipo específico)

### Paso 4 – Decidir tu acción

| Caso | Qué hacer |
|---|---|
| Necesitas más información | Crear un **seguimiento** preguntando |
| Tienes la solución inmediata | Pasar directo a [sección 9 – Resolver](#9-resolver-un-ticket) |
| Requiere visita presencial | Crear una **tarea** con fecha programada |
| No te corresponde a ti | Reasignar a otro técnico ([sección 11](#11-reasignar-tickets)) |
| Es un problema mayor que requiere proyecto | Convertir en **Cambio** o **Problema** |

---

## 6. Comunicarte con el solicitante

### Crear un seguimiento (mensaje)

#### Paso 1
Dentro del ticket → pestaña **Seguimientos** → clic en **➕ Añadir un seguimiento**

#### Paso 2
Escribe tu mensaje:
- Puedes usar **formato enriquecido** (negrita, listas, enlaces)
- Adjunta archivos si necesitas
- Si quieres que sea **privado** (solo técnicos lo ven), marca *"Privado"*

#### Paso 3
Clic en **Añadir** → el solicitante recibe correo automático

> 📷 **CAPTURA 6.1** – Formulario de seguimiento con campo de mensaje.

### Ejemplos de buenos seguimientos

**Para pedir información:**
> "Hola Juan, para diagnosticar mejor necesito que me confirmes:
> 1. ¿El equipo enciende?
> 2. ¿Se escucha algún pitido al prender?
> 3. ¿Hay luces parpadeando en el frente?
>
> Gracias."

**Para informar avance:**
> "He revisado remotamente el equipo. El problema es un driver de impresora desactualizado. Lo voy a actualizar ahora mismo, tomará 10 minutos."

---

## 7. Crear tareas internas

Las tareas son **subactividades** dentro de un ticket. Útiles para:
- Programar una visita
- Registrar tiempo invertido
- Coordinar con otro técnico

### Paso 1
Dentro del ticket → pestaña **Tareas** → **➕ Añadir tarea**

### Paso 2
Llena:
- **Descripción** de la tarea
- **Estado** (Por hacer / En curso / Hecho)
- **Fecha** y **duración**
- **Categoría de tarea**
- **Tiempo dedicado real** (al terminar)

### Paso 3
Guarda.

> 📷 **CAPTURA 7.1** – Formulario de tarea con todos los campos.

> 💡 Las tareas alimentan los **reportes de tiempo invertido** por técnico.

---

## 8. Solicitar aprobación o información

### Solicitar información al solicitante (estado *Pendiente*)

Si necesitas algo del usuario y no quieres que cuente el tiempo de SLA:

#### Paso 1
Cambia el estado a **Pendiente** → motivo: *"Esperando información del usuario"*

#### Paso 2
Crea un seguimiento pidiendo lo que necesitas

#### Paso 3
Al recibir respuesta, vuelve a estado **En curso**

> 📷 **CAPTURA 8.1** – Cambio de estado a pendiente con motivo.

---

## 9. Resolver un ticket

Cuando solucionaste el problema:

### Paso 1
Dentro del ticket → pestaña **Solución** → **➕ Añadir una solución**

### Paso 2
Llena:
- **Tipo de solución** (selecciona de la lista: *Reinicio*, *Actualización*, *Configuración*, *Reemplazo*, etc.)
- **Descripción de la solución** (sé claro, esto es lo que ve el solicitante)
- Adjunta evidencia si aplica

### Paso 3
Clic en **Añadir** → el ticket pasa a **Resuelto** automáticamente

> 📷 **CAPTURA 9.1** – Formulario de solución.

### Qué pasa después

- El solicitante recibe correo con la solución
- Tiene **5 días** para **aprobar** o **rechazar**
- Si no responde, se cierra automáticamente
- Si rechaza, el ticket vuelve a ti como **En curso**

### Ejemplo de buena descripción de solución

> "Se actualizó el driver de la impresora HP LaserJet desde el panel de control. Se realizó prueba de impresión satisfactoria. La impresora quedó funcional. **Causa raíz:** el driver estaba en versión 2018, se actualizó a versión 2024."

---

## 10. Tomar un ticket sin asignar (fines de semana / almuerzo)

Los tickets de **sábado, domingo, almuerzo o madrugada** llegan sin técnico al grupo *Soporte TI*.

### Cómo encontrarlos

#### Paso 1
Menú → **Asistencia → Tickets**

#### Paso 2
Filtra por:
- **Técnico = "Ninguno"** (sin asignar)
- **Grupo de asignación = "Soporte TI"**

> 📷 **CAPTURA 10.1** – Lista filtrada de tickets sin asignar.

### Cómo tomarlo

#### Paso 1
Abre el ticket

#### Paso 2
En el campo **"Asignado a un técnico"** → escribe tu nombre y selecciónate

#### Paso 3
Cambia estado a **En curso (asignado)**

#### Paso 4
Guarda y procede como cualquier otro ticket

---

## 11. Reasignar tickets

### Si el ticket no te corresponde

#### Paso 1
Abre el ticket → busca el campo **"Asignado a un técnico"**

#### Paso 2
Quita tu nombre con la **X** y selecciona el técnico correcto

#### Paso 3
En seguimiento explica brevemente: *"Reasigno a Marco porque corresponde a impresoras."*

#### Paso 4
Guarda

> 📷 **CAPTURA 11.1** – Campo de técnico asignado en el formulario.

> ⚠️ **Importante:** comunícate primero con tu compañero por WhatsApp antes de reasignar para evitar reasignaciones cruzadas.

---

## 12. Gestionar inventario

Como técnico puedes crear, editar y borrar registros de inventario.

### Tipos de activos

| Activo | Menú |
|---|---|
| Computadores | Activos → Computadores |
| Monitores | Activos → Monitores |
| Impresoras | Activos → Impresoras |
| Equipos de red | Activos → Equipos de red |
| Software / licencias | Activos → Software |
| Periféricos | Activos → Periféricos |
| Teléfonos | Activos → Teléfonos |

### Crear un equipo

#### Paso 1
Menú → **Activos → Computadores → ➕ Añadir**

#### Paso 2
Llena los campos clave:
- **Nombre** (ej. `FACTURACION-PEREIRA-01`)
- **Estado** (Operativo, En reparación, Dado de baja)
- **Entidad** (CARNES SANTACRUZ, AGROPECUARIA, etc.)
- **Ubicación** (PDV o sede)
- **Fabricante, modelo**
- **Número de serie**
- **Número de inventario**
- **Usuario asignado** (importante para el Acta de Entrega)

> 📷 **CAPTURA 12.1** – Formulario de creación de equipo.

#### Paso 3
Guarda. Después puedes agregar:
- Componentes (RAM, disco, procesador) en pestaña **Componentes**
- Sistema operativo en pestaña **Sistema operativo**
- Documentos relacionados en pestaña **Documentos**

---

## 13. Generar PDF de entrega de equipos (Acta)

Cuando entregas un equipo a un colaborador, debes generar el **Acta de Entrega** firmada.

### Requisitos previos

El equipo debe tener llenos:
- ✅ Usuario asignado
- ✅ Entidad
- ✅ Datos básicos del equipo (fabricante, modelo, serie, inventario)

Y el **usuario** debe tener:
- ✅ Nombre y apellido
- ✅ **Número de registro** (cédula)
- ✅ **Título** (cargo)

### Generar el PDF

#### Paso 1
Abre el equipo → menú **Activos → Computadores → [nombre]**

#### Paso 2
Arriba a la derecha, clic en el ícono **🖨️ Imprimir a PDF**

> 📷 **CAPTURA 13.1** – Ubicación del botón "Imprimir a PDF".

#### Paso 3
Se descargará el PDF con:
- **Logo Santacruz** en la cabecera
- **Título:** *Acta de Entrega de Equipo*
- **Nombre de la empresa** (según entidad)
- **Datos del usuario** (nombre, cédula, cargo)
- **Datos del equipo** completos
- **Compromisos del operario** (lista completa)
- **Cláusula** de descuento por daño/pérdida
- **Líneas de firma** (Usuario / Responsable TI)

#### Paso 4
Imprime, hazla firmar al colaborador y archívala.

> 📷 **CAPTURA 13.2** – Ejemplo del PDF generado.

---

## 14. Crear y editar artículos de la base de conocimiento

Documenta las soluciones recurrentes para que otros puedan resolver por sí mismos.

### Crear un artículo

#### Paso 1
Menú → **Herramientas → Base de conocimiento → ➕ Añadir**

#### Paso 2
Llena:
- **Asunto** (título claro, ej. *"Cómo configurar correo Outlook en celular"*)
- **Contenido** (paso a paso con imágenes)
- **Categoría**
- **Visible para** (Todos / Solo técnicos)
- **Visible desde / hasta** (fechas opcionales)

> 📷 **CAPTURA 14.1** – Editor de artículo de base de conocimiento.

#### Paso 3
Guarda. Puedes asociar el artículo a tickets relacionados.

### Ideas para artículos

- Cómo restablecer contraseña corporativa
- Cómo conectarse a WiFi de oficina
- Cómo instalar impresora compartida
- Solución a errores comunes de SAP / sistemas

---

## 15. Reportes y estadísticas

### Ver estadísticas globales

Menú → **Asistencia → Estadísticas**

Tipos disponibles:
- **Globales:** tickets por mes, por categoría, por urgencia
- **Por técnico:** cuántos atendió cada uno
- **Por entidad:** cuál empresa genera más casos
- **Por categoría:** qué tipo de problema es más frecuente

> 📷 **CAPTURA 15.1** – Pantalla de estadísticas con filtros.

### Tu desempeño personal

Dashboard principal → bloques de:
- **Tickets resueltos este mes**
- **Tiempo promedio de resolución**
- **Tickets en cola asignados a ti**

---

## 16. Buenas prácticas

### ✅ Sí hacer

- **Cambia el estado** del ticket apenas lo abres (Nuevo → En curso)
- **Comunica** al solicitante en máximo 1 hora (aunque sea solo para confirmar que lo viste)
- **Documenta** todo en seguimientos, no por WhatsApp ni llamada (queda registro)
- **Solución clara** con causa raíz, no solo "se arregló"
- **Adjunta evidencia** (capturas antes/después)
- **Actualiza el inventario** si cambias o reemplazas un equipo
- **Crea artículos KB** cuando resuelves algo recurrente

### ❌ No hacer

- ❌ Dejar un ticket "Nuevo" más de 1 hora sin abrirlo
- ❌ Cerrar tickets sin solución documentada
- ❌ Reasignar sin avisar al compañero
- ❌ Borrar tickets (mejor cerrar o marcar como duplicado)
- ❌ Olvidarse de tickets pendientes — revisa el dashboard al iniciar el turno

### Al iniciar tu turno

1. Revisa **Tickets nuevos** asignados a ti
2. Revisa **Tickets sin asignar** (puede haber del turno anterior)
3. Revisa **Tickets en pendiente** esperando respuesta del usuario
4. Confirma con el técnico saliente (WhatsApp) si hay algo crítico abierto

### Al cerrar tu turno

1. Resuelve o reasigna los que puedas
2. Deja en **Pendiente** los que esperan respuesta del usuario
3. Informa al técnico entrante de algo crítico
4. Cierra sesión

---

## Contacto interno del equipo TI

| Técnico | Usuario | Turno L-V |
|---|---|---|
| Julio Bovea | `julio.tech` | 06:30 – 15:30 |
| Marco Bruges | `marco.tech` | 06:30 – 15:30 |
| Sebastian Zarache | `sebastian.tech` | 11:00 – 20:00 |
| Anthony Redondo | `anthony.tech` | 08:00 – 17:00 |

WhatsApp del equipo: `+57 314 647 2332`
Correo: `tisantacruz48@gmail.com`

---

*Documento generado para el equipo de TI del Grupo Empresarial Santacruz.*
*Versión 1.0 – 2026*
