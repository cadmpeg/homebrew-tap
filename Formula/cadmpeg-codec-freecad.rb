class CadmpegCodecFreecad < Formula
  desc "Read and write FreeCAD FCStd document archives."
  homepage "https://github.com/cadmpeg/cadmpeg"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-codec-freecad-aarch64-apple-darwin.tar.xz"
      sha256 "d9f89c53727d666d907cb6f660f73a093bb34ecaeccfa7791e8890d445c63942"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-codec-freecad-x86_64-apple-darwin.tar.xz"
      sha256 "d87828f83614e41642e7375f8b3e434ea3add4700d92fc3ad11901140d7eff64"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-codec-freecad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e108c1c42969158e1f6c228d8516b4b2f568038b1371339ad18a2d9858ae2c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cadmpeg/cadmpeg/releases/download/v0.3.1/cadmpeg-codec-freecad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d1cf42df801d7e53dd9d65531df3ffe2468316bca35233431e09ec70514d86f1"
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
    bin.install "fcstd-profile" if OS.mac? && Hardware::CPU.arm?
    bin.install "fcstd-profile" if OS.mac? && Hardware::CPU.intel?
    bin.install "fcstd-profile" if OS.linux? && Hardware::CPU.arm?
    bin.install "fcstd-profile" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
