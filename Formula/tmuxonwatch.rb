class Tmuxonwatch < Formula
  desc "macOS server installer and launcher for tmux on watch"
  homepage "https://tmuxonwatch.com"
  url "https://github.com/beneaug/TerminalPulse/archive/refs/tags/tmuxonwatch-2026.02.28.4.tar.gz"
  version "2026.02.28.4"
  sha256 "481b68a5332fee6e22fa662f8766c454b33e0de69ff754c17b75d584267f57e7"
  license "Apache-2.0"

  depends_on "python@3.12"
  depends_on "tmux"

  def install
    libexec.install "install.sh"

    (libexec/"server").install "server/main.py"
    (libexec/"server").install "server/tmux_bridge.py"
    (libexec/"server").install "server/ansi_parser.py"
    (libexec/"server").install "server/requirements.txt"
    (libexec/"server").install "server/notify_event.py"

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
      cp "$SOURCE_ROOT/server/notify_event.py" "$SERVER_DIR/notify_event.py"
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
    assert_path_exists libexec/"install.sh"
    assert_path_exists libexec/"server/main.py"
    assert_path_exists libexec/"server/notify_event.py"
    assert_path_exists bin/"tmuxonwatch-install"
  end
end
