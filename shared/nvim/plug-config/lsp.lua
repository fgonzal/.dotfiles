-- Native LSP + completion. Replaces coc.nvim (removed 2026-08-14).
--
-- Background: coc was serving exactly one language server, coc-sh, because that
-- was the only coc extension installed. Java already ran on nvim-jdtls with coc
-- explicitly disabled for it, nvim-lspconfig was loaded but configured nothing,
-- and nvim-cmp was set up only for the java filetype. So every gd/gr/K mapping
-- in the old plug-config/coc.vim did nothing outside bash.
--
-- Uses the nvim 0.11 vim.lsp.config/enable API rather than the deprecated
-- lspconfig.<server>.setup{}. Server defaults come from nvim-lspconfig's lsp/
-- directory; the calls below only add what differs.

local cmp = require('cmp')

-- Completion, global. Previously this existed only inside a
-- cmp.setup.filetype('java', ...) call in ftplugin/java.lua, which is why coc
-- owned <CR> everywhere else. Same keys as the java block so nothing changes
-- under your fingers.
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>']     = cmp.mapping.abort(),
        ['<CR>']      = cmp.mapping.confirm({ select = false }),
        ['<Tab>']     = cmp.mapping.select_next_item(),
        ['<S-Tab>']   = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources(
        { { name = 'nvim_lsp' } },
        -- Fallback for buffers with no language server. coc did word completion
        -- out of the box; without these, non-LSP filetypes would lose it.
        { { name = 'buffer' }, { name = 'path' } }
    ),
})

-- Attach cmp's capabilities to every server rather than repeating it per-server.
vim.lsp.config('*', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- lua-language-server was installed via mason by an older config and left
-- unused; mason.nvim itself is no longer in the plugin list, so the binary is an
-- orphan and has to be named explicitly rather than found on PATH.
local mason_lua_ls = vim.fn.expand('~/.local/share/nvim/mason/bin/lua-language-server')
if vim.fn.executable(mason_lua_ls) == 1 then
    vim.lsp.config('lua_ls', {
        cmd = { mason_lua_ls },
        settings = {
            Lua = {
                -- Stops "undefined global vim" across this whole config.
                diagnostics = { globals = { 'vim' } },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    })
    vim.lsp.enable('lua_ls')
end

-- Replaces coc-sh. Install with: sudo pacman -S bash-language-server
-- Guarded so a missing binary is a silent no-op rather than a startup error;
-- it starts working the moment the package is installed, no config change.
if vim.fn.executable('bash-language-server') == 1 then
    vim.lsp.enable('bashls')
end

-- Diagnostics. coc.vim used signcolumn=number and showed diagnostics on
-- CursorHold; this keeps both behaviours.
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    severity_sort = true,
    float = { border = 'rounded', source = true },
})

-- Buffer-local maps, applied when any server attaches. These are the same keys
-- the old coc.vim bound, so muscle memory carries over.
--
-- Skipped for java: ftplugin/java.lua binds the same keys to jdtls-aware
-- versions -- a deduplicating code-action wrapper, range-aware formatting, its
-- own diagnostic float handling -- and LspAttach fires after on_attach, so
-- without this guard the generic versions would silently overwrite them.
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        if vim.bo[args.buf].filetype == 'java' then return end
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'x' }, '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
        vim.keymap.set('n', '[g', function() vim.diagnostic.jump({ count = -1 }) end, opts)
        vim.keymap.set('n', ']g', function() vim.diagnostic.jump({ count =  1 }) end, opts)
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<space>a', vim.diagnostic.setloclist, opts)
        vim.keymap.set('n', '<space>o', require('telescope.builtin').lsp_document_symbols, opts)
        vim.keymap.set('n', '<space>s', require('telescope.builtin').lsp_dynamic_workspace_symbols, opts)
    end,
})

-- :Format replaces the coc.vim command of the same name.
vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format() end, {})
