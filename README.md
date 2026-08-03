# deck-tools

Los comandos que disparan mis botones del Stream Deck. Mismo comportamiento en
Ubuntu y en macOS: clono este repo, corro el instalador, y los botones hacen
exactamente lo mismo en cualquier máquina.

De momento son los botones de **stark** (el framework SDD). El repo está armado
para que quepan otros después.

---

## Instalar en una máquina nueva

```bash
git clone https://github.com/GabrielaStark/deck-tools-gstark.git ~/deck-tools
cd ~/deck-tools
./instalar.sh
```

Eso es todo. El instalador detecta el sistema, deja los comandos disponibles en la
terminal y te dice si falta algo del PATH.

Después, configura los botones de tu deck con el texto exacto de
[`deck/BOTONES.md`](deck/BOTONES.md) — ahí están las dos variantes (OpenDeck en
Ubuntu, Stream Deck de Elgato en Mac).

## Actualizar

```bash
cd ~/deck-tools && git pull
```

No hay que reinstalar. El instalador deja **enlaces**, no copias: al actualizar el
repo, los comandos de la máquina cambian solos.

---

## Qué hay adentro

```
deck-tools/
├── instalar.sh          ← deja los comandos de bin/ disponibles en el PATH
├── bin/                 ← los comandos que teclean los botones
│   └── stark-mantenimiento
└── deck/
    └── BOTONES.md       ← el texto exacto de cada botón, por sistema
```

---

## Los comandos de stark

Los tres cubren situaciones distintas. La regla que comparten: **la herramienta vive
en el disco, nunca en el repo del proyecto.**

| Comando | Cuándo | Estado |
|---|---|---|
| `stark-mantenimiento` | Proyecto que ya existe y no tiene stark. Le pega la herramienta y blinda el `.gitignore`. Te paras **dentro** del proyecto. | ✅ |
| `stark-nuevo` | Arrancar un proyecto desde cero. Pregunta el nombre, clona stark, le corta el `.git` para que nunca puedas pushear al repo de stark, e inicia tu repo. Si tienes `gh`, ofrece crear el repo en GitHub y pushear. Te paras en la carpeta **contenedora**. | ✅ |
| `stark-actualizar` | Proyecto con una versión vieja de stark. Actualiza la herramienta, detecta y borra lo obsoleto (zombies), la saca del repo si estaba commiteada, y ofrece sellos RDD retroactivos para las specs aprobadas antes de que existieran los sellos. Es el único que borra y toca el índice de git: todo lo delicado pregunta antes, y Enter a secas significa NO. | ✅ |

### Por qué la herramienta no se sube al repo

El repo de un proyecto es **el producto**. stark es **el andamio** con el que se
construyó. Se entregan cosas distintas:

- **Va al repo:** tu código y tus `docs/` (specs, decisiones, evidencia).
- **No va al repo:** `.claude/`, `templates/`, `docs/documentacion/` — eso es stark.

Así puedes clonar tu proyecto en otra PC, correr `stark-mantenimiento`, y seguir
trabajando igual. La herramienta se baja aparte, siempre en su última versión.

### El `.git` de stark nunca entra a tu proyecto

Los comandos clonan stark en una carpeta temporal, copian solo las carpetas de la
herramienta y borran el temporal. El único `.git` que existe en tu proyecto es el
tuyo — un `git push` siempre va a **tu** repo, jamás al de stark.

---

## Compatibilidad

Un solo script para los dos sistemas, no dos copias que se desincronizan.

Está escrito para bash 3.2 (el que trae macOS de fábrica) y para el `cp` de BSD: sin
arrays vacíos bajo `set -u` y sin `cp -r origen/.`, que son las dos cosas que
típicamente truenan al pasar un script de Linux a Mac. Los puntos donde importa están
marcados con un comentario `PORTABILIDAD` en el código.

Lo único que cambia entre sistemas es cómo se configura el botón en el software del
deck. Eso está resuelto en [`deck/BOTONES.md`](deck/BOTONES.md).

---

## Requisitos

- `git`
- `bash` (el de fábrica basta en las dos)
- Claude Code, para las fases de stark
- Python 3.9+ solo si vas a usar los sellos RDD de stark
