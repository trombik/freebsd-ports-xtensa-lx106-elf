--- scripts/build/internals.sh.orig	2019-11-11 06:13:50 UTC
+++ scripts/build/internals.sh
@@ -13,7 +13,7 @@ do_finish() {
 
     if [ "${CT_STRIP_HOST_TOOLCHAIN_EXECUTABLES}" = "y" ]; then
         case "$CT_HOST" in
-            *darwin*)
+            *freebsd*)
                 strip_args=""
                 ;;
             *freebsd*)
