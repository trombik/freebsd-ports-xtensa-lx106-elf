--- scripts/build/internals.sh.orig	2021-01-13 05:48:34 UTC
+++ scripts/build/internals.sh
@@ -43,7 +43,7 @@ do_finish() {
 
     if [ "${CT_STRIP_HOST_TOOLCHAIN_EXECUTABLES}" = "y" ]; then
         case "$CT_HOST" in
-            *darwin*)
+            *freebsd*)
                 strip_args=""
                 ;;
             *freebsd*)
