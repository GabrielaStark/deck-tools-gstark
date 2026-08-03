# Los botones del Stream Deck

Un botón = teclear un comando en la terminal que tengas abierta. Nada más.

**Regla de oro: usa siempre una acción de tipo TEXTO, nunca "Ejecutar comando".**
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

Un botón por comando. En los dos, **Press Enter** activado.

| Botón | Text |
|---|---|
| stark · mantenimiento | `stark-mantenimiento` |
| stark · nuevo | `stark-nuevo` |

---

## Los comandos

| Comando | Para qué | Dónde te paras antes de picar |
|---|---|---|
| `stark-mantenimiento` | Proyecto que ya existe y NO tiene stark. Le pega la herramienta y blinda el `.gitignore`. | **Dentro** del proyecto |
| `stark-nuevo` | Arrancar un proyecto desde cero. Pregunta el nombre, crea la carpeta, le corta el `.git` a stark e inicia tu repo. | En la carpeta **contenedora** |
| `stark-actualizar` | *(pendiente)* Proyecto con stark viejo: baja los cambios, limpia lo obsoleto y lo saca del repo si estaba commiteado. | Dentro del proyecto |

Los dos preguntan lo que necesitan, así que ambos botones llevan Enter. No hay que
teclear nada después de picar.

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
