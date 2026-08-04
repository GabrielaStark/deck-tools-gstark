# Los botones del Stream Deck

Hay dos familias, y no se configuran igual:

- **Los de stark** teclean un comando en la terminal que tengas abierta.
  → [Ubuntu](#ubuntu--opendeck) · [macOS](#macos--stream-deck-de-elgato)
- **Los de VS Code** no teclean nada: uno ejecuta un comando, el otro manda un atajo.
  → [VS Code — los dos botones](#vs-code--los-dos-botones)

**Regla de oro, y vale solo para los de stark: acción de tipo TEXTO, nunca "Ejecutar
comando".** Esa acción corre en el directorio del software del deck, no en el de tu
terminal, y esos scripts trabajan sobre la carpeta donde tú estás parada. Los de VS
Code no dependen de eso — por eso ahí la regla no aplica, y está explicado en su
sección.

---

## VS Code — los dos botones

| Botón | Cuándo lo picas | Qué hace |
|---|---|---|
| `vsc · proyecto` | Andas en el explorador de Archivos, o donde sea | Te muestra un selector, eliges el proyecto y lo abre en VS Code |
| `vsc · terminal` | Ya estás trabajando en VS Code | Abre la terminal integrada, parada en la raíz de ese proyecto |

### Por qué el primero te pregunta la carpeta

Porque no hay manera de que la adivine: **GNOME no expone en ninguna parte la carpeta
que tienes abierta en Archivos**. No es que falte configurarlo — no existe esa API.
Un botón del deck no tiene forma de saberlo.

El selector arranca donde estuviste la última vez, así que en la práctica es un clic.

**¿Quieres que sí la adivine, sin preguntarte nada?** Entonces no uses el botón: dentro
de la carpeta del proyecto, **clic derecho → Scripts → «Abrir en VS Code»**. Ahí sí
funciona, porque el explorador le dice al script en qué carpeta estás. Se instala solo
con `./instalar.sh`; si no aparece en el menú, cierra Nautilus con `nautilus -q` y
vuelve a abrirlo.

### Botón 1 · `vsc · proyecto`

Este es el único del repo que va como **ejecutar comando**, y la ruta tiene que ser
completa — el deck no conoce tu PATH. Saca la tuya con:

```bash
echo ~/.local/bin/vsc-proyecto
```

| Sistema | Acción | Qué pones |
|---|---|---|
| Ubuntu — OpenDeck | **Run Command** / **Ejecutar comando** | La ruta que te imprimió el comando de arriba |
| macOS — Elgato | **Open** (categoría System) | Esa misma ruta |

### Botón 2 · `vsc · terminal`

Este manda un atajo de teclado, así que **le llega a la ventana que esté al frente**.
Es para picarlo con VS Code adelante; si lo picas con el explorador adelante, la tecla
se la lleva el explorador y parece que el botón no hace nada.

**Primero, asígnale una tecla sola en VS Code.** El atajo de fábrica es ``Ctrl+` ``, y
en teclado español el backtick es tecla muerta: el deck lo manda mal. Se arregla de una
vez. En VS Code: `Ctrl+Shift+P` → **Preferences: Open Keyboard Shortcuts (JSON)** →
agrega adentro de los corchetes:

```json
{ "key": "f6", "command": "workbench.action.terminal.toggleTerminal" }
```

Guarda y **pruébalo picando F6 tú misma** antes de tocar el deck. Si F6 no te abre la
terminal, el botón tampoco va a poder. Esto suma, no quita: ``Ctrl+` `` sigue igual.

**Luego, el botón:**

| Sistema | Acción | Qué pones |
|---|---|---|
| Ubuntu — OpenDeck | **Simulate Input** (Starterpack) | Key down: `[k(F6)]` — Key up vacío |
| macOS — Elgato | **Hotkey** (categoría System) | Picas F6 dentro del campo. No escribes nada. |

La terminal integrada de VS Code **siempre nace en la raíz del proyecto abierto**. Por
eso este botón no necesita saber ninguna ruta.

### Si el botón 2 no hace nada

Descarta en este orden, es rápido:

1. **¿VS Code estaba al frente?** Es la causa número uno. Pica en la ventana de VS
   Code y vuelve a intentar.
2. **¿F6 funciona a mano?** Si no, falta el atajo del paso anterior.
3. **¿El deck sí manda F6?** Abre un editor de texto cualquiera, pica el botón y fíjate
   si pasa algo. Si el plugin te marcó error de sintaxis en `[k(F6)]`, dímelo y lo
   ajustamos: el nombre de la tecla cambia entre versiones del plugin.

---

## Ubuntu — OpenDeck

Acción: **Simulate Input** (plugin Starterpack).
Se pega en el campo **Key down**. **Key up** se deja vacío.

| Botón | Key down |
|---|---|
| stark · mantenimiento | `[t("stark-mantenimiento"),k(Return)]` |
| stark · nuevo | `[t("stark-nuevo"),k(Return)]` |
| stark · actualizar | `[t("stark-actualizar"),k(Return)]` |

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

Un botón por comando. En los tres, **Press Enter** activado.

| Botón | Text |
|---|---|
| stark · mantenimiento | `stark-mantenimiento` |
| stark · nuevo | `stark-nuevo` |
| stark · actualizar | `stark-actualizar` |

---

## Los comandos

| Comando | Para qué | Dónde te paras antes de picar |
|---|---|---|
| `stark-mantenimiento` | Proyecto que ya existe y NO tiene stark. Le pega la herramienta y blinda el `.gitignore`. | **Dentro** del proyecto |
| `stark-nuevo` | Arrancar un proyecto desde cero. Pregunta el nombre, crea la carpeta, le corta el `.git` a stark e inicia tu repo. | En la carpeta **contenedora** |
| `stark-actualizar` | Proyecto con stark viejo: actualiza la herramienta, limpia zombies, la saca del repo si estaba commiteada y ofrece sellos RDD retroactivos. Todo lo delicado pregunta antes (Enter = no). | Dentro del proyecto |
| `vsc-proyecto` | Lo lanza el botón `vsc · proyecto`. Muestra el selector, y con lo que elijas llama a `vsc-terminal`. | Donde sea: no depende de dónde estés |
| `vsc-terminal` | El motor: abre VS Code en la carpeta que le des (o en la que estés, si lo tecleas tú) e intenta sacar la terminal integrada. Si la carpeta está dentro de un repo, abre la **raíz**. | Dentro del proyecto, si lo tecleas en una terminal |

Los tres de stark llevan Enter en el botón: preguntan lo que necesitan una vez adentro.
No hay que teclear nada después de picar.

### Teclear `vsc-terminal` a mano

`vsc-terminal` también sirve solo, sin botón, cuando ya estás en una terminal parada en
el proyecto. Si quieres un botón para eso, es igual que los de stark:
`[t("vsc-terminal"),k(Return)]` en OpenDeck, o la acción **Text** con `vsc-terminal` en
el Elgato. Ojo: teclea en la ventana que tenga el foco, así que la terminal tiene que
estar al frente.

### Cuando abre VS Code pero no sale la terminal

Abrir la carpeta funciona siempre; que el script simule la tecla, no. En **Wayland**
(el Ubuntu de hoy) ningún programa puede mandar teclas sin permisos aparte, y en
**macOS** hay que darle Accesibilidad a tu terminal. No falla por eso: VS Code queda
abierto igual.

Para eso son dos botones y no uno: **`vsc · proyecto` abre el proyecto,
`vsc · terminal` saca la terminal.** El segundo sí atraviesa Wayland y macOS, porque
la tecla la manda el deck, no el script.

Aparte, VS Code recuerda las terminales de cada proyecto: si la dejaste abierta la
última vez, vuelve sola y no necesitas el segundo botón.

En Ubuntu con sesión X11 (no Wayland) el primero solito ya saca la terminal, instalando
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

**Abrir un proyecto en VS Code:**
```
1. 🔘 Botón vsc · proyecto  → eliges la carpeta en el selector
2. 🔘 Botón vsc · terminal  → si la terminal no salió sola
```

**Ya estás en VS Code y quieres la terminal:**
```
1. Pica en la ventana de VS Code (que esté al frente)
2. 🔘 Botón vsc · terminal
```

**Sin tocar el deck**, parada en la carpeta del proyecto en Archivos:
```
Clic derecho → Scripts → «Abrir en VS Code»
```
