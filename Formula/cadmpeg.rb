class Cadmpeg < Formula
  desc "Inspect, decode, validate, compare, and convert CAD models."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.0/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "06c676ff4ad9892be0a7bf5ede43dc2b67c172102d2819b6e4a0349d23f1057f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.0/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "862ee7243f8291783cf42c2b641bbeef4fa6a676bdc6bb8792562ed00401e553"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.0/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ff440f64f59074004259fbb39d854efb6d882d241bf3454930ce3dbc68ae335"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.0/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bc615aaf35a0431cab97e3def995b47f62521056a50189cad1c5b3b63b04b9b6"
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
