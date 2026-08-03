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
  ok "$nombre"
  INSTALADOS=$((INSTALADOS + 1))
done

if [ "$INSTALADOS" -eq 0 ]; then
  aviso "no encontré scripts en $REPO/bin/"
  exit 1
fi

printf '\n'

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
