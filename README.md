🎬 Análisis de Datos: Consultas Avanzadas en una BBDD 🍿

## 📝 1. Descripción del Proyecto

Este proyecto consiste en resolver una serie de preguntas de negocio propuestas sobre la base de datos. El objetivo es analizar de forma sencilla el comportamiento de los clientes, las películas más alquiladas y el rendimiento de la tienda usando consultas en SQL.

---

## 🗂 2. Estructura del Proyecto

A continuación, se detalla la organización de los archivos dentro de este repositorio para facilitar la navegación:

├── esquema_bbdd.png # Diagrama Entidad-Relación (ER) exportado desde DBeaver.
├── consultas_resueltas.sql # Script SQL con los enunciados y las consultas ejecutables.
├── README.md # Descripción, metodología y conclusiones del proyecto.

## 🛠 3. Instalación y Requisitos

Para poder visualizar el esquema y ejecutar las consultas de este proyecto, necesitas disponer de las siguientes herramientas:

- **Gestor de BBDD:** DBeaver Community Edition (o cualquier cliente SQL compatible como MySQL Workbench o pgAdmin).
- **Motor de Base de Datos:** Servidor local PostgreSQL.
- **Base de Datos:** Modelo de datos Sakila Database instalado y cargado.

## 📊 4. Resultados y Conclusiones

Tras la ejecución y análisis de los bloques de consultas, se han extraído los siguientes hallazgos clave para la toma de decisiones:

- 📉 **Identificación de Inactividad:** Se diseñó una lógica de exclusión mediante `LEFT JOIN` y `NOT IN` que permite identificar de forma automática qué actores o clientes no registran actividad, previniendo la acumulación de datos obsoletos.
- 🏷️ **Segmentación por Géneros:** Al cruzar las tablas de categorías, se detectó el impacto total en minutos de visualización de géneros clave (como _Action_ y _Sci-Fi_), permitiendo al departamento de compras saber qué inventario genera mayor retención de tiempo.
- 🚨 **Control de Pérdidas e Inventario:** Mediante filtros dinámicos (`IS NULL`), localizamos a los clientes con alquileres fuera de plazo (como la búsqueda específica realizada para la clienta _Tammy Sanders_), facilitando las tareas de reclamación de devoluciones.

## 🔄 5. Próximos Pasos

Para futuras expansiones y mejoras de este análisis, se proponen las siguientes líneas de trabajo:

- 💰 **Penalizaciones por Retraso:** Refinar las consultas de alquileres para calcular penalizaciones económicas automáticas por cada día de retraso en la devolución de las películas.
- 📊 **Visualización de Datos:** Migrar los resultados de las consultas analíticas hacia un panel interactivo en Power BI o Tableau para facilitar la toma de decisiones visuales.

## 🤝 6. Contribuciones

Las contribuciones son totalmente bienvenidas. Si encuentras una forma más optimizada de resolver alguno de los scripts o quieres añadir nuevas consultas analíticas, por favor abre un _pull request_ o genera una _issue_.

## 👤 7. Autores

- **Zhaklina Dobromirova Karailieva** - [zhaklinaa](https://github.com/zhaklinaa)
- _Proyecto formativo de SQL Avanzado._
