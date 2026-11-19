# php7.2 patches

Each `*.patch` file here is added to Ubuntu's php7.2 quilt series in name
order, so prefix them with a number (`0001-...`). Patches must apply to the
`php7.2-7.2.24` source tree with `-p1`; the build fails if one does not.

Bump `PHP72_LOCAL_SUFFIX` in the Dockerfile (`+cylo1`, `+cylo2`, ...) whenever
the set of patches changes, and add a regression check under
`release/regression/` for the issue each patch fixes.

## Patches

- `0001-CVE-2026-109618-109619.patch`: PHP 7.2 port of php-src's minimal
  mitigation for CVE-2026-109618 and CVE-2026-109619 (Canonical's php8.1
  8.1.2-1ubuntu2.28 patch, php-src 1d7dec178a0). The patch header maps each
  8.1 hunk to 7.2. Behaviour changes: memory exhaustion ends the PHP process
  (an FPM worker exits with status 1, the client gets no response, and
  shutdown functions do not run; the message is in the FPM log), and
  `session.upload_progress.enabled` no longer has any effect.
- `0002-CVE-2026-11-19-php-src.patch`: PHP 7.2 port of the php-src security
  fixes released on 19 November 2026 with 8.2.36/8.3.37/8.4.28/8.5.13 that
  apply to 7.2 (CVE-2026-129289 FPM request smuggling, CVE-2026-126714
  session file truncation, CVE-2026-129496 error-log timestamps,
  CVE-2026-128064 HTTPS/FTPS scheme case, CVE-2026-128090 phar signature
  downgrade, CVE-2026-129538 CGI PATH_INFO, CVE-2026-15353 and
  CVE-2026-129506 SOAP). Identical to rutorrent-app's php72-cylo3 branch;
  the patch header maps each hunk to its upstream PHP-8.2 commit.
