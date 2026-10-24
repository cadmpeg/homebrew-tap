class Cadmpeg < Formula
  desc "Convert and inspect native CAD files."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.6.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.6/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "5fa8cc6f3056bae306938081a696c638b364349853b9682a1c767303347fa09d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.6/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "a47ec35f3681d00c4f1bdf08cdfa3175ef5d1108913861c4919b2d4e925b0d19"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.6/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "84af848907d993044c6e66604677c2378a69f4f968669e2e91392a512642ece6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.6/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2bf21d62289eecfce6cf810c8784d77135f6e6d094d879b8dd8fc12ae909a124"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cadmpeg"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cadmpeg"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cadmpeg"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cadmpeg"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
