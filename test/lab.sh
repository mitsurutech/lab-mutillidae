#!/usr/bin/env bash
# What the README promises, checked from inside the lab's own network: run by check.sh.
set -euo pipefail
: "${NET:?run through test/check.sh}"
probe() { docker run --rm --network "$NET" lab-mutillidae-check-probe bash -c "$1"; }
echo "- the site answers, the database was made for us and admin signs in"
probe '
set -eu
B=http://www/index.php
code=$(curl -s -o /dev/null -w "%{http_code}" "$B")
[ "$code" = 200 ] || { echo "the site answered $code, expected 200" >&2; exit 1; }
out=$(curl -s -c /tmp/j -d "username=admin&password=adminpass&login-php-submit-button=Login" -o /dev/null -w "%{http_code} %{redirect_url}" "$B?page=login.php")
[ "$out" = "302 http://www/index.php?popUpNotificationCode=AU1" ] || { echo "sign in answered: $out" >&2; exit 1; }
echo "- one account is found by name, and an injected name returns every account"
users() {
  curl -s -b /tmp/j -c /tmp/j -G "$B" --data-urlencode "page=user-info.php" --data-urlencode "username=$1" \
    --data-urlencode "password=adminpass" --data-urlencode "user-info-php-submit-button=View Account Details" | grep -o "[0-9]* records found" || true
}
[ "$(users admin)" = "1 records found" ] || { echo "admin was not found once" >&2; exit 1; }
all=$(users "'"'"' OR 1=1 -- ")
[ "$all" = "40 records found" ] || { echo "the injection found: $all" >&2; exit 1; }
echo "- two presses of Toggle Security reach level 5, where the same input finds nothing"
for i in 1 2; do curl -s -b /tmp/j -c /tmp/j -L -o /dev/null "$B?do=toggle-security&page=home.php"; done
curl -s -b /tmp/j "$B?page=home.php" | grep -q "Security Level: 5" || { echo "the level is not 5" >&2; exit 1; }
none=$(users "'"'"' OR 1=1 -- ")
[ "$none" = "0 records found" ] || { echo "at level 5 the injection found: $none" >&2; exit 1; }
echo "- the directory service the LDAP exercises read is up"
(echo > /dev/tcp/directory/389) 2>/dev/null || { echo "no directory on 389" >&2; exit 1; }
'
echo "  ok"
