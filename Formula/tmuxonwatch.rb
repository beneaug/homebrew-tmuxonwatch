class Tmuxonwatch < Formula
  desc "tmuxonwatch macOS server installer and launcher"
  homepage "https://tmuxonwatch.com"
  url "https://github.com/beneaug/TerminalPulse/archive/0e47d3e3343324a6bae19507013f70f53c9f7101.tar.gz"
  version "2026.02.28.2"
  sha256 "620f99242a567febf2151404f40e30a205914a5ed43b34a283df7024e3437f4e"
  license "Apache-2.0"

  depends_on "python@3.12"
  depends_on "tmux"

  def install
    libexec.install "install.sh"

    (libexec/"server").install "server/main.py"
    (libexec/"server").install "server/tmux_bridge.py"
    (libexec/"server").install "server/ansi_parser.py"
    (libexec/"server").install "server/requirements.txt"

    (bin/"tmuxonwatch-install").write <<~BASH
      #!/usr/bin/env bash
      set -euo pipefail

      SOURCE_ROOT="#{libexec}"
      STAGING_ROOT="${TMUXONWATCH_STAGING_ROOT:-$HOME/tmuxonwatch/TerminalPulse}"
      SERVER_DIR="$STAGING_ROOT/server"

      mkdir -p "$SERVER_DIR"

      cp "$SOURCE_ROOT/install.sh" "$STAGING_ROOT/install.sh"
      cp "$SOURCE_ROOT/server/main.py" "$SERVER_DIR/main.py"
      cp "$SOURCE_ROOT/server/tmux_bridge.py" "$SERVER_DIR/tmux_bridge.py"
      cp "$SOURCE_ROOT/server/ansi_parser.py" "$SERVER_DIR/ansi_parser.py"
      cp "$SOURCE_ROOT/server/requirements.txt" "$SERVER_DIR/requirements.txt"
      chmod +x "$STAGING_ROOT/install.sh"

      exec bash "$STAGING_ROOT/install.sh" "$@"
    BASH
  end

  def caveats
    <<~EOS
      Next step:
        tmuxonwatch-install

      This command stages installer files under:
        ~/tmuxonwatch/TerminalPulse
    EOS
  end

  test do
    assert_predicate libexec/"install.sh", :exist?
    assert_predicate libexec/"server/main.py", :exist?
    assert_predicate bin/"tmuxonwatch-install", :exist?
  end
end
