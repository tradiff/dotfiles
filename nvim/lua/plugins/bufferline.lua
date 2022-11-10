require('bufferline').setup {
    options = {
        offsets = {{
            filetype = "NvimTree",
            text = "File Explorer"
        }},
        separator_style = "thick", -- "slant" | "thick" | "thin" | { 'any', 'any' },
        always_show_bufferline = true,
        hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
        },
        sort_by = 'insert_after_current' -- 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
    }
}
