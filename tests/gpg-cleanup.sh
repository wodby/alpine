#!/usr/bin/env bash
# Exercise cleanup races without depending on a public keyserver.
set -euo pipefail
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
test_root=$(mktemp -d)
trap 'rm -rf "${test_root}"' EXIT
mkdir -p "${test_root}/bin"
cat > "${test_root}/bin/gpg" <<'SH'
#!/usr/bin/env bash
echo "$GNUPGHOME" > "$CASE_DIR/keyring"
[[ " $* " == *' --recv-keys '* ]] && exit 0
[[ "$CASE_MODE" != invalid ]] || exit 1
if [[ " $* " == *' --decrypt '* ]]; then
  printf 'plaintext' > "$4"
fi
SH
cat > "${test_root}/bin/gpgconf" <<'SH'
#!/usr/bin/env bash
exit 0
SH
cat > "${test_root}/bin/rm" <<'SH'
#!/usr/bin/env bash
echo attempt >> "$CASE_DIR/cleanup"
[[ "$CASE_MODE" != blocked ]] || { echo 'cleanup denied' >&2; exit 1; }
/bin/rm "$@"
if [[ "$CASE_MODE" == race && $(wc -l < "$CASE_DIR/cleanup") -eq 1 ]]; then
  echo 'socket disappeared during cleanup' >&2
  exit 1
fi
SH
chmod +x "${test_root}"/bin/*
for helper in gpg_verify gpg_decrypt; do
  for mode in normal race invalid blocked; do
    case_dir="${test_root}/${helper}-${mode}"
    mkdir -p "$case_dir"
    touch "$case_dir/input" "$case_dir/output"
    result=0
    PATH="${test_root}/bin:$PATH" CASE_DIR="$case_dir" CASE_MODE="$mode" \
      DEBUG= GPG_KEYS=test bash "$repo_root/bin/$helper" \
      "$case_dir/input" "$case_dir/output" > "$case_dir/log" 2>&1 || result=$?
    case "$mode" in
      normal|race)
        [[ "$result" == 0 && ! -e "$case_dir/input" && ! -d "$(cat "$case_dir/keyring")" ]]
        [[ $(wc -l < "$case_dir/cleanup") -eq $([[ "$mode" == race ]] && echo 2 || echo 1) ]]
        ;;
      invalid) [[ "$result" != 0 && ! -e "$case_dir/cleanup" && -e "$case_dir/input" ]] ;;
      blocked) [[ "$result" != 0 && -e "$case_dir/input" ]]; grep -q 'cleanup denied' "$case_dir/log" ;;
    esac
    /bin/rm -rf "$(cat "$case_dir/keyring")"
  done
done
echo 'GPG cleanup tests passed'
