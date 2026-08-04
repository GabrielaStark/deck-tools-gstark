#!/usr/bin/env bash
#
# instalar.sh — deja los comandos de bin/ disponibles en esta máquina.
#
# QUÉ HACE
#   Crea un enlace (symlink) de cada script de bin/ hacia una carpeta del PATH.
#   Symlink y no copia: así, cuando hagas `git pull` en este repo, los comandos de la
#   máquina se actualizan solos. No tienes que reinstalar nunca.
#
# DÓNDE INSTALA
#   ~/.local/bin en Ubuntu y en macOS. Es la convención moderna en los dos sistemas y
#   no necesita sudo. Si no está en tu PATH, el script te dice la línea exacta a pegar.
#
# USO
#   git clone <este-repo> && cd deck-tools && ./instalar.sh

set -eu

REPO=$(cd "$(dirname "$0")" && pwd)
DESTINO="$HOME/.local/bin"

ok()    { printf '✅ %s\n' "$*"; }
info()  { printf '   %s\n' "$*"; }
aviso() { printf '⚠️  %s\n' "$*"; }

case "$(uname -s)" in
  Linux)  SISTEMA="Ubuntu/Linux" ;;
  Darwin) SISTEMA="macOS" ;;
  *)      SISTEMA="$(uname -s)" ;;
esac

printf '\n🎛️  deck-tools → %s\n\n' "$SISTEMA"

mkdir -p "$DESTINO"

# Los scripts se guardan ejecutables, pero git no siempre preserva el permiso al
# clonar en otra máquina (depende de core.fileMode). Lo forzamos aquí.
INSTALADOS=0
for script in "$REPO"/bin/*; do
  [ -f "$script" ] || continue
  nombre=$(basename "$script")
  chmod +x "$script"
  ln -sf "$script" "$DESTINO/$nombre"

  # Alias en MAYÚSCULAS apuntando al mismo script. Por qué: los botones del deck a
  # veces teclean en mayúsculas, y Linux distingue mayúsculas de minúsculas en los
  # nombres de archivo — así STARK-NUEVO y stark-nuevo funcionan igual.
  # Esto NO vuelve la terminal insensible a mayúsculas: solo estos comandos aceptan
  # ambas escrituras; todo lo demás del sistema sigue igual.
  # PORTABILIDAD: `tr` en vez de ${nombre^^}, que no existe en el bash 3.2 de macOS.
  # En macOS el sistema de archivos ya es insensible a mayúsculas, así que el enlace
  # extra simplemente coincide con el que ya está — inofensivo.
  mayus=$(printf '%s' "$nombre" | tr '[:lower:]' '[:upper:]')
  if [ "$mayus" != "$nombre" ]; then
    ln -sf "$script" "$DESTINO/$mayus" 2>/dev/null || true
  fi

  ok "$nombre   (también responde a $mayus)"
  INSTALADOS=$((INSTALADOS + 1))
done

if [ "$INSTALADOS" -eq 0 ]; then
  aviso "no encontré scripts en $REPO/bin/"
  exit 1
fi

printf '\n'

# ── Extra de Linux: el clic derecho de Archivos (Nautilus) ────────────────────
# Es el único camino que sabe SOLO en qué carpeta estás: Nautilus se lo dice al
# script en una variable de entorno. Un botón del deck no puede saberlo.
# En macOS no aplica: no hay Nautilus. Si no hay Nautilus, no pasa nada.
if [ -d "$REPO/nautilus" ] && command -v nautilus >/dev/null 2>&1; then
  SCRIPTS_NAUTILUS="$HOME/.local/share/nautilus/scripts"
  mkdir -p "$SCRIPTS_NAUTILUS"
  for script in "$REPO"/nautilus/*; do
    [ -f "$script" ] || continue
    chmod +x "$script"
    ln -sf "$script" "$SCRIPTS_NAUTILUS/$(basename "$script")"
    ok "clic derecho en Archivos → Scripts → «$(basename "$script")»"
  done
  info "Si no aparece en el menú: cierra Nautilus con  nautilus -q  y vuelve a abrirlo."
  printf '\n'
fi

# ¿El destino está en el PATH? En macOS ~/.local/bin normalmente NO viene incluido.
case ":$PATH:" in
  *":$DESTINO:"*)
    ok "$DESTINO ya está en tu PATH. Listo para usar."
    ;;
  *)
    aviso "$DESTINO NO está en tu PATH. Los comandos no se van a encontrar todavía."
    info ""
    info "Pega esto en tu terminal (una sola vez) y abre una terminal nueva:"
    info ""
    # bash usa ~/.bashrc; zsh (default de macOS desde Catalina) usa ~/.zshrc.
    case "${SHELL##*/}" in
      zsh) PERFIL="$HOME/.zshrc" ;;
      *)   PERFIL="$HOME/.bashrc" ;;
    esac
    info "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> $PERFIL"
    info ""
    ;;
esac

cat <<'FIN'

── Siguiente paso ────────────────────────────────────────────
  Configura los botones de tu Stream Deck.
  El texto exacto de cada botón está en:  deck/BOTONES.md
──────────────────────────────────────────────────────────────
FIN
