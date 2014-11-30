require "formula"

class Texlive < Formula
  homepage "http://www.tug.org/texlive/"

  url "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
  sha1 "7978e359c733a82685a437c560f2863233ff6165"
  version "20141120"

  option "with-full", "install everything"
  option "with-medium", "install small + more packages and languages"
  option "with-small", "install basic + xetex, metapost, a few languages [default]"
  option "with-basic", "install plain and latex"
  option "with-minimal", "install plain only"

  def install
    scheme = %w[full medium small basic minimal].find {
      |x| build.with? x
    } || "small"

    ohai "Downloading and installing TeX Live. This will take a few minutes."
    ENV["TEXLIVE_INSTALL_PREFIX"] = prefix
    system "./install-tl", "-scheme", scheme, "-portable", "-profile", "/dev/null"

    binarch = bin/"x86_64-linux"
    man1.install Dir[binarch/"man/man1/*"]
    man5.install Dir[binarch/"man/man5/*"]
    bin.install_symlink Dir[binarch/"*"]
  end

  test do
    system "#{bin}/tex --version"
  end
end
