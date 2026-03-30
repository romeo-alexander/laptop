-- Disable semantic-token underlines for common highlight groups
return {
  ["@lsp.type.property"]  = { underline = false },
  ["@lsp.type.field"]     = { underline = false },
  ["@lsp.type.variable"]  = { underline = false },
  ["@lsp.type.parameter"] = { underline = false },
}
