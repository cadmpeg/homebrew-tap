class Cadmpeg < Formula
  desc "Inspect, convert, compare, and validate CAD files from the command line."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.1/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "61750c28fafba9c7fa07c2cc83c8fd393d3a640c5589a0072763742595a6302a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.1/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "c4291699aa15f5190f32eb38f9a080b1f1c9fd83bbf67b6329f7d4e941491aaa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.1/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a0f992a58e921cc3f76b0339ae69835651058bc8145eb11268e64964f182fc5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.1/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5d77836cb2e1b75cab17c69bbf50fe901a3c1e655e48bc2dc0f283c7079f6d30"
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
