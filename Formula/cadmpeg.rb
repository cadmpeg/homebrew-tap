class Cadmpeg < Formula
  desc "Inspect, decode, validate, compare, and convert CAD models."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.5.2/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "3121d7dbff7674f658ca9436e38bca5edf68e1a8f54230d0d72fef404dda874b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.5.2/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "8aab8a0e301a542026c8d52072e1620240a9f736512af0edb9d7490542642c1f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.5.2/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6c775636057e7b19a4884d8c0bc945410b1d3ad73169503a7a1791a1135b8fd3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.5.2/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "faae6203e3b5feb7e5b1a6f15ef87b6f0fdaa8e1404845169a9b3127aa7ac654"
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
