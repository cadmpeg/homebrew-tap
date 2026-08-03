class CadmpegCodecNx < Formula
  desc "Read Parasolid geometry and topology from NX .prt files."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-codec-nx-aarch64-apple-darwin.tar.xz"
      sha256 "399823502f10e2fe34f36b86dbf19fb87845d2f1d0c52d3929a58e851eb7d2b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-codec-nx-x86_64-apple-darwin.tar.xz"
      sha256 "e0dd9c233cc421f4a5c0360b12076e2d44aba3e6400334d1aac113077138475f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-codec-nx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "68a49aa850884fbb5639029653b8ce14279329862411fb306975793f6f94000f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-codec-nx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3bba050f1321ede41c272a364867432a53460f2db3e65c92273986c04867ae6a"
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
    bin.install "nx_profile" if OS.mac? && Hardware::CPU.arm?
    bin.install "nx_profile" if OS.mac? && Hardware::CPU.intel?
    bin.install "nx_profile" if OS.linux? && Hardware::CPU.arm?
    bin.install "nx_profile" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
