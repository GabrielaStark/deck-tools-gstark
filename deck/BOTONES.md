# Los botones del Stream Deck

Casi todos los botones son lo mismo: **teclear un comando en la terminal que tengas
abierta**. La única excepción es `vsc · terminal`, que no teclea nada — manda un atajo
de teclado. Está aparte, [al final](#botón-de-atajo-vs-code-ya-abierto), y se nota
porque es el único que no lleva texto.

**Regla de oro: para los botones que teclean, usa siempre una acción de tipo TEXTO,
nunca "Ejecutar comando".**
Las acciones de "ejecutar comando" corren en el directorio del software del deck, no
en el de tu terminal — y todo el chiste de estos scripts es que trabajan sobre el
proyecto donde tú estás parada.

---

## Ubuntu — OpenDeck

Acción: **Simulate Input** (plugin Starterpack).
Se pega en el campo **Key down**. **Key up** se deja vacío.

| Botón | Key down |
|---|---|
| stark · mantenimiento | `[t("stark-mantenimiento"),k(Return)]` |
| stark · nuevo | `[t("stark-nuevo"),k(Return)]` |
| stark · actualizar | `[t("stark-actualizar"),k(Return)]` |
| vsc · aquí | `[t("vsc-terminal"),k(Return)]` |

Ojo: `Return` va con mayúscula. Con minúscula, OpenDeck marca error de sintaxis.

Sintaxis útil por si quieres armar otros:
- `t("texto")` → escribe texto
- `k(Return)` → pica Enter
- Se encadenan con coma, todo dentro de corchetes

**Variante sin Enter** (para cuando quieras completar el comando a mano antes de correrlo):

```
[t("stark-mantenimiento ")]
```

---

## macOS — Stream Deck de Elgato

Acción: **Text** (categoría System, viene de fábrica).

Un botón por comando. En todos, **Press Enter** activado.

| Botón | Text |
|---|---|
| stark · mantenimiento | `stark-mantenimiento` |
| stark · nuevo | `stark-nuevo` |
| stark · actualizar | `stark-actualizar` |
| vsc · aquí | `vsc-terminal` |

---

## Botón de atajo (VS Code ya abierto)

Este es el otro caso: **no** estás en una terminal, ya tienes VS Code abierto con el
proyecto, y solo quieres la terminal integrada. Aquí no hay nada que teclear — el
botón manda el atajo y ya.

### Primero, un atajo a prueba de teclado en español

El atajo de fábrica es ``Ctrl+` ``. En teclados en español el backtick es tecla muerta y
queda en otro lugar, así que el deck a veces manda cualquier cosa. Se arregla de una
vez asignándole una tecla sola.

En VS Code: `Ctrl+Shift+P` → **Preferences: Open Keyboard Shortcuts (JSON)** → agrega:

```json
[
  { "key": "f6", "command": "workbench.action.terminal.toggleTerminal" }
]
```

Esto **suma**, no reemplaza: ``Ctrl+` `` sigue funcionando igual. Si F6 te estorba
depurando, pon otra tecla libre — lo único que importa es que sea **una sola tecla**.

¿Prefieres que cada vez abra una terminal nueva en vez de mostrar/ocultar la que hay?
Cambia el comando por `workbench.action.terminal.new`.

### Y luego, el botón

| Sistema | Acción | Qué se configura |
|---|---|---|
| Ubuntu — OpenDeck | **Simulate Input** (Starterpack) | Key down: `[k(F6)]` |
| macOS — Elgato | **Hotkey** (categoría System) | Picas F6 dentro del campo, sin escribir nada |

Si prefieres no tocar los atajos de VS Code y mandar el combo de fábrica, en el Elgato
funciona igual: en la acción **Hotkey** picas ``Ctrl+` `` y listo. En OpenDeck depende de
que tu versión del plugin acepte bajar y subir modificadores (`[d(Ctrl),k(Grave),u(Ctrl)]`);
si te marca error de sintaxis, quédate con la tecla sola de arriba — por eso es la ruta
recomendada.

---

## Los comandos

| Comando | Para qué | Dónde te paras antes de picar |
|---|---|---|
| `stark-mantenimiento` | Proyecto que ya existe y NO tiene stark. Le pega la herramienta y blinda el `.gitignore`. | **Dentro** del proyecto |
| `stark-nuevo` | Arrancar un proyecto desde cero. Pregunta el nombre, crea la carpeta, le corta el `.git` a stark e inicia tu repo. | En la carpeta **contenedora** |
| `stark-actualizar` | Proyecto con stark viejo: actualiza la herramienta, limpia zombies, la saca del repo si estaba commiteada y ofrece sellos RDD retroactivos. Todo lo delicado pregunta antes (Enter = no). | Dentro del proyecto |
| `vsc-terminal` | Abre VS Code en el proyecto donde estás y le pica el atajo de la terminal integrada, para que salga ya parada ahí. Si estás en una subcarpeta del repo, abre la **raíz**. | Dentro del proyecto (o de cualquier subcarpeta suya) |

Todos los botones llevan Enter: los de stark porque preguntan lo que necesitan una vez
adentro, y `vsc-terminal` porque no pregunta nada. No hay que teclear nada después de
picar.

### Cuando `vsc-terminal` abre VS Code pero no la terminal

Abrir la carpeta funciona siempre; simular la tecla no. En **Wayland** (el Ubuntu de
hoy) ningún programa puede mandar teclas sin permisos aparte, y en **macOS** hay que
darle Accesibilidad a tu terminal (Ajustes → Privacidad y seguridad → Accesibilidad).
El script te dice cuál de los dos casos es y no falla: VS Code queda abierto igual.

Para eso está el botón de atajo de arriba — ese sí atraviesa Wayland y macOS sin
permisos extra, porque la tecla la manda el deck, no el script. Combo que funciona
siempre: **`vsc · aquí` para abrir el proyecto, `vsc · terminal` para la terminal.**

En Ubuntu con sesión X11 (no Wayland) sí sale de un solo botón, instalando
`sudo apt install xdotool`.

### Mayúsculas

No importa cómo se escriba: `stark-nuevo` y `STARK-NUEVO` funcionan igual. El
instalador crea las dos formas apuntando al mismo script, porque Linux distingue
mayúsculas en los nombres de archivo y los botones a veces tecleaban en altas.

Esto **no** vuelve la terminal insensible a mayúsculas — solo estos comandos aceptan
ambas escrituras. `LS` y `GIT` siguen sin existir, como debe ser.

---

## Cómo se usa, en corto

**Mantenimiento** (proyecto que ya existe):
```
1. cd al proyecto
2. 🔘 Botón mantenimiento
3. Claude Code → /stark-init
```

**Nuevo** (desde cero):
```
1. cd a donde quieras que viva (ej. ~/Documentos/STARK)
2. 🔘 Botón nuevo  → te pregunta el nombre
3. cd al proyecto que creó
4. Claude Code → /stark-init
```

**VS Code, viniendo de la terminal:**
```
1. cd al proyecto (o a cualquier subcarpeta suya)
2. 🔘 Botón vsc · aquí  → abre VS Code en la raíz del proyecto
   (si el atajo no entró: 🔘 Botón vsc · terminal)
```

**VS Code, ya abierto:**
```
1. 🔘 Botón vsc · terminal  → muestra/oculta la terminal integrada
```
