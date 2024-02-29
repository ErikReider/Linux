return {
    formatCommand = "prettierd ${INPUT}",
    formatStdin = true,
    ["root-markers"] = {
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.js",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.json5",
        ".prettierrc.mjs",
        ".prettierrc.cjs",
        ".prettierrc.toml"
    }
}
