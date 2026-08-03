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

| Campo | Valor |
|---|---|
| Text | `stark-mantenimiento` |
| Press Enter | ✅ activado |

---

## Los comandos

| Comando | Para qué |
|---|---|
| `stark-mantenimiento` | Proyecto que ya existe y NO tiene stark. Le pega la herramienta y blinda el `.gitignore`. |
| `stark-nuevo` | *(pendiente)* Arrancar un proyecto desde cero. |
| `stark-actualizar` | *(pendiente)* Proyecto con stark viejo: baja los cambios de la herramienta, limpia lo obsoleto y la saca del repo si estaba commiteada. |

---

## Cómo se usa, en corto

```
1. Abres la terminal
2. cd al proyecto
3. 🔘 Botón
4. Abres Claude Code y corres /stark-init
```
