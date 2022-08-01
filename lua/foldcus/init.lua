local ts_utils = require('nvim-treesitter.ts_utils')

local M = {}

M.get_root_node = function()
    local current_node = ts_utils.get_node_at_cursor()
    if not current_node then
        return nil
    end

    while current_node:parent() do
        current_node = current_node:parent()
    end

    return current_node
end

M.explore = function(first)
    local nodes = {}
    local curr = first
    while curr do
        table.insert(nodes, curr)
        if curr:child_count() > 0 then
            for _, child in ipairs(M.explore(curr:child())) do
                table.insert(nodes, child)
            end
        end
        curr = curr:next_sibling()
    end
    return nodes
end

M.on_comments = function(func)
    local all = M.explore(M.get_root_node())
    local cursor = vim.api.nvim_win_get_cursor(0)

    -- Hack because nvim_feedkeys appears to affect control flow if a mapping results in an error
    local backkeys = cursor[1] .. 'G' .. cursor[2] .. '|'

    for _, node in ipairs(all) do
        if node:type() == 'comment' then
            local srow, scol, erow, ecol = node:range()
            func(srow, scol, erow, ecol, backkeys)
        end
    end
end

M.fold = function(min)
    min = min or 0
    local startvisual = vim.api.nvim_replace_termcodes('<Esc>v', true, false, true)
    if not startvisual then
        return
    end

    local keys = ''
    M.on_comments(function(srow, scol, erow, ecol, backkeys)
        Diff = {srow, erow, erow - srow}
        if srow == erow or math.abs(erow - srow + 1) < min then
            return
        end
        keys = keys .. srow + 1 .. 'G' .. scol .. '|' .. startvisual .. erow + 1 .. 'G' .. ecol - 1 .. '|zf' .. backkeys
    end)
    vim.api.nvim_input(keys)
end

M.unfold = function(min)
    min = min or 0

    local keys = ''
    M.on_comments(function(srow, scol, erow, _, backkeys)
        if srow == erow or math.abs(erow - srow + 1) < min then
            return
        end

        keys = keys .. srow + 1 .. 'G' .. scol .. '|zD' .. backkeys
    end)
    vim.api.nvim_input(keys)
end

return M
