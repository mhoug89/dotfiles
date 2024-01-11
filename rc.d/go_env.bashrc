# Add `go` binary's directory to our PATH var.
GO_BIN_PARENT_DIR="$(go env GOPATH 2>/dev/null)"
path_append "${GO_BIN_PARENT_DIR}/bin"
unset GO_BIN_PARENT_DIR
