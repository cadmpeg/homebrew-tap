class Cadmpeg < Formula
  desc "Inspect, decode, validate, compare, and convert CAD models."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.6/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "23a77c076cd23055e8594735aa0b4c1341156dd049d5981344a9732802ed58b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.6/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "7ac6f72ea1486f17f963ea8f3babf3e149651920163eb98f83620c2ec8466638"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.6/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7487c30fb00c007c72c8e581377dc509a434f7380cd594a09eb3a616b3906474"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.6/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "188d83118e706854c03e2f00432cf5fd0253de7e8e9d24cc44f6cf036d4f066e"
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
    bin.install "cadmpeg" if OS.mac? && Hardware::CPU.arm?
    bin.install "cadmpeg" if OS.mac? && Hardware::CPU.intel?
    bin.install "cadmpeg" if OS.linux? && Hardware::CPU.arm?
    bin.install "cadmpeg" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
