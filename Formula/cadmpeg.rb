class Cadmpeg < Formula
  desc "Convert and inspect native CAD files."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.6.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.5/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "7b84007f3c3df0657ba632153a4b3a701b43d465368833adf7d628834c7c5517"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.5/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "ea99fef3d5c7338bfa154efa54a21146e951e4ab82dbed4995f3a37d03d55cee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.5/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b08ea962226cdaf730c88d69fbb196ef6c0c53eb706373d12a6f219b150b0442"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.5/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac3075536819c29974f0d4f14f14f0fe95d84533091e81790daea8c90bfa139f"
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
