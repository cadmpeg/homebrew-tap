class Cadmpeg < Formula
  desc "Convert and inspect native CAD files."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.6.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.10/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "10f5e76aa2ff70b27bf20dddd9a0f939fcaf5130d77f1568b8801ff3feddbb28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.10/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "61e4c6dfb4574ea62ab184c497b20b80e249e9ece427c3d7c5d4d91ed2431968"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.10/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c2fdfb41e96d6826feeaf8c51c7143850e5107e67def556a2b55dace4dffa016"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.10/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "263c9b29c9a30b8f92064f4dd36eeb46df034fcedb5a49cd37d89989f6260d9b"
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
