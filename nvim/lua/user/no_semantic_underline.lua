-- Disable semantic-token underlines for common highlight groups
return {
  ["@lsp.type.property"]  = { style = "NONE" },
  ["@lsp.type.field"]     = { style = "NONE" },
  ["@lsp.type.variable"]  = { style = "NONE" },
  ["@lsp.type.parameter"] = { style = "NONE" },
}
