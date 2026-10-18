# Laboratorio OWASP Mutillidae II con Docker Compose: practica inyección SQL, XSS e inyección LDAP en una aplicación web PHP vulnerable a propósito

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-mutillidae/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-mutillidae/actions/workflows/check.yml)

Un **laboratorio de seguridad de aplicaciones web** listo para el aula, de la [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning), donde escuelas y centros dan a cada alumno sus propias bases de datos, sus propios contenedores y su propio terminal en el navegador. Cada alumno recibe su propia copia de **OWASP Mutillidae II**, un sitio PHP inseguro a propósito, con su **base de datos MariaDB** y su **directorio LDAP** ya creados, para practicar **inyección SQL, cross-site scripting, inyección de comandos, inyección LDAP** y más a lo largo del OWASP Top 10, con niveles de seguridad que muestran qué cambia cada corrección. Explica el fallo y entrega pruebas, sin instalar nada y sin riesgo para el equipo de nadie más.

Es un único archivo `docker-compose`, `compose.yaml`, y funciona igual en tu propio equipo que en la plataforma, donde cada alumno tiene una copia privada sin salida a internet.

## La única regla

**Ataca tu propia copia y nada más.** Todo en este laboratorio se ejecuta dentro de tu propia copia privada, que no tiene ruta a internet ni a ningún otro alumno, así que lo único que puedes alcanzar es la aplicación que el laboratorio inició para ti. Nunca apuntes una herramienta a un sitio web, una red o una máquina que no sean tuyos, en un laboratorio o en cualquier otro sitio: en el Reino Unido eso es un delito según la [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), y la mayoría de los países tienen una ley parecida. Aprender cómo funcionan las debilidades es la manera de construir software que no las tenga, y una buena primera conversación en clase es por qué existe esta regla y cómo es una divulgación responsable.

## Qué contiene

| Servicio | Imagen | Memoria | Qué es |
| --- | --- | --- | --- |
| `www` | [`webpwnized/mutillidae:www-2.12.7`](https://hub.docker.com/r/webpwnized/mutillidae) | 512 MB | Apache y PHP ejecutando Mutillidae, el sitio que abres |
| `database` | `webpwnized/mutillidae:database-2.12.7` | 384 MB | la base de datos MariaDB donde Mutillidae guarda sus cuentas, su blog y sus registros |
| `directory` | `webpwnized/mutillidae:ldap-2.12.7` | 256 MB | el directorio OpenLDAP que leen los ejercicios de LDAP |

Cada imagen está fijada por su etiqueta de versión y por su resumen (digest), de modo que una reconstrucción con la misma etiqueta no puede cambiar un laboratorio bajo los pies de una clase. Los tres juntos están limitados a 1152 MB y, en reposo, usan aproximadamente 210 MB. El laboratorio está listo en unos diez segundos en un portátil. La base de datos se crea por ti: el laboratorio pide a la propia página de instalación de Mutillidae que la construya cuando la base de datos está en marcha, y solo entonces se declara listo, así que «listo» significa que el sitio funciona y que no hay una página de aviso de primer arranque que atravesar.

Las imágenes son programas de terceros, ejecutados sin modificar a partir de las imágenes públicas del propio proyecto, así que aquí no se compila nada y nada de este repositorio se distribuye en ellas. Están publicadas para máquinas Intel y AMD de 64 bits (amd64), que es donde se ejecuta la plataforma; en un portátil con Apple silicon, Docker las ejecuta con emulación, lo que funciona pero es más lento.

## Usarlo en la plataforma

La [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning) da a cada alumno su propia copia de un laboratorio, en el navegador, con un terminal al lado.

**Para probarlo:** abre la [página de contenedores](https://mitsurutech.co.uk/es/container), busca este laboratorio en **Laboratorios de ejemplo** y pulsa Iniciar. No hace falta cuenta para probar uno.

**Para ponerlo como trabajo a una clase:**

1. En tu módulo, crea una tarea de tipo **Laboratorio** y elige **En un repositorio de GitHub**.
2. Indica `https://github.com/mitsurutech/lab-mutillidae` con la rama `main`. El archivo compose es el predeterminado, `compose.yaml`. Haz antes un fork del repositorio si quieres cambiar el archivo.
3. Publica. La copia de cada alumno parte del commit que publicaste, así que un cambio posterior aquí no altera un laboratorio ya puesto.
4. Di en la tarea qué hay que entregar (consulta [Para profesores](#para-profesores)) y asígnala como cualquier otra tarea.

La [guía de este laboratorio](https://mitsurutech.co.uk/es/help/lab-mutillidae), la [guía de los laboratorios de seguridad](https://mitsurutech.co.uk/es/help/security-labs) y la [guía de laboratorios de contenedores](https://mitsurutech.co.uk/es/help/labs) del manual de ayuda cuentan el resto: qué puede decir un archivo compose, cuánta memoria recibe una copia y cómo abre, observa y califica un profesor la copia de un alumno.

¿Aún no tienes una cuenta de centro? [El primer año es gratis](https://mitsurutech.co.uk/es/pricing) para hasta 50 alumnos, y [registrarse](https://mitsurutech.co.uk/es/signup) solo pide una dirección de correo electrónico.

## Ejecutarlo en tu propio equipo

Necesitas Docker con el complemento Compose. El primer arranque descarga las imágenes, que son grandes (unos 250 MB, 130 MB y 90 MB de descarga).

```bash
docker compose -f compose.yaml -f local.yaml up
```

Abre <http://localhost:8080>.

`local.yaml` publica el puerto solo en `127.0.0.1`, así que el laboratorio es accesible desde tu propio ordenador y desde ningún otro sitio. Deténlo con `Ctrl-C` y elimínalo con `docker compose -f compose.yaml -f local.yaml down -v`. Ejecútalo en una máquina desde la que no te importe atacar: la aplicación es insegura a propósito.

## Cómo trabajarlo

1. **Abre el sitio.** La base de datos ya está creada, así que no hay nada que configurar. La parte superior de cada página indica el nivel de seguridad (empieza en 0) y si las pistas están activadas.
2. **Inicia sesión** como `admin` con la contraseña `adminpass` en las páginas que piden una cuenta, o crea la tuya en la página **Login/Register**.
3. **Elige un ejercicio.** El menú de la izquierda es el OWASP Top 10 con las debilidades de cada apartado: inyección SQL (extraer datos, saltarse la autenticación, a ciegas y por tiempo), inyección de HTML y JavaScript, inyección de comandos, inyección LDAP, cross-site scripting, inclusión de archivos, sesiones débiles y más. **Toggle Hints** muestra pistas en cada página.
4. **Sube el nivel.** **Toggle Security** en el menú pasa de 0 a 1 y luego a 5, y vuelve a 0. Haz de nuevo el mismo ejercicio: el nombre inyectado que encuentra las cuarenta cuentas en el nivel 0 no encuentra ninguna en el nivel 5, lo que muestra qué cambia cada corrección.
5. **Empieza de nuevo cuando quieras.** Detener e iniciar el laboratorio da un Mutillidae nuevo, igual que **Reset DB** del menú.

## Para profesores

Nada en este laboratorio se califica automáticamente. El alumno entrega pruebas y tú las calificas, igual que cualquier otro laboratorio.

**Pide pruebas en dos mitades.** Primero, la prueba del trabajo: una captura de pantalla de cada ejercicio resuelto, con la dirección del propio laboratorio visible en el navegador para que quede claro que es su copia. Segundo, la comprensión: para cada uno, una explicación escrita con sus propias palabras de qué es la debilidad, la entrada exacta que usaron y por qué funcionó, qué podría hacer un atacante con ella y cómo debería haberse escrito el código. La segunda mitad te dice si se entendió o se copió de una guía paso a paso. Para un trabajo más exigente, pide también el mismo ejercicio en el nivel 5 y qué hace el código de forma diferente.

**Dónde encaja en un curso.** Mutillidae encaja en una introducción a la seguridad de aplicaciones web y a la programación segura, porque el mismo ejercicio en distintos niveles es la misma página, insegura y después corregida: validación de entradas, codificación de salidas, consultas parametrizadas y autenticación. También apoya la parte legal y ética de una unidad: autorización y alcance, la Computer Misuse Act 1990 y la divulgación responsable. Consulta la redacción exacta en la unidad de tu propio organismo de certificación; aquí no se cita ninguna.

**Quién ve qué.** Estos laboratorios se usan a menudo con alumnos de 16 y 17 años. Una copia es privada para el alumno que la inició. Un miembro del personal que imparte el módulo puede abrirla para ver lo que ha hecho el alumno, y abrir el trabajo de un alumno queda escrito en el registro de accesos, que el alumno puede leer.

## Qué no funciona en un laboratorio

El laboratorio no tiene ninguna salida a internet, así que todo lo de Mutillidae que obtiene una página de otro sitio web, o busca un nombre en internet, no tiene nada a lo que llegar. Solo se abre el puerto web para el alumno, no la base de datos ni el directorio, aunque el terminal junto al laboratorio llega a cada servicio por su nombre (`www`, `database`, `directory`). Al sitio se le dan 512 MB, a su base de datos 384 MB y a su directorio 256 MB.

## Solución de problemas

- **El sitio no aparece justo después de Iniciar.** Espera unos segundos y vuelve a pulsar Abrir: el laboratorio se declara listo solo cuando la base de datos ya se ha creado.
- **El sitio dice que algo falla con la base de datos.** Detén el laboratorio y vuelve a iniciarlo para obtener una copia nueva, o elige **Reset DB** en el menú.
- **En tu propio equipo, el puerto 8080 ya está en uso.** Cambia el número de la izquierda en `local.yaml`, por ejemplo `127.0.0.1:8081:80`, y abre ese puerto en su lugar.

## Comprobación del laboratorio

`test/check.sh` inicia el laboratorio como el ejecutor de la plataforma inicia cada servicio (todas las capacidades retiradas, `no-new-privileges`, un límite de procesos, límites de memoria y ninguna salida a internet) y luego comprueba desde dentro de su red lo que promete esta página: el sitio responde, admin inicia sesión, un nombre inyectado encuentra todas las cuentas en el nivel 0 y ninguna en el nivel 5, y el directorio está en marcha. Necesita Docker y se ejecuta en cada push, que es la insignia de arriba.

```bash
test/check.sh
```

## Versiones y licencias

[OWASP Mutillidae II](https://github.com/webpwnized/mutillidae) está bajo licencia GPL-3.0, con sus [imágenes de Docker](https://github.com/webpwnized/mutillidae-docker) del mismo proyecto; las imágenes también contienen MariaDB (GPL-2.0), OpenLDAP (OpenLDAP Public License) y PHP, Apache, Debian y sus otras partes bajo sus propias licencias. Las imágenes son `webpwnized/mutillidae:www-2.12.7`, `:database-2.12.7` y `:ldap-2.12.7`, cada una fijada por su resumen en `compose.yaml`.

## Licencia

Esta obra está bajo licencia [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Puedes compartirla y adaptarla para aprender y enseñar, si citas a Mitsuru Technologies Ltd, no la usas comercialmente y compartes lo que hagas con ella bajo la misma licencia. El texto completo está en el archivo `LICENSE`.

La aplicación que contiene conserva la licencia de su propio proyecto, enlazada arriba.

## Acerca de

Hecho por [Mitsuru Technologies](https://mitsurutech.co.uk/es) para la [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning): Python, Java, Go, Node, SQL y Linux en el navegador para escuelas y centros, con laboratorios de contenedores, aplicaciones web desplegadas desde GitHub y cuestionarios que se califican solos. Prueba código sin cuenta en el [entorno de pruebas](https://mitsurutech.co.uk/es/playground).

Más laboratorios del mismo sitio: [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) y [lab-sample](https://github.com/mitsurutech/lab-sample).
