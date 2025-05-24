# Add `go` binary's directory to our PATH var.
if [[ -d "/usr/local/go/bin" ]]; then
  path_prepend "/usr/local/go/bin"
fi

GO_BIN_PARENT_DIR="$(go env GOPATH 2>/dev/null)"
if [[ -n "${GO_BIN_PARENT_DIR}" ]]; then
  path_append "${GO_BIN_PARENT_DIR}/bin"
fi
unset GO_BIN_PARENT_DIR
