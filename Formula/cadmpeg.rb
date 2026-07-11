class Cadmpeg < Formula
  desc "Inspect, decode, validate, compare, and convert CAD models."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.4/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "d239d92256a2652b07733377f72d3f6c601acc20b4246e46d76d40acf6b89776"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.4/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "4822fb3e22a9f1e084c50ecc875e0934c6f0194868df24df6a0fbc8cfbdf137e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.4/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "afac9c0f1cbc080c442c1c5ad5256d4e528cf2679d8dc91c372c485bd5e1dff8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.4/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "85d15911ca8587b69976afb3ab2a3f6b165d1a9daaf7d2f6bfeab2331e38f47d"
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
