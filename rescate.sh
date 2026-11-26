#!/usr/bin/env bash
# Laboratorio de rescate - Sesión 2 (Git y GitHub)
# USO: dentro de tu repo personal ya clonado (laboratorio-rescate-tu-nombre):
#   bash rescate.sh
set -e

# --- Verificaciones de seguridad ---
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "❌ Ejecuta esto dentro del repo clonado."; exit 1; }
REMOTE=$(git remote get-url origin)
case "$REMOTE" in
  *laboratorio-rescate*) ;;
  *) echo "❌ Este repo no parece ser laboratorio-rescate-... ($REMOTE). No es el del equipo, ¿cierto?"; exit 1 ;;
esac
git config user.name  >/dev/null || { echo "❌ Falta: git config --global user.name \"Tu Nombre\""; exit 1; }
git config user.email >/dev/null || { echo "❌ Falta: git config --global user.email \"tu@correo.com\""; exit 1; }
export GIT_PAGER=cat

echo "== 0 Preparación =="
cat > notas.txt <<'EOF'
Línea 1: Git guarda el historial del proyecto.
Línea 2: Cada commit es una foto del proyecto.
Línea 3: Las ramas permiten trabajar sin dañar main.
EOF
echo "# Bitácora del laboratorio de rescate" > BITACORA.md
git add .
git commit -m "feat: agrega notas y bitácora"
git push

echo "== 1 Historial =="
git log
git log --oneline
git log --oneline --graph --all

echo "== 2 Diff =="
sed -i '2s/.*/Línea 2: Cada commit guarda un estado completo del proyecto./' notas.txt
git diff
git add notas.txt
git diff
git diff --staged
git commit -m "docs: modifica línea 2 de notas"

echo "== 3 Archivo borrado por error =="
rm notas.txt
git status
git restore notas.txt
git status
cat notas.txt

echo "== 4 Archivo que no debía subir =="
echo "CLAVE_BD=123456" > secreto.env
git add .
git status
git restore --staged secreto.env
git status
echo "*.env" > .gitignore
git add .gitignore
git commit -m "chore: agrega .gitignore para archivos .env"
git push

echo "== 5 Mensaje de commit equivocado =="
echo "Línea 4: Un buen mensaje de commit explica qué cambió." >> notas.txt
git add notas.txt
git commit -m "cambios"
git log --oneline
git commit --amend -m "docs: agrega línea 4 a notas"
git log --oneline
git push

echo "== 6 Commit subido que dañó el proyecto =="
: > notas.txt
git add notas.txt
git commit -m "fix: limpia notas"
git push
git revert HEAD --no-edit
git log --oneline
git push
cat notas.txt

echo "== 7 Commit antes de tiempo =="
echo "Borrador inicial" > borrador.txt
git add borrador.txt
git commit -m "feat: agrega borrador"
git log --oneline
git reset --soft HEAD~1
git log --oneline
git status
echo "Borrador completo con todo el contenido." >> borrador.txt
git add borrador.txt
git commit -m "feat: agrega borrador completo"
git push

echo "== 8 Trabajo a medias (stash) =="
echo "Línea 5: git stash guarda trabajo a medias sin hacer commit." >> notas.txt
git stash
git status
git stash list
git switch -c fix/urgente
git switch main
git stash pop
git status
git add notas.txt
git commit -m "docs: agrega línea 5 a notas"
git push

echo "== 9 Cierre: bitácora =="
GRAFO=$(git log --oneline --graph --all)

cat > BITACORA.md <<'EOF'
# Bitácora del laboratorio de rescate

## Reto 1 – Ver el historial
**Comandos:** `git log`, `git log --oneline`, `git log --oneline --graph --all`

- `git log` muestra la lista completa de commits: código, autor, fecha y mensaje.
- `git log --oneline` muestra lo mismo resumido, un commit por línea (código corto + mensaje).
- `git log --oneline --graph --all` además dibuja las ramas y cómo se unen, incluyendo todas las ramas, no solo la actual.
- El código del inicio de cada commit es su **hash**: un identificador único que sirve para señalar ese commit exacto.

## Reto 2 – Ver qué cambió antes de guardar
**Comandos:** `git diff`, `git add notas.txt`, `git diff --staged`

- `git diff` muestra lo que cambié en el archivo y todavía no he agregado con `git add`.
- El segundo `git diff` salió vacío porque el cambio ya estaba en el área de preparación (staging); ya no es un cambio "sin agregar".
- `git diff --staged` muestra lo que está agregado y listo para el próximo commit.

## Reto 3 – Borré un archivo por error
**Comandos:** `rm notas.txt`, `git restore notas.txt`

- `git restore` devuelve un archivo a como estaba en el último commit, descartando los cambios o el borrado que no se han guardado.
- Si nunca hubiera hecho commit de ese archivo, **no funcionaría**, porque Git no tiene ninguna copia guardada de él.

## Reto 4 – Agregué un archivo que no debía subir
**Comandos:** `git add .`, `git restore --staged secreto.env`, `.gitignore` con `*.env`

- `git restore archivo` descarta los cambios en mi carpeta de trabajo (vuelve al último commit).
- `git restore --staged archivo` solo lo saca del área de preparación; el archivo y su contenido siguen intactos en mi carpeta.
- Con `.gitignore` y la línea `*.env` Git ignora esos archivos y ya no se pueden agregar por accidente.

## Reto 5 – Escribí mal el mensaje del commit
**Comando:** `git commit --amend -m "docs: agrega línea 4 a notas"`

- `--amend` reemplaza el último commit corrigiendo su mensaje (o su contenido).
- Solo se usa si no hice push, porque cambia el historial; si otros ya lo tienen, se generarían conflictos.

## Reto 6 – Subí un commit que dañó el proyecto
**Comando:** `git revert HEAD`

- `git revert` **no borró** el commit equivocado: **creó un commit nuevo** que deshace sus cambios (`Revert "fix: limpia notas"`).
- Es la opción segura después de hacer push porque no reescribe el historial: mis compañeros pueden hacer `pull` normal y todo queda registrado.

## Reto 7 – Hice un commit antes de tiempo
**Comando:** `git reset --soft HEAD~1`

- `git reset --soft HEAD~1` elimina el último commit pero deja mis cambios en staging para seguir trabajando. Se usa con commits **locales** que aún no subí.
- `git revert` deja el commit en el historial y crea otro que lo cancela. Se usa con commits que **ya se subieron**.
- No usé `git reset --hard` porque borra los cambios sin poder recuperarlos fácilmente.

## Reto 8 – Trabajo a medias y debo cambiar de tarea
**Comandos:** `git stash`, `git stash list`, `git stash pop`

- `git stash` guarda mis cambios sin commit en un "cajón" temporal y deja la carpeta limpia para poder cambiar de rama.
- `git stash pop` saca los cambios guardados y los vuelve a poner en mi carpeta de trabajo (y los quita del cajón).

## Resultado final de `git log --oneline --graph`

```
EOF
printf '%s\n```\n' "$GRAFO" >> BITACORA.md

git add BITACORA.md
git commit -m "docs: completa bitácora del laboratorio"
git push

echo
echo "✅ Listo. Revisa tu repo en GitHub y publica el link en Discord:"
echo "   ${REMOTE%.git}"
