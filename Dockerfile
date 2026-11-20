# Kodbox 1.71.02-1: the deployed kodbox:1.71.02 image with only its php8.3
# packages upgraded from Ubuntu noble-security, for the PHP security release
# of 19 November 2026 (Ubuntu's fix: 8.3.6-0ubuntu0.24.04.14, 20 November).
#
# The base is the exact image every 1.71.02 instance runs, pinned by digest,
# so Kodbox (/kod_sources), the install scripts, the PHP extensions and the
# configuration stay as they were. Nothing else from this repository goes
# into the image. release/verify-image.sh is the release gate.
ARG PHP83_MIN_VERSION=8.3.6-0ubuntu0.24.04.14
FROM repo.cylo.net/kodbox@sha256:b161557dd488a25285fda4d999f07a3eac8295c4a6ee8b78da05e6656438d4a1
ARG PHP83_MIN_VERSION
# Upgrade exactly the installed packages built from the php8.3 source
# package. Conffiles the image already has are kept.
RUN set -eu; \
    pkgs=$(dpkg-query -W -f='${db:Status-Abbrev}|${Package}|${source:Package}\n' \
        | awk -F'|' '$1 ~ /^ii/ && $3 == "php8.3" {print $2}'); \
    [ -n "$pkgs" ] || { echo "no php8.3 packages installed" >&2; exit 1; }; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends --only-upgrade \
        -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold $pkgs; \
    for pkg in $pkgs; do \
        version=$(dpkg-query -W -f='${Version}' "$pkg"); \
        dpkg --compare-versions "$version" ge "$PHP83_MIN_VERSION" \
            || { echo "$pkg $version is older than $PHP83_MIN_VERSION" >&2; exit 1; }; \
    done; \
    rm -rf /var/lib/apt/lists/*; \
    php-fpm8.3 -t
LABEL net.cylo.php83-min-version="${PHP83_MIN_VERSION}"
