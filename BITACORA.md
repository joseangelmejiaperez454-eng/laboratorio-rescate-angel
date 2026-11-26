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
* 8389450 docs: agrega línea 5 a notas
* 074a744 feat: agrega borrador completo
* 999c418 Revert "fix: limpia notas"
* 6bd94d8 fix: limpia notas
* 8028552 docs: agrega línea 4 a notas
* 26ed0e5 chore: agrega .gitignore para archivos .env
* 7f6fc62 docs: modifica línea 2 de notas
* 9f3c641 feat: agrega notas y bitácora
* 4b6a1fb Initial commit
```
