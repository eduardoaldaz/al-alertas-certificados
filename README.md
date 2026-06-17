# Alertas Certificados

Extensión para **Microsoft Dynamics 365 Business Central** que monitoriza la fecha de vencimiento de los certificados aislados (`Isolated Certificates`) y envía alertas por email cuando alguno está próximo a caducar o ya ha caducado.

## Descripción

La extensión revisa periódicamente todos los certificados registrados en Business Central y notifica por email a los destinatarios configurados cuando detecta:

- **Certificados vencidos** — caducados en los últimos 60 días.
- **Certificados por vencer** — que vencen dentro del número de días configurado (por defecto 30).

Para evitar el spam, se controla la frecuencia de envío: no se vuelve a alertar sobre el mismo certificado hasta que transcurran los días configurados, salvo que queden 3 días o menos para su vencimiento, en cuyo caso se alerta a diario.

## Funcionalidades

- Detección automática de certificados vencidos y próximos a vencer.
- Envío de email HTML con tabla de incidencias, diferenciando vencidos (fondo rojo) y por vencer (fondo amarillo).
- Soporte para múltiples destinatarios (separados por `;`).
- Registro de alertas enviadas en un log interno, con limpieza automática de entradas de más de 90 días.
- Página de configuración accesible desde Administración.
- Botón manual **Comprobar caducidad** en la lista de certificados para lanzar la revisión en cualquier momento.

## Configuración

Acceder a la página **Configuración Alertas Certificados** (categoría Administración) y completar:

| Campo | Descripción | Valor por defecto |
|-------|-------------|-------------------|
| Email destinatario | Emails que recibirán las alertas. Separar varios con `;` | — |
| Días de antelación | Días previos al vencimiento para empezar a alertar | 30 |
| Enviar alerta cada X días | Frecuencia máxima de alerta por certificado | 5 |

## Requisitos

| Parámetro | Valor |
|-----------|-------|
| Business Central | 28.0 o superior |
| Runtime AL | 17.0 |
| Target | Cloud (SaaS) |
| Rango de IDs | 50100 – 50149 |

## Objetos incluidos

| Tipo | ID | Nombre |
|------|----|--------|
| Codeunit | 50100 | Revisar Documentos |
| Table | 50101 | Log Alerta Documento |
| Table | 50102 | Config Alerta Certificados |
| Page | 50102 | Log de Alertas |
| Page | 50103 | Config Alerta Certificados |
| PageExtension | 50101 | Certificados Ext |

## Instalación

1. Compilar el proyecto desde VS Code con la extensión AL Language.
2. Publicar el archivo `.app` generado en el entorno de Business Central.
3. Acceder a **Configuración Alertas Certificados** y establecer los destinatarios de email y los parámetros de frecuencia.
4. Programar la codeunit `50100 "Revisar Documentos"` mediante una cola de trabajo (Job Queue) para ejecución diaria.

## Información

| Campo | Valor |
|-------|-------|
| Publisher | Global Food Link |
| Versión | 1.3.0.0 |
