class Cadmpeg < Formula
  desc "cadmpeg: an open-source CAD transcoder (ffmpeg for CAD). Command-line front-end."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.0/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "9a55da821312455eaa14e73cee2a0e5029b02f378b4a06c64dcb710fd0dd8931"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.0/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "c4f8df0658e6bf7b03a279abd6a6013cc9e60a3c109b48f4e4a1308c677930ac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.0/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ddba3980c74596834a67fcbd9344cb59d6b907f3119594ba87b04eb4589d724d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.1.0/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c7db2014ed8d0f732c349456dbcbc8d8b77c17aa50bbc2338810d8eb7b53b3b"
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
