local jdtls = require('jdtls')
local cmp = require('cmp')
local home = os.getenv('HOME')

-- jdtls sends this command when it wants to reload bundles; nvim-jdtls
-- doesn't register it by default, causing a visible error notification.
vim.lsp.commands['_java.reloadBundles.command'] = function() return {} end

cmp.setup.filetype('java', {
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>']     = cmp.mapping.abort(),
        ['<CR>']      = cmp.mapping.confirm({ select = false }),
        ['<Tab>']     = cmp.mapping.select_next_item(),
        ['<S-Tab>']   = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }),
})

-- Marker order matters: find_root stops at the FIRST ancestor containing any
-- listed marker. `build.gradle` used to be in this list, so in a multi-module
-- build it matched modules/<name>/build.gradle and rooted jdtls at the
-- submodule — importing it without the rest of the project, which reads as
-- "LSP not working" (no cross-module navigation, half the classpath missing).
-- settings.gradle exists once, at the root, and never in a submodule.
local root_dir = require('jdtls.setup').find_root({
    'settings.gradle', 'settings.gradle.kts', 'gradlew', 'mvnw', 'pom.xml', '.git',
}) or vim.fn.getcwd()

-- Workspace name is derived from the resolved ROOT, not from getcwd(). getcwd()
-- meant launching nvim from a subdirectory created a second workspace for the
-- same project, and worktrees sharing a basename collided. The path hash also
-- makes stale caches self-healing: change the markers above and the root moves,
-- the name changes with it, and the old workspace is simply never read again
-- rather than silently serving a bad import.
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = home .. '/.local/share/jdtls/workspaces/'
    .. project_name .. '-' .. vim.fn.sha256(root_dir):sub(1, 8)

local config = {
    cmd = {
        home .. '/.sdkman/candidates/java/26-amzn/bin/java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Xmx2g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', vim.fn.glob('/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration', home .. '/.local/share/jdtls/config_linux',
        '-data', workspace_dir,
    },
    root_dir = root_dir,
    on_exit = function(code, signal)
        if code == 13 then
            vim.schedule(function()
                vim.fn.delete(workspace_dir, 'rf')
                vim.notify(
                    'jdtls: workspace corrupted (exit 13), reset and ready to restart.\nReopen file or run :e to reload.',
                    vim.log.levels.WARN
                )
            end)
        end
    end,
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = 'JavaSE-26',
                        path = home .. '/.sdkman/candidates/java/26-amzn',
                        default = true,
                    },
                },
            },
            import = {
                gradle = {
                    enabled = true,
                    wrapper = { enabled = true },
                    java = { home = home .. '/.sdkman/candidates/java/26-amzn' },
                },
            },
            format = {
                settings = {
                    url = 'https://raw.githubusercontent.com/fgonzal/.dotfiles/main/VSCode/java-formatter.xml',
                },
            },
        },
    },
    on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        -- Mirror existing coc keybindings
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        local function deduped_code_action()
            local seen = {}
            vim.lsp.buf.code_action({
                filter = function(action)
                    if seen[action.title] then return false end
                    seen[action.title] = true
                    return true
                end,
            })
        end
        vim.keymap.set({ 'n', 'x' }, '<leader>a', deduped_code_action, opts)
        vim.keymap.set('n', '<leader>qf', deduped_code_action, opts)
        vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<space>a', function()
            if #vim.diagnostic.get(0) == 0 then
                vim.notify('No diagnostics', vim.log.levels.INFO)
            else
                vim.diagnostic.setloclist()
            end
        end, opts)
        local diag_float_win = nil
        vim.api.nvim_create_autocmd('CursorHold', {
            buffer = bufnr,
            callback = function()
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if vim.api.nvim_win_get_config(win).relative ~= '' then
                        return
                    end
                end
                local _, win = vim.diagnostic.open_float(nil, { focus = false })
                diag_float_win = win
            end,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            buffer = bufnr,
            callback = function()
                if diag_float_win and vim.api.nvim_win_is_valid(diag_float_win) then
                    vim.api.nvim_win_close(diag_float_win, false)
                    diag_float_win = nil
                end
            end,
        })
        vim.keymap.set('n', '<leader>fo', require('telescope.builtin').lsp_document_symbols, opts)
        vim.keymap.set('n', '<space>o',  require('telescope.builtin').lsp_document_symbols, opts)
        -- jdtls extras
        vim.keymap.set('n', '<leader>ac', deduped_code_action, opts)
        vim.keymap.set('n', '<leader>oi', jdtls.organize_imports, opts)
        vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
        vim.keymap.set('x', '<leader>f', function()
            vim.lsp.buf.format({
                range = {
                    ['start'] = vim.api.nvim_buf_get_mark(0, '<'),
                    ['end']   = vim.api.nvim_buf_get_mark(0, '>'),
                }
            })
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
        end, opts)
    end,
    capabilities = (function()
        local caps = require('cmp_nvim_lsp').default_capabilities()
        caps.textDocument.completion.completionItem.resolveSupport = {
            properties = { 'documentation', 'detail', 'additionalTextEdits' }
        }
        return caps
    end)(),
}

jdtls.start_or_attach(config)

-- :JdtlsResetWorkspace — nuke this project's cached import and restart. The
-- hashed name above makes stale caches self-heal when the root moves, but a
-- workspace can still corrupt in place (jdtls exits 13, handled in on_exit) or
-- go stale after a large dependency change.
vim.api.nvim_buf_create_user_command(0, 'JdtlsResetWorkspace', function()
    for _, client in ipairs(vim.lsp.get_clients({ name = 'jdtls' })) do
        client:stop()
    end
    vim.fn.delete(workspace_dir, 'rf')
    vim.notify('jdtls: workspace cleared (' .. workspace_dir .. ')\nRun :e to re-import.',
        vim.log.levels.INFO)
end, { desc = 'Delete this project\'s jdtls workspace and restart the server' })
