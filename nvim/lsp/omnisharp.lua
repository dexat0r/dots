return {
    settings = {
        RoslynExtensionsOptions = {
            enableDecompilationSupport = true
        }
    },
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
        ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
        ["textDocument/references"] = require('omnisharp_extended').references_handler,
        ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
    },
    on_attach = function()
        vim.keymap.set("n", "grd", require("omnisharp_extended").telescope_lsp_definition, { desc = "Go to definition", noremap = true })
    end
}
