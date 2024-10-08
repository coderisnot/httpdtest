dnl modules enabled in this directory by default

APACHE_MODPATH_INIT(proxy)

proxy_objs="mod_proxy.lo proxy_util.lo"
APACHE_MODULE(proxy, Apache proxy module, $proxy_objs, , most)

proxy_connect_objs="mod_proxy_connect.lo"
proxy_ftp_objs="mod_proxy_ftp.lo"
proxy_http_objs="mod_proxy_http.lo"
proxy_fcgi_objs="mod_proxy_fcgi.lo"
proxy_scgi_objs="mod_proxy_scgi.lo"
proxy_uwsgi_objs="mod_proxy_uwsgi.lo"
proxy_fdpass_objs="mod_proxy_fdpass.lo"
proxy_ajp_objs="mod_proxy_ajp.lo ajp_header.lo ajp_link.lo ajp_msg.lo ajp_utils.lo"
proxy_wstunnel_objs="mod_proxy_wstunnel.lo"
proxy_balancer_objs="mod_proxy_balancer.lo"

case "$host" in
  *os2*)
    # OS/2 DLLs must resolve all symbols at build time and
    # these sub-modules need some from the main proxy module
    proxy_connect_objs="$proxy_connect_objs mod_proxy.la"
    proxy_ftp_objs="$proxy_ftp_objs mod_proxy.la"
    proxy_http_objs="$proxy_http_objs mod_proxy.la"
    proxy_fcgi_objs="$proxy_fcgi_objs mod_proxy.la"
    proxy_scgi_objs="$proxy_scgi_objs mod_proxy.la"
    proxy_uwsgi_objs="$proxy_uwsgi_objs mod_proxy.la"
    proxy_fdpass_objs="$proxy_fdpass_objs mod_proxy.la"
    proxy_ajp_objs="$proxy_ajp_objs mod_proxy.la"
    proxy_wstunnel_objs="$proxy_wstunnel_objs mod_proxy.la"
    proxy_balancer_objs="$proxy_balancer_objs mod_proxy.la"
    ;;
esac

APACHE_MODULE(proxy_connect, Apache proxy CONNECT module.  Requires --enable-proxy., $proxy_connect_objs, , most, , proxy)
APACHE_MODULE(proxy_ftp, Apache proxy FTP module.  Requires --enable-proxy., $proxy_ftp_objs, , most, , proxy)
APACHE_MODULE(proxy_http, Apache proxy HTTP module.  Requires --enable-proxy., $proxy_http_objs, , most, , proxy)
APACHE_MODULE(proxy_fcgi, Apache proxy FastCGI module.  Requires --enable-proxy., $proxy_fcgi_objs, , most, , proxy)
APACHE_MODULE(proxy_scgi, Apache proxy SCGI module.  Requires --enable-proxy., $proxy_scgi_objs, , most, , proxy)
APACHE_MODULE(proxy_uwsgi, Apache proxy UWSGI module.  Requires --enable-proxy., $proxy_uwsgi_objs, , most, , proxy)
APACHE_MODULE(proxy_fdpass, Apache proxy to Unix Daemon Socket module.  Requires --enable-proxy., $proxy_fdpass_objs, , most, [
  if test $ap_has_fdpassing = 0; then
    enable_proxy_fdpass=no
  fi
],proxy)
APACHE_MODULE(proxy_wstunnel, Apache proxy Websocket Tunnel module.  Requires --enable-proxy., $proxy_wstunnel_objs, , most, , proxy)
APACHE_MODULE(proxy_ajp, Apache proxy AJP module.  Requires --enable-proxy., $proxy_ajp_objs, , most, [
  # Don't export all the ajp_* functions.
  if test "x$enable_proxy_ajp" = "xshared"; then
     APR_ADDTO(MOD_PROXY_AJP_LDADD, [-export-symbols-regex proxy_ajp_module])
  fi], proxy)
APACHE_MODULE(proxy_balancer, Apache proxy BALANCER module.  Requires --enable-proxy., $proxy_balancer_objs, , most, , proxy)

APACHE_MODULE(serf, [Reverse proxy module using Serf], , , no, [
    APACHE_CHECK_SERF
    if test "$ac_cv_serf" = "yes" ; then
      APR_ADDTO(MOD_SERF_LDADD, [\$(SERF_LIBS)])
    else
      enable_serf=no
    fi
])

APACHE_MODULE(proxy_express, mass reverse-proxy module. Requires --enable-proxy., , , most, , proxy)
APACHE_MODULE(proxy_hcheck, [reverse-proxy health-check module. Requires --enable-proxy and --enable-watchdog.], , , most, , [proxy,watchdog])

APR_ADDTO(INCLUDES, [-I\$(top_srcdir)/$modpath_current -I\$(top_srcdir)/modules/http2])

APACHE_MODPATH_FINISH

