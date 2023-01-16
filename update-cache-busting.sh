#!/bin/bash
set -euoo pipefail posix
cd "$(dirname "$0")"

# 
function openssl_md4() {
	# OpenSSL 3.0 & OpenSSL 1.1
	openssl md4 -provider legacy "$@" 2>/dev/null || openssl md4 "$@"
}

function content_hash() {
	local -r file="$1"
	openssl_md4 "$file" | awk '{ print substr($NF, 0, 20) }'
}

# 
SITE_CSS_PARAM="v=$(content_hash ./docs/site.css)"
readonly SITE_CSS_PARAM

MAIN_CSS_PARAM="v=$(content_hash ./docs/a-sandwich-with-six-pieces-of-potato-salad/main.css)"
readonly MAIN_CSS_PARAM

# 
sed -Ei \
	-e 's/(["/]site\.css\?)[^"]*/\1'"$SITE_CSS_PARAM"'/g' \
	-e 's/(["/]main\.css\?)[^"]*/\1'"$MAIN_CSS_PARAM"'/g' \
	./docs/a-sandwich-with-six-pieces-of-potato-salad/index.html \
	./docs/a-sandwich-with-six-pieces-of-potato-salad/ja/index.html

# 
echo 'OK'
