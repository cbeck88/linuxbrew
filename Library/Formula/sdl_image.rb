require 'formula'

class SdlImage < Formula
  homepage 'http://www.libsdl.org/projects/SDL_image'
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz'
  sha1 '5e3e393d4e366638048bbb10d6a269ea3f4e4cf2'
  revision 1

  # This patch fixes a bug in the SDL image configuration file, which causes it to be confused if libraries
  # are supplied in both system dirs and environment variables, leading to it running configuration against
  # the specified version while linking the binary with system-provided version. Linuxbrew issue #172.
  patch :DATA

  bottle do
    cellar :any
    revision 1
    sha1 "8748809171bc755a7e359d6b229a1803eba5a3a8" => :yosemite
    sha1 "f9d44a7ab0a8b97ff542f6b005cdc2d57a41884a" => :mavericks
    sha1 "92e68a5f6681dfc0f884dfea752804c3876bf9d5" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'jpeg'    => :recommended
  depends_on 'libpng'  => :recommended
  depends_on 'libtiff' => :recommended
  depends_on 'webp'    => :recommended

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace 'SDL_image.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "LDFLAGS=-L#{HOMEBREW_PREFIX}/bin"
    system "make install"
  end
end
__END__
diff --git a/configure b/configure
index 62db8fc..57ecc84 100755
--- a/configure
+++ b/configure
@@ -12790,7 +12790,7 @@ find_lib()
     else
         host_lib_path="/usr/$base_libdir /usr/local/$base_libdir"
     fi
-    for path in $gcc_bin_path $gcc_lib_path $env_lib_path $host_lib_path; do
+    for path in $env_lib_path $gcc_bin_path $gcc_lib_path $host_lib_path; do
         lib=`ls -- $path/$1 2>/dev/null | sort | sed 's/.*\/\(.*\)/\1/; q'`
         if test x$lib != x; then
             echo $lib
diff --git a/configure.in b/configure.in
index e7010e9..076c63b 100644
--- a/configure.in
+++ b/configure.in
@@ -103,7 +103,7 @@ find_lib()
     else
         host_lib_path="/usr/$base_libdir /usr/local/$base_libdir"
     fi
-    for path in $gcc_bin_path $gcc_lib_path $env_lib_path $host_lib_path; do
+    for path in $env_lib_path $gcc_bin_path $gcc_lib_path $host_lib_path; do
         lib=[`ls -- $path/$1 2>/dev/null | sort | sed 's/.*\/\(.*\)/\1/; q'`]
         if test x$lib != x; then
             echo $lib

