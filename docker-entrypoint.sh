#!/bin/sh
# ---------------------------------------------------------------------------
# Entrypoint SIGTICK / GLPI
# Genera config/config_db.php a partir de variables de entorno al arrancar.
# Asi los secretos NO viven en el repositorio: se configuran en la plataforma
# (Railway, Render, etc.). Si no hay variables, usa el config_db.php existente.
# ---------------------------------------------------------------------------
set -e

CONFIG_DIR=/var/www/html/config
DB_CONFIG="$CONFIG_DIR/config_db.php"

# Parsea una URL de conexion mysql|mariadb://user:pass@host:port/dbname
# y rellena las variables GLPI_DB_* que no esten ya definidas.
parse_url() {
  url="$1"
  rest="${url#*://}"           # quita el esquema
  creds="${rest%%@*}"          # user:pass
  hostpart="${rest#*@}"        # host:port/db?params
  GLPI_DB_USER="${GLPI_DB_USER:-${creds%%:*}}"
  GLPI_DB_PASSWORD="${GLPI_DB_PASSWORD:-${creds#*:}}"
  hostport="${hostpart%%/*}"   # host:port
  GLPI_DB_HOST="${GLPI_DB_HOST:-${hostport%%:*}}"
  _port="${hostport#*:}"
  [ "$_port" != "$hostport" ] && GLPI_DB_PORT="${GLPI_DB_PORT:-$_port}"
  dbname="${hostpart#*/}"      # db?params
  dbname="${dbname%%\?*}"      # quita ?params
  GLPI_DB_NAME="${GLPI_DB_NAME:-$dbname}"
}

# Soporta una URL unica inyectada por la plataforma.
for v in "$GLPI_DB_URL" "$DATABASE_URL" "$MYSQL_URL"; do
  if [ -n "$v" ]; then parse_url "$v"; break; fi
done

GLPI_DB_PORT="${GLPI_DB_PORT:-3306}"

if [ -n "$GLPI_DB_HOST" ] && [ -n "$GLPI_DB_NAME" ]; then
  echo "[entrypoint] Generando config_db.php -> host=${GLPI_DB_HOST}:${GLPI_DB_PORT} db=${GLPI_DB_NAME}"

  if [ "$GLPI_DB_PORT" = "3306" ]; then
    HOST_VALUE="$GLPI_DB_HOST"
  else
    HOST_VALUE="${GLPI_DB_HOST}:${GLPI_DB_PORT}"
  fi

  # Escapa comillas simples para no romper el string PHP
  esc() { printf '%s' "$1" | sed "s/'/\\\\'/g"; }
  HOST_VALUE_E=$(esc "$HOST_VALUE")
  DB_USER_E=$(esc "$GLPI_DB_USER")
  DB_PASS_E=$(esc "$GLPI_DB_PASSWORD")
  DB_NAME_E=$(esc "$GLPI_DB_NAME")

  cat > "$DB_CONFIG" <<PHP
<?php

class DB extends DBmysql {

   public \$dbhost     = '${HOST_VALUE_E}';
   public \$dbuser     = '${DB_USER_E}';
   public \$dbpassword = '${DB_PASS_E}';
   public \$dbdefault  = '${DB_NAME_E}';
   public \$use_utf8mb4       = true;
   public \$allow_datetime    = false;
   public \$allow_signed_keys = false;
   public \$use_timezones     = true;
}
PHP

  chown www-data:www-data "$DB_CONFIG" 2>/dev/null || true
  chmod 644 "$DB_CONFIG" 2>/dev/null || true
elif [ -f "$DB_CONFIG" ]; then
  echo "[entrypoint] Sin variables GLPI_DB_*; usando config_db.php existente."
else
  echo "[entrypoint] AVISO: no hay config_db.php ni variables GLPI_DB_*. GLPI mostrara el instalador."
fi

# Opcional: restaura la clave de cifrado de GLPI desde el entorno (la que
# descifra contrasenas SMTP/LDAP guardadas). Mantenla fuera del repo.
if [ -n "$GLPI_CRYPT_KEY" ]; then
  printf '%s' "$GLPI_CRYPT_KEY" > "$CONFIG_DIR/glpicrypt.key"
  chown www-data:www-data "$CONFIG_DIR/glpicrypt.key" 2>/dev/null || true
  echo "[entrypoint] glpicrypt.key restaurada desde GLPI_CRYPT_KEY."
fi

exec "$@"
