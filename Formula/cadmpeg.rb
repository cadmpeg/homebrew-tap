class Cadmpeg < Formula
  desc "Convert and inspect native CAD files."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.0/cadmpeg-aarch64-apple-darwin.tar.xz"
      sha256 "6731f9da45572430311346777c87d9f2143a4156aad30b884571b98b2c615f1a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.0/cadmpeg-x86_64-apple-darwin.tar.xz"
      sha256 "ca7afaa10d686710c697701a96d51ec46aa35c2f9243f0ea8093313f58a51977"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.0/cadmpeg-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "97e009e58ed58a3505654439ff95751ba13253e53f05ea8c48f11022ce3fc9f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.6.0/cadmpeg-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "837f0c3775390c3e986ce787e40b4f5291f39d54b8c4135a561361e3160ee2ff"
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
