class CadmpegCodecNx < Formula
  desc "Read Parasolid geometry and topology from NX .prt files."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-codec-nx-aarch64-apple-darwin.tar.xz"
      sha256 "15c819caffead09adc197568ccdce401d6662708538df9c284786a337766eb28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-codec-nx-x86_64-apple-darwin.tar.xz"
      sha256 "805e92bf3aac8fd15a3fd2d5fdb2797604b0c7b726167ff9d55bb6415ba650a2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-codec-nx-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ee97ec9eaf214d6a5fe6995ed94b0d4b3341cbb60558cc1f02d35eb3dde92130"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.4.0/cadmpeg-codec-nx-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b5395cdeb2b7eca017aa2d85cce27dccaeeb35627a1f7d4f99810c248fe8637c"
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
